---
title: Work
icon: fas fa-briefcase
order: 5
date: 2026-03-24
hide_panel: true
permalink: /portfolio/
description: Portfolio and case studies — problems, ownership, decisions, trade-offs, and impact.
---

<div class="work-index">
  <section class="work-hero" aria-labelledby="work-hero-heading">
    <div class="work-hero__bg" aria-hidden="true"></div>
    <div class="work-hero__inner">
      <p id="work-hero-heading" class="work-hero__kicker">Portfolio</p>
      <p class="work-hero__lede">
        A collection of things I’ve built, broken, and eventually fixed. Expect less “todo apps” and more real-world systems complete with questionable decisions, hard trade-offs, and the occasional “this seemed like a good idea at the time.” Each case study covers the problem, what I owned, the decisions I made, what went wrong, and what I’d absolutely do differently (given another sleepless night and enough coffee).
      </p>
    </div>
  </section>

  <div class="work-card-grid">
    {% assign studies = site.case_studies | sort: 'order' %}
    {% for cs in studies %}
      <a class="work-card" href="{{ cs.url | relative_url }}">
        <span class="work-card__accent" aria-hidden="true"></span>
        <span class="work-card__glow" aria-hidden="true"></span>
        <div class="work-card__inner">
          <header class="work-card__header">
            <span class="work-card__icon" aria-hidden="true"><i class="{{ cs.card_icon | default: 'fas fa-folder-open' }}"></i></span>
            <span class="work-card__eyebrow">Case study</span>
          </header>
          <div class="work-card__body">
            <h2 class="work-card__title">{{ cs.short_title | default: cs.title }}</h2>
            <p class="work-card__excerpt">{{ cs.card_excerpt }}</p>
          </div>
          <span class="work-card__cta">
            <span class="work-card__cta-text">Read write-up</span>
            <span class="work-card__cta-icon" aria-hidden="true"><i class="fas fa-arrow-right"></i></span>
          </span>
        </div>
      </a>
    {% endfor %}
  </div>
</div>
