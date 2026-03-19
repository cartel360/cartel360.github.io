---
layout: post
title: "Contract Testing: Prevent Breaking Changes Before Production"
categories: [Contract Testing, API Testing, Software Architecture]
image: /assets/img/contract-testing.png
tags: [Contract Testing, API Testing, Integration Testing, Microservices, Software Testing]
description: Learn how to implement contract testing between services to catch breaking changes before they hit production. Works across any tech stack—examples in .NET and Angular.
mermaid: true
---


> *“It worked locally. Tests passed. But production still broke.”*
{: .prompt-tip }

If you're building distributed systems with multiple services and frontends, you've likely encountered this (whether using **.NET + Angular**, **Node.js + React**, **Python + Vue**, or any combination):

* A backend change gets deployed
* The frontend suddenly breaks
* No tests warned you

The issue isn’t always logic.

It’s often a **broken contract between systems**.

---

# The Problem: Silent API Breakages

In a typical setup:

* Service Provider: An API or microservice
* Service Consumer: A frontend, app, or another service
* Communication: JSON over HTTP (or any protocol)

Everything depends on one thing:

> The consumer and provider agreeing on **what data looks like**

---

## A Real Example

Let's use a **.NET API** and **Angular frontend** as an example (though this applies to any tech stack).

### API Provider (Initial Version)

```csharp
public class UserDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
}
```

```csharp
[HttpGet("{id}")]
public IActionResult GetUser(int id)
{
    return Ok(new UserDto
    {
        Id = 1,
        Name = "Billy",
        Email = "billy@example.com"
    });
}
```

---

### Consumer Interface (Angular Example)

```ts
export interface User {
  id: number;
  name: string;
  email: string;
}
```

Everything works perfectly.

---

## Then a “Small” Change Happens

```csharp
public class UserDto
{
    public int Id { get; set; }
    public string FullName { get; set; } // renamed
    public string Email { get; set; }
}
```

---

### Production Result

```ts
user.name //  undefined
```

The UI breaks.

---

## Why Didn't Traditional Tests Catch This?

* Unit tests → passed (backend logic is fine)
* Integration tests → passed (they used the old model)
* The API still returns valid JSON

But the **contract between systems changed**—and traditional tests don't verify that.

---

# What is Contract Testing?

> **Contract testing ensures that your service provider always matches what the consumer expects.**

A **contract** defines:

* Request format
* Response structure
* Required fields
* Data types

---

## In Simple Terms

> The **consumer** (frontend, app, or service) defines expectations
> The **provider** (API or service) must satisfy them

---

# Consumer vs Provider

### Consumer

* Calls the service/API
* Defines expected structure
* Examples: Angular frontend, React app, mobile app, another microservice

### Provider

* Returns the data
* Must not break expectations
* Examples: .NET API, Node.js backend, Python service, GraphQL endpoint

---

# How Contract Testing Works

Instead of relying only on integration tests:

1. Angular defines expectations
2. A contract file is generated
3. .NET verifies the contract

---

## Flow

```
Consumer Test (e.g., Angular)
      ↓
Generates Contract
      ↓
Saved as JSON/YAML
      ↓
Provider verifies against contract (e.g., .NET API)
```

---

# Practical Example

*(.NET backend + Angular frontend as an example)*

---

## Step 1: Define Expectations in Consumer (Angular example)

```ts
const expectedUser = {
  id: 1,
  name: "Billy",
  email: "billy@example.com"
};

it("should fetch user correctly", async () => {
  const user = await userService.getUser(1);
  expect(user).toEqual(expectedUser);
});
```

---

## Generated Contract (Simplified)

```json
{
  "request": {
    "method": "GET",
    "path": "/api/users/1"
  },
  "response": {
    "body": {
      "id": 1,
      "name": "Billy",
      "email": "billy@example.com"
    }
  }
}
```

---

## Step 2: Verify in Provider (.NET API example)

Install Pact:

```bash
dotnet add package PactNet
```

---

### Provider Test

```csharp
[Fact]
public void VerifyPact()
{
    var pactVerifier = new PactVerifier();

    pactVerifier
        .ServiceProvider("UserApi", "http://localhost:5000")
        .WithFileSource(new FileInfo("pacts/userapi-angular.json"))
        .Verify();
}
```

---

## If Provider Breaks the Contract

```csharp
public string FullName { get; set; }
```

- The test fails immediately

- You catch the issue before deployment

---

# Where Contract Testing Fits

```
E2E Tests
(user journeys)

Integration Tests
(service interactions)

Contract Tests 
(API agreements)

Unit Tests
(business logic)
```

---

# Why This Matters in Real Projects

## Safer Refactoring

Change DTOs, schema, or API responses without fear. Contract tests verify nothing broke.

---

## Independent Development

Consumer and provider teams move faster. Changes are caught instantly, not in production.

---

## Faster Debugging

Failures clearly show what broke

---

## Stronger CI/CD Pipelines

```
Consumer Build → Generate Contract
Provider Build → Verify Contract
Deploy → Only if both pass
```

This works with any tech stack.

---

# Common Mistakes

---

## Over-Specifying Data

Bad:

```json
"name": "Billy Okeyo"
```

Good:

```json
"name": "string"
```

---

## Testing Everything

Only validate fields your frontend actually uses

---

## Ignoring Versioning

Breaking contracts without versioning leads to production issues

---

# Best Practices

---

## Keep Contracts Minimal

Focus only on required fields

---

## Version Your API

```
/api/v1/users
/api/v2/users
```

---

## Automate in CI/CD

Contracts should be generated and verified automatically

---

## Use Realistic Data

Avoid unrealistic mocks

---

# Final Takeaway

> Unit tests verify logic
> Integration tests verify systems
> E2E tests verify user flows
>
> **Contract tests verify agreements**

---


> “Most production bugs aren’t failures… they’re misunderstandings between systems.”
{: .prompt-tip }

Contract testing eliminates those misunderstandings.

