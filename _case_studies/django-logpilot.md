---
title: django-logpilot — Production-ready logging for Django with minimal setup
short_title: django-logpilot
order: 4
description: Case study — django-logpilot, sensible Django logging defaults, JSON in prod, request IDs, and optional rotation.
card_excerpt: Readable dev logs, structured JSON in production, rotating files, and X-Request-ID—without wrestling LOGGING dicts.
card_icon: fas fa-file-lines
---

<div class="work-page" markdown="1">

<p class="work-meta" markdown="0">
  <span class="work-meta__label">PyPI</span>
  <a href="https://pypi.org/project/django-logpilot/" target="_blank" rel="noopener noreferrer">django-logpilot</a>
</p>

### Overview

Logpilot configures sensible defaults so you get readable logs in development, structured JSON in production, optional rotating files, and a request ID on every response—without spending an afternoon on `LOGGING` dictionaries.

Alerting hooks exist in settings for upcoming releases; today the focus is great logging out of the box.

* * *

### The problem

Django’s logging story is powerful but easy to get wrong:

- Every project ends up copy-pasting or cargo-culting `LOGGING` configs  
- Dev vs production formats (text vs JSON) rarely stay consistent  
- Request correlation (trace IDs) is usually bolted on late  
- File rotation, levels, and root logger wiring are easy to misconfigure  
- Merging with an existing `LOGGING` dict often causes subtle `KeyError`s on filters  

Teams want **observability-friendly defaults** without becoming logging experts on day one.

* * *

### My role

Sole engineer responsible for:

- Package design, defaults, and safe coexistence with custom `LOGGING`  
- Request ID middleware and formatter integration **without** requiring fragile `LOGGING["filters"]` entries  
- File output with rotation, directory creation, and sensitive-key redaction helpers  
- Documentation, PyPI distribution, and a clear path toward future alerting  

* * *

### What you get

- **Console** and optional **file** output with rotation  
- **Text or JSON** format (switch per environment)  
- **Request ID middleware** (`X-Request-ID` in and out) wired into log lines  
- **Root logger** configured so `logging.getLogger(__name__)` shows up alongside Django’s logs  
- **`redact_mapping()`** helper for dict-shaped data you choose to log  
- **Parent directories** for `file_path` created automatically when possible  

**Requirements:** Python 3.10+, Django 4.2+.

* * *

### Design decisions

#### Don’t fight existing projects

If `LOGGING["handlers"]` is non-empty, Logpilot **does not** overwrite your configuration. Teams can opt in with `DJANGO_LOGPILOT_MERGE_LOGGING = True` to layer handlers and formatters on top of a custom dict.

#### Request IDs without filter footguns

Formatters read context set by middleware instead of relying on a shared `logpilot_request_id` filter on every handler—so merging configs is less likely to blow up with `KeyError: 'logpilot_request_id'`.

#### Redaction is explicit

Logpilot does not scan request bodies automatically. When you log structured data, you wrap it with `redact_mapping()` so sensitive keys (password, token, `authorization`, etc.) are stripped in a predictable way.

* * *

### Example setup

Install from PyPI:

```bash
pip install django-logpilot
```

Minimal `settings.py` stack (merge with your existing `INSTALLED_APPS` / `MIDDLEWARE`—no duplicates):

```python
INSTALLED_APPS = [
    # ...
    "django_logpilot",
]

MIDDLEWARE = [
    "django_logpilot.middleware.RequestIdMiddleware",
    "django.middleware.security.SecurityMiddleware",
    # ... rest of Django defaults
]

LOGGING = {}  # leave handlers empty so Logpilot applies its config at startup

DJANGO_LOGPILOT = {
    "format": "text",
    "level": "DEBUG",
    "outputs": ["console", "file"],
    "file_path": str(BASE_DIR / "logs" / "app.log"),
    "file_max_bytes": 5 * 1024 * 1024,
    "file_backup_count": 3,
    "request_id_header": "X-Request-ID",
    "request_id_response_header": "X-Request-ID",
    "redact_keys": (
        "password", "secret", "token", "authorization",
        "cookie", "api_key",
    ),
    "alerts": {
        "enabled": False,
        "min_level": "ERROR",
        "deduplicate_for": 300,
        "channels": [],
        "slack_webhook": None,
        "email_backend": None,
    },
}
```

For JSON lines in production, set `"format": "json"`.

* * *

### Key engineering notes

- Handlers attach to the **root** and key `django` / `django.request` loggers so standard `logging.getLogger(__name__)` usage propagates as expected.  
- **`DJANGO_LOGPILOT`** centralizes format, level, outputs, rotation, headers, redaction keys, and reserved **alerts** block for future delivery.  
- Early **0.1.x**: defaults and APIs may still move—pin a version in production until **1.0**.

* * *

### Troubleshooting (quick reference)

| Issue | What to do |
| --- | --- |
| No Logpilot output | You likely have custom `LOGGING` handlers. Try `DJANGO_LOGPILOT_MERGE_LOGGING = True` or simplify `LOGGING` for a test. |
| `KeyError: 'logpilot_request_id'` | Remove stale `"filters": ["logpilot_request_id"]` from custom handlers, or define that filter under `LOGGING["filters"]`. |
| Cannot create log file | Ensure the process can write to the parent path (e.g. not `/var/log/...` without the right user). |

* * *

### What’s next

- Ship alerting (Slack, email, deduplication) on top of the existing `alerts` settings shape  
- Harden APIs toward **1.0** with semver stability  

* * *

### Links

- **PyPI:** [django-logpilot](https://pypi.org/project/django-logpilot/)

</div>
