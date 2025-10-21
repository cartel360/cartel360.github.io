---
layout: post
title: "Stripe Connect Integration Guide — Standard, Express, and Custom Accounts Explained (with Laravel, C#, and Python Examples)"
categories: [Payment Processing, Software Development]
image: /assets/img/stripe-integration.jpg
tags: [Stripe, Payment Processing, Software Development, APIs, Fintech, Integrating Stripe Laravel, Integrating Stripe C#, Integrating Stripe Python]
description: Learn the differences between Stripe Connect's Standard, Express, and Custom account types. This comprehensive guide covers when to use each type, implementation examples in Laravel, C#, and Python, and key architectural considerations for building payment platforms.
mermaid: true
---


Stripe offers a powerful ecosystem for building **payment platforms**, **marketplaces**, and **financial applications**.
One of its most powerful products, **Stripe Connect**, allows you to facilitate payments between multiple parties while maintaining flexibility over **branding, compliance,** and **user experience**.

Choosing between **Standard**, **Express**, and **Custom** accounts is one of the most important architectural decisions you’ll make when designing a payment platform.
This guide combines a **step-by-step tutorial** and **deep technical analysis** to help you understand and implement each type.

## What Is Stripe Connect?

Stripe Connect is designed for **platforms** that process payments on behalf of others.
It enables you to connect user accounts (called **Connected Accounts**) to your **Platform Account** so you can:

* Collect payments from customers
* Distribute payouts to vendors, lenders, or service providers
* Optionally collect platform fees

Your **platform never needs to hold funds directly** (unless you design it to), and Stripe handles the movement of money under the hood.


## Connected Accounts Overview

Each connected account represents a business, seller, or user on your platform.
Depending on how much **control** and **responsibility** you want, you’ll choose between:

1. **Standard** — Stripe handles almost everything.
2. **Express** — Stripe handles compliance, you handle limited UX.
3. **Custom** — You handle everything; Stripe is invisible to your users.

| Feature / Aspect                | **Standard**                                                | **Express**                                                                               | **Custom**                                                                       |
| ------------------------------- | ----------------------------------------------------------- | ----------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| **Ownership of Stripe Account** | User owns and manages their Stripe account directly.        | User gets a lightweight managed account. Stripe handles UI for onboarding and dashboards. | Full control; your platform owns the payment experience. Users never see Stripe. |
| **KYC / Onboarding**            | Handled entirely by Stripe via the user’s Stripe dashboard. | Stripe-hosted onboarding flow with minimal setup.                                         | You collect all KYC data through your own UI and pass it to Stripe’s API.        |
| **Dashboard Access**            | User uses Stripe’s own dashboard.                           | Limited dashboard (Stripe Express Dashboard).                                             | No dashboard; your app must display balances, transactions, etc.                 |
| **Compliance Responsibility**   | Stripe handles everything.                                  | Stripe handles most KYC and compliance.                                                   | You are responsible for collecting and transmitting KYC data.                    |
| **Control over UI/UX**          | Minimal; users leave your app to manage payments.           | Moderate; Stripe provides branded but embeddable flows.                                   | Full; completely white-labeled experience.                                       |
| **Ideal Use Case**              | Marketplaces where users already have Stripe accounts.      | Platforms needing simple onboarding (e.g., gig apps).                                     | Fintech, lending, or platforms needing deep financial workflows.                 |


## Architectural Overview

All three integration types share a common flow:

```
Customer → Your Platform → Connected Account → Bank Payout
```

However, **the control points differ**:

* With **Standard**, Stripe owns the UX and dashboard.
* With **Express**, Stripe hosts onboarding and dashboard, but your platform manages relationships.
* With **Custom**, your platform builds everything: UI, onboarding, payouts, and reporting.


## Step-by-Step Implementation by Account Type

Let’s look at how to implement each account type with **C#**, **Laravel (PHP)** and **Python** examples and understand their implications.

## Standard Accounts — Easiest Setup, Minimal Control

### Concept

Standard accounts are the simplest to integrate.
Users connect **their own existing Stripe accounts** using OAuth. Stripe handles compliance, payouts, and reporting. Your platform receives a small **application fee** from each transaction.

### Use Case

> Ideal for marketplaces or SaaS platforms where users already have Stripe accounts and prefer to manage their own dashboards.
{: .prompt-tip }

### Implementation

#### C#

```csharp
var accountLink = await stripe.AccountLinks.CreateAsync(new AccountLinkCreateOptions {
    Account = connectedAccountId,
    RefreshUrl = "https://your-platform.com/reauth",
    ReturnUrl = "https://your-platform.com/success",
    Type = "account_onboarding",
});
```

#### Laravel (PHP)

```php
$accountLink = \Stripe\AccountLink::create([
    'account' => $connectedAccountId,
    'refresh_url' => route('stripe.reauth'),
    'return_url' => route('stripe.success'),
    'type' => 'account_onboarding',
]);
```

#### Python

```python
import stripe
stripe.api_key = "sk_test_..."

account_link = stripe.AccountLink.create(
    account=connected_account_id,
    refresh_url="https://your-platform.com/reauth",
    return_url="https://your-platform.com/success",
    type="account_onboarding"
)
```

### Pros and Cons

**Pros**

* Minimal setup
* Stripe handles everything (KYC, compliance, payouts)
* Reduced liability

**Cons**

* Limited branding control
* Users must leave your platform to manage payments
* Harder to create a unified experience


## Express Accounts — Fast Onboarding, Shared Control

### Concept

Express accounts strike a balance between simplicity and control.
You manage account creation and linking, but Stripe handles onboarding and provides a **lightweight dashboard** for your users.

### Use Case

> Perfect for gig or service platforms (like driver or freelancer apps) where quick onboarding and basic payout visibility are key.
{: .prompt-tip }

### Implementation

#### C#

```csharp
var account = await stripe.Accounts.CreateAsync(new AccountCreateOptions {
    Type = "express",
    Country = "US",
    Email = "user@example.com"
});

var link = await stripe.AccountLinks.CreateAsync(new AccountLinkCreateOptions {
    Account = account.Id,
    RefreshUrl = "https://yourapp.com/reauth",
    ReturnUrl = "https://yourapp.com/complete",
    Type = "account_onboarding"
});
```

#### Laravel (PHP)

```php
$account = \Stripe\Account::create([
    'type' => 'express',
    'country' => 'US',
    'email' => $request->input('email'),
]);

$link = \Stripe\AccountLink::create([
    'account' => $account->id,
    'refresh_url' => route('stripe.reauth'),
    'return_url' => route('stripe.success'),
    'type' => 'account_onboarding',
]);
```


#### Python

```python
account = stripe.Account.create(
    type="express",
    country="US",
    email="user@example.com"
)

link = stripe.AccountLink.create(
    account=account.id,
    refresh_url="https://yourapp.com/reauth",
    return_url="https://yourapp.com/complete",
    type="account_onboarding"
)
```

### Pros and Cons

**Pros**

* Faster onboarding
* Stripe handles compliance and verification
* Users get access to payout history via the Express dashboard

**Cons**

* Limited customization
* Stripe branding remains visible
* Less flexibility over reporting or custom payout logic


## Custom Accounts — Full Control, Full Responsibility

### Concept

Custom accounts are designed for **white-labeled** platforms.
Your app controls **everything**: onboarding, KYC collection, balances, and payouts.
Stripe is completely invisible to the end user.

### Use Case

> Ideal for fintech, embedded finance, lending, or any system that requires deep integration and custom user experiences.
{: .prompt-tip }

### Implementation

#### C#

```csharp
var accountOptions = new AccountCreateOptions {
    Type = "custom",
    Country = "US",
    Email = data.Email.ToLower(),
    Capabilities = new AccountCapabilitiesOptions {
        CardPayments = new AccountCapabilitiesCardPaymentsOptions { Requested = true },
        Transfers = new AccountCapabilitiesTransfersOptions { Requested = true }
    },
    TosAcceptance = new AccountTosAcceptanceOptions {
        Date = DateTimeOffset.UtcNow.ToUnixTimeSeconds(),
        Ip = httpContext.Connection.RemoteIpAddress.ToString()
    }
};

var account = await stripe.Accounts.CreateAsync(accountOptions);
```

#### Laravel (PHP)

```php
$account = \Stripe\Account::create([
    'type' => 'custom',
    'country' => 'US',
    'email' => strtolower($data['email']),
    'capabilities' => [
        'card_payments' => ['requested' => true],
        'transfers' => ['requested' => true],
    ],
    'tos_acceptance' => [
        'date' => time(),
        'ip' => request()->ip(),
    ],
]);
```

#### Python

```python
account = stripe.Account.create(
    type="custom",
    country="US",
    email=data["email"].lower(),
    capabilities={
        "card_payments": {"requested": True},
        "transfers": {"requested": True},
    },
    tos_acceptance={
        "date": int(time.time()),
        "ip": request.remote_addr,
    }
)
```

### Fund Flow Example

```
+--------------------------------------+
|             Platform (You)           |
|    No direct money handling          |
+--------------------+-----------------+
                     |
                     ▼
          Create & Manage Connected Accounts
                     |
   +--------------------------------------+
   |     Connected Account (Business)     |
   |  💵 Has Stripe balance, bank info    |
   |  🧾 Disburses and collects funds     |
   +--------------------------------------+
```

**Money Movement**

* **IN:** Customer → Connected Account (via ACH/Card)
* **OUT:** Connected Account → Bank (payouts)
* Platform orchestrates, Stripe moves the money

---

## Checking Balances

#### Python

```python
balance = stripe.Balance.retrieve(stripe_account=account_id)
```

#### Laravel (PHP)

```php
$balance = \Stripe\Balance::retrieve([], ['stripe_account' => $accountId]);
```

#### C#

```csharp
var balance = await stripe.Balance.GetAsync(
    new BalanceGetOptions(),
    new RequestOptions { StripeAccount = accountId }
);
```


## Compliance Responsibilities

| Responsibility   | Standard      | Express | Custom      |
| ---------------- | ------------- | ------- | ----------- |
| KYC              | Stripe        | Stripe  | You         |
| Tax Reporting    | Stripe        | Stripe  | You         |
| PCI Compliance   | Stripe-hosted | Shared  | Mostly you  |
| Dispute Handling | Stripe        | Shared  | You         |
| Branding         | Stripe        | Partial | Fully yours |

> **Tip:** For Custom accounts, implement **Stripe Identity**, **webhooks**, and **Stripe Radar** to automate verification and fraud detection.
{: .prompt-tip }

## Choosing the Right Integration Type

| Scenario                                   | Recommended Type |
| ------------------------------------------ | ---------------- |
| Marketplace with existing Stripe users     | **Standard**     |
| Platform needing fast onboarding           | **Express**      |
| Fintech, lending, or white-labeled finance | **Custom**       |


## Strategic Considerations

* **Time-to-market:** Standard < Express < Custom
* **Compliance load:** Stripe-heavy → Custom-heavy
* **Branding control:** Minimal → Full
* **Revenue potential:** Low (Standard) → High (Custom)

##  Final Thoughts

Every Stripe Connect integration represents a trade-off between **control**, **compliance**, and **complexity**:

* **Standard** — easiest to deploy, lowest control
* **Express** — balanced control and simplicity
* **Custom** — ultimate flexibility with greater responsibility

If your goal is **speed**, start with Express.
If your goal is **brand control and scalability**, build with Custom.

Either way, Stripe Connect gives you a future-proof foundation for managing payments, onboarding users, and creating rich financial experiences all through powerful APIs available across languages.


