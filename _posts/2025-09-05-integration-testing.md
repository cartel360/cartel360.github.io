---
layout: post
title: "Integration Testing in Depth : Test components working together (and not hate it) Part 3"
categories: [Testing, Integration-Testing, Software Development]
image: /assets/img/software-testing.webp
tags: [Testing, Software Development, Quality Assurance]
description: Integration tests sit in the sweet spot between tiny, fast unit tests and slow, expensive end-to-end tests. They verify that multiple parts of your system cooperate correctly — e.g., your API layer talks to the DB the way you expect, background jobs persist state, or your service correctly handles responses from an external API.
---


Integration tests sit in the sweet spot between tiny, fast unit tests and slow, expensive end-to-end tests. They verify that multiple parts of your system cooperate correctly e.g., your API layer talks to the DB the way you expect, background jobs persist state, or your service correctly handles responses from an external API.

This post is a practical, language-agnostic guide to integration testing, plus **side-by-side, runnable patterns** for **Python**, **C# (.NET)**, **TypeScript (Node/Express)** and **PHP (Laravel)** so you can immediately apply the ideas in your stack.


## What integration tests are (and are not)

**Integration tests** verify behavior across component boundaries, multiple classes, modules, services or infrastructure pieces that would not be exercised by a unit test.

**They are not:**

* A replacement for unit tests (they’re slower & coarser).
* Full UI-driven E2E tests (unless you intentionally include the UI).

**They are good for:**

* Verifying DB reads/writes via your data access layer.
* Testing service-to-service interactions.
* Ensuring message queue jobs and workers together produce expected state.
* Checking how your app handles external API payloads (with a mock or stub of that API).


## Goals & tradeoffs

**Goals**

* Catch bugs that only appear when components are wired together.
* Validate API contracts inside your own system.
* Give more realistic coverage than unit tests.

**Tradeoffs**

* Slower than unit tests.
* Harder to make fully deterministic (external services, timing).
* Need careful setup/teardown to stay reliable.


## Core patterns & recommendations

### 1. Use realistic but controlled dependencies

* Prefer a **real database** (or the same engine, e.g., PostgreSQL) rather than mocking DB calls.
* For external services (payment gateways, email providers), use **service doubles**: a local mock server, WireMock, or HTTP interceptors (nock, responses, Http::fake). Don’t call the live service in CI.

### 2. Isolate tests

* Run each test in a transaction and roll it back (if possible), or recreate schema between tests.
* Or give each test its own ephemeral database (unique DB name/per-worker) when running tests in parallel.

### 3. Keep tests focused

* Each integration test should exercise a meaningful interaction or flow (e.g., API -> DB, or API -> external-service-stub -> DB), not every possible path.

### 4. Seed deterministic test data

* Use builders/fixtures to create known state. Avoid random data unless seeded.

### 5. Manage long-running processes

* For queues/workers, either run workers synchronously in tests, use a fake queue, or spin up a test worker process in CI.

### 6. Use testcontainers or docker-compose in CI

* For close-to-production fidelity, use Testcontainers (or docker-compose) to provision real DBs and services in CI.

### 7. Avoid flaky tests

* No sleeps/time-based races. Use blocking signals, polling with timeouts, or deterministic stubs.


## When to mock vs when to use real services

* **Real DB**: Prefer real DB engine (Postgres, MySQL). SQLite is OK for many cases but can mask engine-specific issues.
* **External APIs**: Mock in integration tests. Use contract testing (Pact) to keep mocked expectations in-sync.
* **Caches/Queues**: Use in-memory or test doubles unless you must validate the actual middleware behavior.


## Observability: make debugging failing integration tests easy

* Emit structured logs during tests (include request IDs).
* Capture and print responses and DB state on failure.
* Keep helpful assertion messages.


## Checklist: test lifecycle

1. Create test environment (DB, migrations applied).
2. Seed minimal deterministic data.
3. Execute action via real interfaces (HTTP client, direct call).
4. Assert state persisted, side effects happened (e.g., DB row created, message pushed, HTTP call stubbed).
5. Tear down (transaction rollback, truncate tables, drop DB).


## Common pitfalls & fixes

* **Flaky tests**: avoid sleep-based waiting; use retry-with-timeout polling and assert deterministically.
* **Slow setup**: keep per-test setup minimal; use transactional rollback where possible.
* **Parallel test collisions**: give tests separate DBs or use unique table prefixes.
* **“Works locally but fails in CI”**: mirror CI environment locally using Docker/Testcontainers and run tests there.


# Example integration tests (side-by-side)

Scenario used across examples:

> A `POST /users` endpoint that creates a user record in the database and triggers an HTTP call to an external email service (welcome email). Integration test will create a user via HTTP, verify DB row exists, and verify the email call was made (mocked).


## Python — FastAPI + SQLAlchemy + pytest + requests-mock

**Notes:** Use `sqlite:///:memory:` or a Testcontainers Postgres for higher fidelity in CI. `requests-mock` stubs outgoing HTTP calls.

```python
# app.py (pseudo)
from fastapi import FastAPI, Depends
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

app = FastAPI()

# App factory to pass different DB URLs in tests
def create_app(db_url, email_service_url):
    engine = create_engine(db_url)
    Session = sessionmaker(bind=engine)
    # create tables...
    app.state.db = Session
    app.state.email_url = email_service_url

    @app.post("/users")
    def create_user(payload: dict):
        sess = app.state.db()
        user = User(name=payload["name"], email=payload["email"])
        sess.add(user); sess.commit()
        # Send welcome email via requests.post(app.state.email_url, json=...)
        return {"id": user.id}

    return app
```

```python
# test_integration.py
import pytest
from fastapi.testclient import TestClient
import requests_mock
from app import create_app

@pytest.fixture
def client(tmp_path):
    # Use sqlite in-memory for speed or file DB for persistence across app
    app = create_app("sqlite:///:memory:", "http://email.test/send")
    client = TestClient(app)
    yield client

def test_create_user_and_send_email(client):
    with requests_mock.Mocker() as m:
        m.post("http://email.test/send", status_code=200, json={"ok": True})
        resp = client.post("/users", json={"name":"Alice","email":"a@example.com"})
        assert resp.status_code == 200
        user_id = resp.json()["id"]

        # Verify DB row exists (open a session)
        Session = client.app.state.db
        sess = Session()
        user = sess.query(User).filter_by(id=user_id).one_or_none()
        assert user is not None
        assert user.email == "a@example.com"

        # Verify external email call occurred
        assert m.called
        assert m.request_history[0].json() == {"to": "a@example.com", "template": "welcome"}
```

**Tips**

* For CI, replace sqlite with Testcontainers Postgres: `create_app(postgres_url, ...)`.
* Use DB migrations in setup if using a real DB.


## C# (.NET) — ASP.NET Core + WebApplicationFactory + InMemory DB / Testcontainer

**Notes:** Use `WebApplicationFactory<TEntryPoint>` to spin the app in tests and override service registrations for test doubles.

```csharp
// In Startup.cs, app reads EmailService via IEmailService (HttpEmailService in prod)

public class TestEmailService : IEmailService {
    public List<EmailMessage> Sent = new();
    public Task SendAsync(EmailMessage msg) { Sent.Add(msg); return Task.CompletedTask; }
}

// Integration test
public class UsersIntegrationTests : IClassFixture<WebApplicationFactory<Program>> {
    private readonly WebApplicationFactory<Program> _factory;

    public UsersIntegrationTests(WebApplicationFactory<Program> factory) {
        _factory = factory.WithWebHostBuilder(builder => {
            builder.ConfigureServices(services => {
                // Replace real DB with in-memory or Testcontainer; replace email service with TestEmailService
                services.AddSingleton<IEmailService, TestEmailService>();
                // Configure EF Core to use InMemoryDatabase or connection string from Testcontainers
            });
        });
    }

    [Fact]
    public async Task PostUsers_CreatesUser_And_SendsEmail() {
        var client = _factory.CreateClient();
        var content = new StringContent("{\"name\":\"Bob\",\"email\":\"b@ex.com\"}", Encoding.UTF8, "application/json");
        var resp = await client.PostAsync("/users", content);
        resp.EnsureSuccessStatusCode();

        // Verify DB: use scope to resolve DbContext
        using(var scope = _factory.Services.CreateScope()) {
            var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
            var user = db.Users.Single(u => u.Email == "b@ex.com");
            Assert.NotNull(user);
        }

        // Verify TestEmailService captured message
        var emailService = _factory.Services.GetRequiredService<IEmailService>() as TestEmailService;
        Assert.Single(emailService.Sent);
        Assert.Equal("welcome", emailService.Sent[0].Template);
    }
}
```

**Tips**

* For a real DB in CI, use `Testcontainers` .NET to spin up Postgres and set EF Core connection string.
* Overriding services avoids brittle HTTP stubbing, and keeps assertions in-process.


## TypeScript (Node/Express) — supertest + sqlite in-memory + nock

**Notes:** `supertest` issues HTTP requests to your Express app instance. Use `nock` to intercept outgoing HTTP.

```ts
// app.ts (pseudo)
import express from "express";
import bodyParser from "body-parser";
import { initDb } from "./db";

export function createApp(dbPath: string) {
  const app = express();
  app.use(bodyParser.json());
  const db = initDb(dbPath); // e.g., sqlite3 in-memory or file
  app.post("/users", async (req, res) => {
    const { name, email } = req.body;
    const id = await db.run("INSERT INTO users(name,email) VALUES(?,?)", [name, email]);
    // call external email service via fetch/http client
    await fetch("http://email.test/send", { method: "POST", body: JSON.stringify({ to: email, template: "welcome" }) });
    res.json({ id });
  });
  return app;
}
```

```ts
// test/integration.test.ts
import request from "supertest";
import nock from "nock";
import { createApp } from "../app";
import { openDb, getUserById } from "../db";

describe("POST /users", () => {
  it("creates a user and calls email service", async () => {
    const app = createApp(":memory:");
    const email = nock("http://email.test")
      .post("/send", (body) => body.to === "c@ex.com" && body.template === "welcome")
      .reply(200, { ok: true });

    const res = await request(app)
      .post("/users")
      .send({ name: "Carol", email: "c@ex.com" })
      .expect(200);

    // verify DB
    const user = await getUserById(res.body.id);
    expect(user.email).toBe("c@ex.com");

    // verify external call was made
    expect(email.isDone()).toBe(true);
  });
});
```

**Tips**

* For complex schemas, use migrations in test setup or run a dedicated test DB with `sqlite` file per test.
* For Postgres in CI, spin up DB via docker-compose or Testcontainers Node.


## PHP (Laravel) — HTTP tests + RefreshDatabase + Http::fake()

**Notes:** Laravel has excellent integration testing helpers. `RefreshDatabase` runs migrations and transacts where possible. Use `Http::fake()` to intercept external HTTP.

```php
// routes/api.php
Route::post('/users', [UserController::class, 'store']);

// UserController->store uses User model and Http::post('http://email.test/send', ...);

```

```php
// tests/Feature/CreateUserTest.php
<?php
namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;
use App\Models\User;

class CreateUserTest extends TestCase
{
    use RefreshDatabase;

    public function test_create_user_and_send_welcome_email()
    {
        Http::fake([
            'email.test/*' => Http::response(['ok' => true], 200),
        ]);

        $response = $this->postJson('/api/users', [
            'name' => 'Dan',
            'email' => 'd@ex.com',
        ]);

        $response->assertStatus(200);

        // verify DB
        $this->assertDatabaseHas('users', ['email' => 'd@ex.com']);

        // assert that an outbound call was made
        Http::assertSent(function ($request) {
            return $request->url() == 'http://email.test/send' &&
                   $request['to'] == 'd@ex.com' &&
                   $request['template'] == 'welcome';
        });
    }
}
```

**Tips**

* Laravel’s `RefreshDatabase` will use in-memory sqlite if configured, otherwise migrate a test DB.
* Use `Queue::fake()` to test that jobs were dispatched without executing background workers.


# Practical integration testing strategies

### Use transactions for isolation

* Wrap each test in a DB transaction and roll back at the end. Works well when everything runs in the same DB connection.
* Caveat: some ORMs/connections (e.g., tests that spawn separate processes) might not share transaction visibility.

### Use in-memory DBs for speed, but test on real DBs in CI

* SQLite in-memory is fast, but can behave differently (indexing, SQL dialect). Complement local tests with real-engine tests in CI using containers.

### Stubbing external HTTP reliably

* Python: `responses` or `requests-mock`
* Node: `nock`
* C#: WireMock.Net or replace typed `HttpClient` with test handler
* PHP: Laravel `Http::fake()`

### Testcontainers — real dependencies in CI

* Spin up a Postgres, Redis, or Kafka container for integration tests.
* Testcontainers exists for many ecosystems (Java, .NET, Node, Python wrappers).

### Contract testing for cross-team APIs

* Use Pact or similar to generate contracts from consumer tests and verify provider compliance in provider CI. This avoids brittle mocks and catches breaking API changes.

### Background jobs & queues

* Either run job handlers inline (synchronously) in tests, use fake queues that record enqueued messages, or run a worker process in CI that reads from test queue.


# How many integration tests should you write?

No fixed number. Aim for:

* Unit tests: many (business logic)
* Integration tests: enough to cover **critical integration points** (DB persistence, payment flows, auth)
* E2E tests: few (critical user paths)

A practical rule: write integration tests for **each major DB operation and for the essential external integrations**.


# Debugging failing integration tests

* Print request/response bodies and DB rows on failure.
* Capture network traffic (or enable higher logging).
* Reproduce the failing test locally with the same CI container setup (Testcontainers makes that easy).
* If a test is flaky, add instrumentation and increase visibility; temporary retries mask real issues.



# Sample integration test checklist

Before merging an integration test into CI:

* [ ] Test uses deterministic data.
* [ ] DB schema/migrations run and are applied in setup.
* [ ] External dependencies are stubbed or provided by test containers.
* [ ] Test cleans up (transaction rollback or truncation).
* [ ] No sleeps or time-based races.
* [ ] Test is focused on behavior, not implementation.


# Wrapping up & next steps

Integration tests reduce the mismatch between isolated units and the full system. They give higher confidence than unit tests while being cheaper and faster than full E2E tests. When designed well they catch boundary problems early and make refactoring safer.

**Next post in the series:** *End-to-End (E2E) Testing in Depth* — we’ll cover realistic end-to-end strategies, UI-driving vs API-only E2E, test environments, flaky UI tests, and how to design low-maintenance high-value E2E checks.

*Happy testing!*
