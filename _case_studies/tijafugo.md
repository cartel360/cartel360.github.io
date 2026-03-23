---
title: Tijafugo — offline-first poultry management for African farms
short_title: Tijafugo
order: 1
description: Case study — Tijafugo, offline-first poultry farm management for African farms.
card_excerpt: Offline-first poultry management for African farms — flock health, production, and profit without always-on connectivity. English, Swahili, USSD.
card_icon: fas fa-feather-alt
---

<div class="work-page" markdown="1">

<p class="work-meta" markdown="0">
  <span class="work-meta__label">Live</span>
  <a href="https://tijafugo.app" target="_blank" rel="noopener noreferrer">tijafugo.app</a>
  <span class="work-meta__sep" aria-hidden="true">·</span>
  <span class="work-meta__label">Waitlist</span>
  <a href="https://waitlist.tijafugo.app" target="_blank" rel="noopener noreferrer">waitlist.tijafugo.app</a>
</p>

### Overview

Built an offline-first poultry farm management platform designed for African farming conditions—unreliable internet, feature phones, and multilingual users. Tijafugo enables farmers to track production, monitor flock health, and understand profitability without depending on constant connectivity.

Piloted in Kenya with early users including smallholder farmers and cooperatives, shaping both product and usability decisions.

* * *

### The problem

Poultry farmers—especially small and mid-scale operators—face systemic challenges:

- Manual records are unreliable and difficult to maintain
- Disease is often detected too late, leading to losses
- Costs and profitability are unclear without structured tracking
- Most existing tools assume constant internet access
- Decision-making is based on guesswork rather than data

* * *

### My role

Sole engineer responsible for:

- System architecture and technical design
- End-to-end product development and deployment
- Product direction in collaboration with early users (farmers, cooperatives, extension officers)
- Prioritization of offline-first design and multi-channel access (mobile + USSD)

* * *

### Key product & GTM decisions

- **Accessibility-first**
  - English and Swahili support
  - Chat-style data entry for ease of use
  - Voice and USSD support for non-smartphone users

- **Offline-first architecture**
  - Core functionality available without internet
  - Sync when connectivity is restored

- **Localized pricing model**
  - KES-based pricing tied to flock size and farm count
  - Free beta for early adopters
  - Transparent tier progression (Starter → Large Scale)

- **Farmer-informed design**
  - Built in collaboration with real users in Kenya
  - Iterative feedback shaping features and UX

* * *

### Key engineering challenges & trade-offs

#### Offline-first synchronization

- **Challenge:** Ensuring data consistency with intermittent connectivity  
- **Approach:** Designed sync mechanisms to handle delayed updates and minimize conflicts  

#### USSD vs mobile app parity

- **Challenge:** Supporting feature phones with limited interaction capabilities  
- **Trade-off:** Reduced feature set on USSD in favor of accessibility and usability  

#### AI-assisted health insights

- **Challenge:** Providing useful guidance without risking incorrect livestock advice  
- **Approach:** Scoped AI to assistive insights with a path toward veterinarian integration  

* * *

### Core capabilities

#### Health monitoring (early detection)

- Symptom logging (including photos)
- Vaccination scheduling
- AI-assisted health insights

#### Production & operations tracking

- Batch management with auto-generated IDs
- Breed tracking (layers, broilers, breeders)
- Egg production, mortality, and feed tracking

#### Financial visibility

- Income and expense tracking
- Profit/loss insights at farm level
- Exportable reports (PDF/Excel on paid tiers)

#### Multi-channel access

- Smartphone experience (web/mobile)
- USSD for feature phones
- Offline usage with sync

* * *

### Impact & traction

- Piloted in Kenya with early adopters  
- Designed for farms ranging from ~50 to 500+ birds  
- Supporting both individual farmers and cooperative use cases  
- Waitlist-driven early access ahead of full beta launch  

* * *

### What’s next

- Improve offline conflict resolution strategies  
- Expand AI-assisted diagnostics with expert validation  
- Scale analytics for multi-farm and cooperative scenarios  
- Introduce advanced automation and reporting for larger operations  

</div>
