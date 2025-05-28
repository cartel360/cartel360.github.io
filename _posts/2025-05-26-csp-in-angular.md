---
layout: post
title: Content Security Policy (CSP) in Angular Apps
categories: [Software Development]
image: /assets/img/angular-csp.jpg
tags: [Angular, CSP, Security, Web Development]
description: Content Security Policy (CSP) represents a fundamental shift in web application security, moving from traditional "allow all" models to a strict whitelist approach. For Angular developers, implementing CSP requires deep understanding of both the framework's internals and modern security practices.
canonical_url: https://blogs.innova.co.ke/angular-csp/
---


Content Security Policy (CSP) represents a fundamental shift in web application security, moving from traditional "allow all" models to a strict whitelist approach. For Angular developers, implementing CSP requires deep understanding of both the framework's internals and modern security practices.

Angular applications present unique CSP challenges because:
- The framework heavily utilizes dynamic code evaluation for features like change detection
- Component-based architecture encourages inline styles and templates
- Modern SPAs rely on numerous external resources (APIs, fonts, analytics)

**Key CSP Benefits for Angular:**
- Prevents 90% of XSS attack vectors (according to Google research)
- Mitigates data exfiltration attempts
- Controls resource loading to prevent supply chain attacks
- Provides violation reporting for security monitoring

## CSP Directives Relevant to Angular

### Critical Directives Breakdown

1. **script-src**
   - Controls JavaScript execution
   - Angular requires careful configuration here due to:
     - Zone.js modifications
     - JIT compilation (if used)
     - Dynamic component loading

2. **style-src**
   - Manages CSS loading
   - Angular's component styles pose challenges:
     - Component-scoped styles are inline by default
     - View encapsulation generates unique selectors

3. **connect-src**
   - Restricts XHR/fetch/WebSocket connections
   - Must include:
     - API endpoints
     - WebSocket URLs
     - Analytics domains

4. **font-src and img-src**
   - Often overlooked but critical for:
     - Google Fonts
     - Material Icons
     - Application assets

## Comprehensive CSP Implementation Strategies

### 1. Meta Tag Approach (Development Use Only)

```html
<meta http-equiv="Content-Security-Policy" 
      content="default-src 'self';
               script-src 'self' 'unsafe-inline' 'unsafe-eval' https://apis.google.com;
               style-src 'self' 'unsafe-inline' https://fonts.googleapis.com;
               img-src 'self' data: https://*.googleusercontent.com;
               font-src 'self' https://fonts.gstatic.com;
               connect-src 'self' https://api.example.com;
               frame-src 'self' https://www.youtube.com;
               object-src 'none';
               report-uri https://csp-report.example.com;">
```

**Limitations:**
- Cannot use nonces
- Difficult to modify at runtime
- Limited to ~8KB in some browsers

### 2. Server-Header Approach (Production Recommended)

**Nginx Configuration Example:**

```nginx
# /etc/nginx/conf.d/csp.conf
map $request_id $csp_nonce {
    default "";
    "~*(?<nonce>[a-zA-Z0-9+/=]{20})" "$nonce";
}

server {
    # Generate nonce for each request
    set_by_lua_block $csp_nonce {
        return require("resty.random").token(20)
    }

    add_header Content-Security-Policy "
        default-src 'self';
        script-src 'self' 'nonce-$csp_nonce' 'strict-dynamic' https://trusted.cdn.example.com;
        style-src 'self' 'nonce-$csp_nonce';
        img-src 'self' data: https://*.example-cdn.com;
        font-src 'self' https://fonts.gstatic.com;
        connect-src 'self' wss://realtime.example.com https://api.example.com;
        frame-src 'self' https://www.youtube.com;
        object-src 'none';
        base-uri 'self';
        form-action 'self';
        report-uri https://csp-report.example.com;
        report-to default;
    ";

    # For older browsers
    add_header Content-Security-Policy-Report-Only "...";
}
```

**Advanced Features:**
- Dynamic nonce generation per request
- Separate policies for modern vs legacy browsers
- Real-time violation reporting

## Angular-Specific CSP Solutions

### 1. Handling Component Styles

**Problem:** Angular's view encapsulation generates inline styles

**Solutions:**

A) **Extract all styles to external files**
```typescript
// angular.json
{
  "projects": {
    "app": {
      "architect": {
        "build": {
          "options": {
            "extractCss": true,
            "inlineStyleLanguage": "scss"
          }
        }
      }
    }
  }
}
```

B) **Use hashes for critical inline styles**
```conf
style-src 'self' 'sha256-abc123...';
```

### 2. Dynamic Component Loading

**Secure Approach:**
```typescript
@Component({
  selector: 'app-dynamic',
  template: '<div #host></div>'
})
export class DynamicComponent {
  @ViewChild('host', {static: true, read: ViewContainerRef}) host: ViewContainerRef;

  constructor(
    private compiler: Compiler,
    private sanitizer: DomSanitizer
  ) {}

  async loadComponent() {
    const unsafeTemplate = '<div (click)="doSomething()">Click</div>';
    const safeTemplate = this.sanitizer.bypassSecurityTrustHtml(unsafeTemplate);
    
    @Component({ template: safeTemplate })
    class DynamicTemplateComponent {}

    const module = await this.compiler.compileModuleAndAllComponentsAsync(
      createNgModule({ declarations: [DynamicTemplateComponent] })
    );

    const factory = module.componentFactories[0];
    this.host.createComponent(factory);
  }
}
```

### 3. Third-Party Library Integration

**Safe Loading Pattern:**
```typescript
// secure-library-loader.service.ts
@Injectable({ providedIn: 'root' })
export class SecureLibraryLoader {
  private loadedLibraries: { [url: string]: Observable<any> } = {};

  constructor(private http: HttpClient) {}

  loadScript(url: string): Observable<any> {
    if (!this.loadedLibraries[url]) {
      this.loadedLibraries[url] = this.http.jsonp(url, 'callback').pipe(
        shareReplay(1),
        catchError(err => {
          console.error('Failed to load script', url, err);
          return throwError(err);
        })
      );
    }
    return this.loadedLibraries[url];
  }
}
```

## Angular 19 CSP Innovations

### 1. Automated CSP Generation

**angular.json Configuration:**
```json
{
  "projects": {
    "app": {
      "architect": {
        "build": {
          "configurations": {
            "production": {
              "security": {
                "autoCsp": {
                  "enabled": true,
                  "policy": {
                    "default-src": "'self'",
                    "script-src": ["'self'", "'strict-dynamic'"],
                    "style-src": ["'self'", "'unsafe-inline'"],
                    "report-uri": "https://csp-report.example.com"
                  },
                  "nonce": true
                }
              }
            }
          }
        }
      }
    }
  }
}
```

**Features:**
- Automatic nonce injection
- Hash generation for inline resources
- Development/production policy differentiation

### 2. CSP-Aware Compiler

The Angular 19 compiler now:
- Detects CSP violations during build
- Suggests policy modifications
- Optimizes bundle for CSP compliance

```bash
ng build --prod --csp-report
```

## Advanced CSP Patterns for Angular

### 1. Progressive CSP Tightening

**Implementation Roadmap:**

| Phase | Strategy | Tools |
|-------|----------|-------|
| 1 | Report-Only Mode | `Content-Security-Policy-Report-Only` |
| 2 | Baseline Policy | Browser console analysis |
| 3 | Nonce Implementation | Server middleware |
| 4 | Strict-Dynamic | Angular AOT compilation |
| 5 | Elimination of Unsafe | Style extraction |

### 2. CSP for Micro Frontends

**Configuration Example:**
```http
Content-Security-Policy: 
  script-src 'self' 'nonce-abc123' https://microfrontend1.example.com;
  frame-src 'self' https://microfrontend2.example.com;
  connect-src 'self' https://api.shared.example.com;
```

### 3. CSP with Service Workers

**Special Considerations:**
```http
worker-src 'self' blob:;
script-src 'self' 'unsafe-inline' 'wasm-unsafe-eval';
```

## Monitoring and Maintenance

### 1. Violation Reporting Setup

**Express.js Middleware Example:**
```typescript
app.post('/csp-report', (req, res) => {
  const report = req.body['csp-report'];
  analytics.track('CSP_VIOLATION', {
    violatedDirective: report['violated-directive'],
    blockedUri: report['blocked-uri'],
    documentUri: report['document-uri'],
    userAgent: req.headers['user-agent']
  });
  res.status(204).end();
});
```

### 2. Automated Testing

**Protractor CSP Test:**
```typescript
describe('CSP Compliance', () => {
  it('should not have CSP violations', async () => {
    const logs = await browser.manage().logs().get('browser');
    const cspErrors = logs.filter(log => 
      log.message.includes('Content Security Policy') &&
      !log.message.includes('report-uri')
    );
    expect(cspErrors.length).toBe(0);
  });
});
```

## Conclusion and Key Recommendations

**Final Implementation Checklist:**

1. **Always use AOT compilation** - Eliminates JIT CSP conflicts
2. **Implement nonce-based policies** - Most secure approach
3. **Extract component styles** - Reduce 'unsafe-inline' requirements
4. **Monitor violations aggressively** - Use both report-uri and browser console
5. **Phase your implementation** - Start with report-only mode
6. **Leverage Angular 19 features** - AutoCsp and improved tooling
7. **Test across environments** - Especially SSR and PWA scenarios


By adopting these practices, Angular developers can achieve both robust security and maintainable application architecture. The balance between security and functionality requires ongoing attention, but the protection against modern web threats makes CSP implementation essential for production applications.

Watch the video below for a session I had on this topic.


{% include embed/youtube.html id='TrNm0-1J6PI?si=1gMrdj2ZAjQGyFkc' %}


