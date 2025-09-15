---
layout: post
title: "Unit Testing in Depth: Principles, Patterns, and Pragmatic Tactics - Part 2"
categories: [Testing, Unit-Testing, Software Development]
image: /assets/img/software-testing.webp
tags: [Testing, Software Development, Quality Assurance]
description: Unit tests are the safety net that let you refactor without fear, document behavior without docs, and ship with confidence. Done well, they’re fast, reliable, and cheap to maintain. Done poorly, they’re flaky, slow, and ignored.
---
Unit tests are the safety net that let you refactor without fear, document behavior without docs, and ship with confidence. Done well, they’re fast, reliable, and cheap to maintain. Done poorly, they’re flaky, slow, and ignored.

This is a continuation of the the **Unit, Integration, and End-to-End Tests: Building Confidence in Your Software** series. In case you missed it, be sure to check out the previous posts for a solid foundation. This guide goes deep into **what makes a great unit test**, how to structure them, how to avoid common pitfalls, and how to design code that’s *easy* to unit test.

## What is a “Unit” (really)?

A **unit** is the smallest piece of behavior you care about verifying typically a function, method, or class. The unit:

* Has **no external I/O** (no network, DB, filesystem, clock, randomness).
* Has **clear inputs and outputs** (return value or state change).
* Can be run thousands of times **deterministically** and **quickly**.

> Heuristic: if your test needs network access, sleeps, or a DB, it’s probably not a unit test.
> {: .prompt-tip}

## The Goal of Unit Tests

* **Prevent regressions** close to the source of truth.
* **Document behavior** by example.
* **Enable refactoring** with confidence.
* **Encourage good design** (loose coupling, small interfaces).

## Qualities of Great Unit Tests (F.I.R.S.T.)

* **Fast** – run in milliseconds; okay to run on every save/commit.
* **Isolated** – no shared state; independent from other tests.
* **Repeatable** – same result every run; no flakiness.
* **Self-validating** – clear pass/fail without manual inspection.
* **Timely** – written close to when the code is written (test-first or test-soon).

## Anatomy of a Readable Test

Use **Arrange–Act–Assert (AAA)** or **Given–When–Then**. Keep one behavior per test.

```bash
test "calculate_total when valid items then returns sum minus discounts" {
  // Arrange
  items = [10, 20, 30]
  discount = 0.1
  sut = PriceCalculator() // SUT = System/Subject Under Test

  // Act
  total = sut.calculate_total(items, discount)

  // Assert
  assert_equal(54, total) // (10+20+30)=60; 10% off => 54
}
```

### Naming patterns that scale

* `MethodName_WhenCondition_ShouldExpectedOutcome`
* `Given_State_When_Action_Then_Outcome`

Good names save hours of log-digging later.

## What to Test (and What Not to)

**Do test**

* Business rules and edge cases (boundaries, empties, nulls, negatives, overflows).
* Error handling (exceptions, validation messages).
* Idempotency and invariants (calling twice has same effect).
* Serialization/parsing for your own formats.

**Don’t test**

* Framework code you don’t control.
* Trivial getters/setters (unless there’s logic).
* UI layout or CSS (move to integration/E2E if needed).

## Test Data Without Pain

Messy data setup is the #1 cause of unreadable tests. Use **builders**.

```bash
order = OrderBuilder()
          .with_item("book", 20)
          .with_item("pen", 5)
          .with_discount(0.1)
          .build()
```

Patterns:

* **Test Data Builder**: fluent object construction.
* **Mother Object**: canonical “valid” objects you tweak per test.
* **Parameterized tests**: table-driven cases for variations.

## Test Doubles: Choose the Right Tool

Not everything should be “real” in a unit test. Replace collaborators with **test doubles**:

| Double          | Purpose                                             | Example                                  |
| --------------- | --------------------------------------------------- | ---------------------------------------- |
| **Dummy** | Filler to satisfy signatures                        | `new LoggerDummy()` that’s never used |
| **Stub**  | Provide canned returns                              | `ClockStub(now="2025-08-22")`          |
| **Spy**   | Record calls for later assertions                   | `EmailSpy.sent_to("a@b.com") == true`  |
| **Mock**  | Pre-programmed expectations (behavior verification) | `Expect(repo.save(order))`             |
| **Fake**  | Lightweight working impl                            | `InMemoryRepository` with a map        |

**Guideline:** Prefer **stubs/spies/fakes**. Use **mocks** when you truly care about the interaction contract (e.g., exactly one call, in a specific order). Over-mocking couples tests to implementation details.

## Taming Non-Determinism (Time, Randomness, Concurrency, I/O)

Flaky unit tests usually leak non-determinism. Isolate it behind interfaces:

### Time

Introduce a `Clock` port.

```bash
interface Clock { now(): Instant }
class SystemClock implements Clock { now() = system_now() }
class FixedClock(t) implements Clock { now() = t }
```

Inject `FixedClock` in tests.

### Randomness

Wrap the RNG:

```bash
interface RandomGen { next(): int }
class SeededRandom(seed) implements RandomGen { ... }
class FixedRandom(sequence) implements RandomGen { next() = sequence.pop() }
```

### Concurrency

Avoid real threads in unit tests. Extract logic to pure functions; test scheduling via **fake executors** or **synchronous dispatchers**.

### I/O

Abstract with ports/adapters (Repository, HttpClient, FileStore). Use **in-memory fakes**.

## Assertions that Pull Their Weight

* Prefer **specific** asserts: `assert_equal(54, total)` over `assert_true(total < 60)`.
* Provide **custom messages**: `assert_equal(54, total, "10% discount not applied")`.
* Assert one **behavior** per test (multiple asserts okay if they describe one behavior).

## Property-Based Tests (when examples aren’t enough)

Beyond example tests, check **properties** that must always hold.

Properties for `calculate_total(items, d)`:

* **Non-negativity:** result ≥ 0
* **Monotonicity:** adding an item never decreases total
* **Discount bounds:** with `0 ≤ d ≤ 1`, total ≤ sum(items)

```bash
property "adding item increases total" {
  for_all(item_price > 0, items >= []) {
    before = calc(items, d=0)
    after  = calc(items + [item_price], d=0)
    assert_true(after >= before)
  }
}
```

Use property tests to catch edge cases humans miss.

## Structuring Your Test Suite

* **Mirror production structure**: `src/price/calculator.*` → `test/price/calculator_test.*`
* **One SUT per file** where possible.
* **Common helpers** in `test_support/` (builders, fakes, assertions).
* Keep **fixtures local** unless truly shared.

## Coverage: Useful, but Not the Goal

* Track **line/statement** and **branch** coverage to find blind spots.
* Don’t chase 100%. Aim for **meaningful coverage** of business logic and risk areas.
* Complement with **mutation testing** if available (ensures tests can detect real changes).

## Test-Driven Development (TDD): Micro-cycles that Improve Design

**Red → Green → Refactor**:

1. **Red**: write a failing test that expresses desired behavior.
2. **Green**: implement the simplest code to pass it.
3. **Refactor**: improve design with tests staying green.

Even if you don’t TDD all the time, using short cycles on complex logic reduces waste and over-engineering.

## Common Unit Test Smells (and Fixes)

* **Brittle tests** (fail after harmless refactors)
  → Assert on **behavior**, not internal calls/ordering (avoid over-mocking).
* **Mega setups** (50-line arrange blocks)
  → Introduce **builders** and **sensible defaults**.
* **Hidden dependencies** (time, singletons)
  → Add interfaces; inject **Clock/Random/Config**.
* **Flaky tests** (sometimes fail)
  → Remove sleeps; use **fixed clocks**, **fakes**, and **synchronous** executors.
* **Logic in tests** (ifs/loops)
  → Replace with **parameterized tests** or test data tables.

## Worked Example (End-to-End Unit Test Thought Process)

**Requirement:** “Calculate order total with per-item prices, optional percentage discount, and tax applied after discount.”

Rules:

* Subtotal = sum(prices)
* Discounted = subtotal × (1 − discount) where 0 ≤ discount ≤ 1
* Total = round\_to\_cents(discounted × (1 + taxRate))

### Example tests

**Happy path**

```bash
test "applies 10% discount then 16% tax" {
  sut = PriceCalculator(taxRate=0.16)
  total = sut.total([100, 50], discount=0.10)
  // subtotal = 150; after discount = 135; with tax = 156.6
  assert_equal(156.60, total)
}
```

**Edge cases**

```bash
test "empty items yields 0" {
  assert_equal(0.00, PriceCalculator(0.16).total([], discount=0))
}

test "discount is clamped between 0 and 1" {
  assert_equal(116.00, PriceCalculator(0.16).total([100], discount=2.0)) // treated as 1.0
  assert_equal(116.00, PriceCalculator(0.16).total([100], discount=-0.5)) // treated as 0.0
}
```

**Rounding behavior**

```bash
test "rounds to nearest cent (bankers or half-up as spec'd)" {
  // define and lock rounding policy; assert explicit expected cents
}
```

**Property**

```bash
property "adding an item never decreases total when discount fixed" { ... }
```

> Note how tests pin down rounding, clamping, and the order of operations—classic sources of real-world bugs.

## Design for Testability (so unit tests are easy)

* **Dependency Injection**: pass collaborators (Clock, Repo) via constructor/params.
* **Pure Functions**: push logic into pure units; keep side effects at the edges.
* **Small Interfaces**: program to ports; adapters do I/O.
* **Single Responsibility**: smaller units are easier to test and reason about.

## Performance: Keep Tests Lightning-Fast

* Avoid costly setup; prefer **in-memory** collaborators.
* No sleeps/timeouts; fake the clock/scheduler.
* Run unit tests in a **watch mode** locally; keep CI under seconds for this suite.

## When to Delete or Rewrite Tests

* Requirements changed → Update tests to reflect new truth.
* Test asserts an implementation detail → Rewrite to assert behavior.
* Chronic flakiness → Fix root cause or remove; flaky tests destroy trust.

## A Minimal Template You Can Reuse

```bash
suite PriceCalculatorTests:
  setup:
    tax = 0.16
    sut = PriceCalculator(taxRate=tax)

  test "returns zero for empty items":
    expect sut.total([], discount=0) == 0.00

  test "applies discount before tax":
    expect sut.total([100], discount=0.10) == 104.40

  test "clamps invalid discounts":
    expect sut.total([100], discount=2.0) == 116.00

  test "non-negativity property":
    for_all item_lists:
      expect sut.total(item_lists, discount=0) >= 0
```

## Checklist: Before You Commit

* [ ] Test name reads like a spec (explains *when/then*).
* [ ] Only one behavior under test.
* [ ] No hidden I/O/time/randomness.
* [ ] Clear, specific assertions (with messages).
* [ ] Fast (ms), repeatable, independent.
* [ ] Data setup is minimal and readable (builder/fixtures).

# Side-by-Side Examples

We’ll use a simple scenario:

> Function to calculate the **discounted price** given an original price and discount percentage.

### Python (pytest / unittest)

```python
# discount.py
def apply_discount(price: float, discount: float) -> float:
    if discount < 0 or discount > 100:
        raise ValueError("Discount must be between 0 and 100")
    return price - (price * discount / 100)

# test_discount.py
import pytest
from discount import apply_discount

def test_apply_discount_valid():
    assert apply_discount(100, 10) == 90

def test_apply_discount_zero_discount():
    assert apply_discount(100, 0) == 100

def test_apply_discount_invalid():
    with pytest.raises(ValueError):
        apply_discount(100, 150)
```

### C# (xUnit)

```csharp
// Discount.cs
public class Discount
{
    public static decimal ApplyDiscount(decimal price, decimal discount)
    {
        if (discount < 0 || discount > 100)
            throw new ArgumentException("Discount must be between 0 and 100");
      
        return price - (price * discount / 100);
    }
}

// DiscountTests.cs
using Xunit;

public class DiscountTests
{
    [Fact]
    public void ApplyDiscount_ValidDiscount_ReturnsDiscountedPrice()
    {
        var result = Discount.ApplyDiscount(100, 10);
        Assert.Equal(90, result);
    }

    [Fact]
    public void ApplyDiscount_ZeroDiscount_ReturnsSamePrice()
    {
        var result = Discount.ApplyDiscount(100, 0);
        Assert.Equal(100, result);
    }

    [Fact]
    public void ApplyDiscount_InvalidDiscount_ThrowsException()
    {
        Assert.Throws<ArgumentException>(() => Discount.ApplyDiscount(100, 150));
    }
}
```

### TypeScript (Jest)

```typescript
// discount.ts
export function applyDiscount(price: number, discount: number): number {
  if (discount < 0 || discount > 100) {
    throw new Error("Discount must be between 0 and 100");
  }
  return price - (price * discount / 100);
}

// discount.test.ts
import { applyDiscount } from "./discount";

test("applyDiscount with valid discount", () => {
  expect(applyDiscount(100, 10)).toBe(90);
});

test("applyDiscount with zero discount", () => {
  expect(applyDiscount(100, 0)).toBe(100);
});

test("applyDiscount with invalid discount", () => {
  expect(() => applyDiscount(100, 150)).toThrow();
});
```

---

### PHP (Laravel / PHPUnit)

```php
// app/Services/DiscountService.php
<?php
namespace App\Services;

class DiscountService {
    public function applyDiscount(float $price, float $discount): float {
        if ($discount < 0 || $discount > 100) {
            throw new \InvalidArgumentException("Discount must be between 0 and 100");
        }
        return $price - ($price * $discount / 100);
    }
}
```

```php
// tests/Unit/DiscountServiceTest.php
<?php
namespace Tests\Unit;

use App\Services\DiscountService;
use PHPUnit\Framework\TestCase;

class DiscountServiceTest extends TestCase
{
    public function testApplyDiscountValid() {
        $service = new DiscountService();
        $this->assertEquals(90, $service->applyDiscount(100, 10));
    }

    public function testApplyDiscountZero() {
        $service = new DiscountService();
        $this->assertEquals(100, $service->applyDiscount(100, 0));
    }

    public function testApplyDiscountInvalid() {
        $this->expectException(\InvalidArgumentException::class);
        $service = new DiscountService();
        $service->applyDiscount(100, 150);
    }
}
```

---

# Comparison Table

| Aspect                   | Unit Test Goal                                | Python (pytest)   | C# (xUnit)        | TypeScript (Jest) | PHP (PHPUnit)       |
| ------------------------ | --------------------------------------------- | ----------------- | ----------------- | ----------------- | ------------------- |
| **Framework**      | Testing tool used                             | pytest/unittest   | xUnit             | Jest              | PHPUnit             |
| **Isolation**      | Tests only the function logic                 | ✅                | ✅                | ✅                | ✅                  |
| **Error Handling** | Verify invalid inputs raise exceptions/errors | `pytest.raises` | `Assert.Throws` | `toThrow()`     | `expectException` |
| **Speed**          | Very fast, no external dependency             | ⚡⚡⚡            | ⚡⚡⚡            | ⚡⚡⚡            | ⚡⚡⚡              |

---

# Key Takeaways

* **Unit tests are your first safety net**: they guarantee that individual building blocks work correctly.
* **They should be small, isolated, and run fast**.
* **Mocks and stubs** are often used when dependencies exist.
* Every language has its **idiomatic testing framework**, but the philosophy is the same.

## What’s Next in the Series

Up next: **Integration Testing in Depth** — choosing boundaries, taming real dependencies, keeping tests reliable without turning them into E2E.
Stay tuned!
