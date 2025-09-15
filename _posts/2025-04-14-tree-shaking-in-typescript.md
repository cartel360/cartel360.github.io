---
layout: post
title: Tree Shaking in TypeScript
categories: [Software Development]
image: /assets/img/tree-shaking.jpg
tags: [TypeScript, Performance]
description: Tree shaking is a crucial optimization technique in modern JavaScript and TypeScript development that helps eliminate dead code from your final bundle. This article will explore tree shaking in depth, explain how it works with TypeScript, and provide practical code examples to demonstrate its benefits.
---

Tree shaking is a crucial optimization technique in modern JavaScript and TypeScript development that helps eliminate dead code from your final bundle. This article will explore tree shaking in depth, explain how it works with TypeScript, and provide practical code examples to demonstrate its benefits.

## What is Tree Shaking?

Tree shaking is a term commonly used in the JavaScript context for dead-code elimination. It's a form of optimization that removes unused code (exports) from your final bundle. The name comes from the mental image of your application as a dependency tree, where you "shake" the tree to make the dead leaves (unused code) fall out.

When working with TypeScript, tree shaking becomes particularly important because:

1. TypeScript adds type annotations and other constructs that don't exist in runtime JavaScript
2. TypeScript's module system needs to align with the ES module standard for effective tree shaking
3. Many TypeScript projects use utility libraries where only a fraction of functionality is needed

## How Tree Shaking Works

Tree shaking relies on the static structure of ES modules (import/export syntax). Bundlers like Webpack, Rollup, or Parcel can analyze your code and determine which exports are actually used and which aren't.

Key requirements for effective tree shaking:

1. **Use ES modules** (import/export syntax) instead of CommonJS (require/module.exports)
2. **Mark code as side-effect free** in your package.json
3. **Enable production mode** in your bundler (development mode often disables optimizations)
4. **Configure TypeScript correctly** to output ES modules

## Setting Up TypeScript for Tree Shaking

Let's start with the TypeScript configuration needed to enable tree shaking:

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "ES2022",
    "moduleResolution": "bundler",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "declaration": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
```

Key points in this configuration:
- `"module": "ESNext"` ensures TypeScript outputs ES modules
- `"target": "ES2022"` allows modern JavaScript features to be used
- `"moduleResolution": "bundler"` helps with proper module resolution

## Practical Example: Tree Shaking in Action

Let's create a simple example to demonstrate tree shaking.

### 1. Create a utility library

```typescript
// src/math.ts
export function add(a: number, b: number): number {
  console.log('add function called');
  return a + b;
}

export function subtract(a: number, b: number): number {
  console.log('subtract function called');
  return a - b;
}

export function multiply(a: number, b: number): number {
  console.log('multiply function called');
  return a * b;
}

export function divide(a: number, b: number): number {
  console.log('divide function called');
  return a / b;
}
```

### 2. Create a main file that uses only some functions

```typescript
// src/index.ts
import { add, multiply } from './math';

console.log(add(2, 3));
console.log(multiply(2, 3));
```

### 3. Configure package.json for tree shaking

```json
{
  "name": "tree-shaking-demo",
  "version": "1.0.0",
  "main": "dist/index.js",
  "module": "dist/index.js",
  "type": "module",
  "sideEffects": false,
  "scripts": {
    "build": "tsc && webpack --mode=production"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "webpack": "^5.0.0",
    "webpack-cli": "^5.0.0"
  }
}
```

Key points:
- `"sideEffects": false` tells bundlers that the package has no side effects
- `"type": "module"` enables ES modules in Node.js
- The build script uses TypeScript compiler followed by Webpack in production mode

### 4. Configure Webpack

```javascript
// webpack.config.js
import path from "path";
import { fileURLToPath } from "url";
import webpack from "webpack";
import BundleAnalyzerPlugin from "webpack-bundle-analyzer";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/** @type {webpack.Configuration} */
const config = {
  entry: "./src/index.ts",
  output: {
    filename: "bundle.js",
    path: path.resolve(__dirname, "dist"),
  },
  resolve: {
    extensions: [".ts", ".js"],
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: "ts-loader",
        exclude: /node_modules/,
      },
    ],
  },
  plugins: [
    new BundleAnalyzerPlugin.BundleAnalyzerPlugin({
      analyzerMode: "static",
      openAnalyzer: false,
      reportFilename: "report.html",
    }),
  ],
  optimization: {
    usedExports: true,
  },
};

export default config;
```

### 5. Build and analyze the output

Run the build command:

```bash
npm run build
```

After building, examine the output bundle (`dist/bundle.js`). You'll notice that only the `add` and `multiply` functions are included, while `subtract` and `divide` are removed (tree shaken).

## Advanced Tree Shaking Techniques

### 1. Side Effects Configuration

Some modules have side effects (like polyfills) that need to be preserved. You can handle this in your package.json:

```json
{
  "sideEffects": [
    "**/*.css",
    "**/*.scss",
    "src/polyfills.ts"
  ]
}
```

### 2. Using const enums for complete elimination

TypeScript's const enums are completely erased and inlined, making them ideal for tree shaking:

```typescript
// src/directions.ts
export const enum Direction {
  Up = 'UP',
  Down = 'DOWN',
  Left = 'LEFT',
  Right = 'RIGHT'
}

// src/index.ts
import { Direction } from './directions';

function move(direction: Direction) {
  if (direction === Direction.Up) {
    console.log('Moving up');
  }
}

move(Direction.Up);
```

After compilation, the enum will be completely inlined and removed from the final bundle if unused.

### 3. Dynamic imports for code splitting

Tree shaking works well with dynamic imports to split your code:

```typescript
// Dynamically import a heavy library only when needed
async function processImage() {
  const { ImageProcessor } = await import('./image-processor');
  const processor = new ImageProcessor();
  // use processor
}
```

## Common Pitfalls and How to Avoid Them

1. **Accidental side effects**:
   - Avoid top-level code with side effects in modules
   - Example of problematic code:
     ```typescript
     // This will prevent tree shaking of this module
     window.myGlobal = initializeSomething();
     ```

2. **CommonJS modules**:
   - Avoid `require()` and `module.exports` as they can't be tree shaken
   - Use ES module imports/exports consistently

3. **Re-exporting entire namespaces**:
   - Instead of:
     ```typescript
     export * from './math';
     ```
   - Prefer explicit exports:
     ```typescript
     export { add, multiply } from './math';
     ```

4. **Babel transforms**:
   - If using Babel with TypeScript, ensure it's not converting ES modules to CommonJS
   - Use `@babel/preset-typescript` with proper configuration

## Measuring Tree Shaking Effectiveness

To verify tree shaking is working:

1. Use Webpack Bundle Analyzer:
   ```javascript
   // webpack.config.js
   const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

   module.exports = {
     plugins: [new BundleAnalyzerPlugin()]
   };
   ```

2. Check bundle sizes before and after optimizations

3. Look for unused exports in your bundle

## Tree Shaking with Third-Party Libraries

Many modern libraries support tree shaking, but you need to import them correctly:

```typescript
// Bad - imports entire library
import _ from 'lodash';

// Good - imports only what you need
import { debounce } from 'lodash-es';

// Even better - imports directly from the module
import debounce from 'lodash-es/debounce';
```

Note the `-es` suffix which indicates the ES module version of the library.

You can find the repository to the demo <a href="https://github.com/cartel360/tree-shaking-typescript-demo" target="_blank"> here </a> 

## How to use the Project 
**1.** Clone the repo
```bash
git clone https://github.com/cartel360/tree-shaking-typescript-demo.git
cd tree-shaking-demo
npm install
```

**2.** Switch between the branches to explore different concepts
```bash
git checkout 01-basic-tree-shaking
npm run build
```

**3.** Examine the output in the `dist` directory and the bundle analyzer report**

**4.** Compare production avs development builds
```bash
npm run build     # Production (with tree shaking)
npm run build:dev # Development (without optimizations)
```


## Conclusion

Tree shaking is a powerful optimization technique that can significantly reduce your bundle size when working with TypeScript. By following ES module conventions, properly configuring your build tools, and being mindful of side effects, you can ensure that only the code your application actually uses ends up in the final bundle.

Remember these key points:
1. Always use ES module syntax (import/export)
2. Configure TypeScript to output ES modules
3. Mark your package as side-effect free when possible
4. Be explicit with imports from third-party libraries
5. Use tools to analyze your bundle and verify tree shaking effectiveness

With these practices in place, you'll keep your TypeScript applications lean and performant.


