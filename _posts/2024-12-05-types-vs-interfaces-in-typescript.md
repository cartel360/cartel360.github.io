---
layout: post
title: Types, Type Aliases, and Interfaces in TypeScript
date: 2024-12-05 00:00:00
categories: [Software Development]
image:
  path: /assets/img/types-interfaces.jpg
tags: [TypeScript]
description: TypeScript has become a powerful tool in web development, used to enhance robustness and scalability in JavaScript applications. To fully utilize TypeScript, one needs to understand the subtleties of types, type aliases, and interfaces. This article explores the basics of TypeScript
published: true
canonical_url: https://blogs.innova.co.ke/types-vs-interfaces-in-typescript
---

TypeScript has become a powerful tool in web development, used to enhance robustness and scalability in JavaScript applications. To fully utilize TypeScript, one needs to understand the subtleties of types, type aliases, and interfaces. This article explores the basics of TypeScript: the intricacies of types, the utility of type aliases, and the versatility of interfaces. The clarification of the differences and uses of these important concepts will help developers enhance their TypeScript programming skills and simplify their development processes.

## Introduction to TypeScript
Welcome to the wonderful world of TypeScript, where JavaScript gets a sprinkling of static typing goodness to make your code more robust and delightful.

### What is TypeScript?
TypeScript is a statically typed superset of JavaScript that provides developers with the ability to define types for variables, function parameters, and return values. With this, you'll be able to catch errors earlier and improve your development experience with things like code completion and refactoring tools.

Among its many features, TypeScript offers a powerful and flexible type system that helps catch errors early in development. Three core concepts in TypeScript that deal with types are types, type aliases, and interfaces. These allow you to define the shape and structure of data, ensuring more predictable and maintainable code.

Advantages of Using TypeScript
The use of TypeScript brings lesser bugs, better organization of code, readability, and maintainability of the code. TypeScript works well with modern development workflows and tools, hence making it a favorite for most developers.


## Types in TypeScript
In TypeScript, types are like the spices that add flavor to your code, helping the compiler understand what kind of data you’re working with.


### Primitive Types
Primitive types in TypeScript include familiar ones like number, string, boolean, null, undefined, and more. They represent the basic building blocks of your data.

```typescript
let username: string = "Alice";
let age: number = 30;
let isActive: boolean = true;
```

### Object Types
Object Types Object types enable you to define custom structures with properties and their respective types. They give your code structure and, at the same time, help you maintain consistency in your code.

```typescript
type User = {
    name: string;
    age: number;
    isActive: boolean;
};

const user: User = {
    name: "Alice",
    age: 30,
    isActive: true,
};
```

Here, `User` is a custom type that specifies an object with a `name` (string), `age` (number), and `isActive` (boolean).

### Union Types
Union types allow you to specify that a variable can hold values of different types. You can use the pipe (`|`) symbol to define a union

```typescript
type Status = "active" | "inactive" | "pending";

let userStatus: Status = "active"; // Valid
userStatus = "inactive"; // Valid
userStatus = "completed"; // Error: Type '"completed"' is not assignable to type 'Status'.
```

In the example above, `Status` can only be one of three string values: `"active"`, `"inactive"`, or `"pending"`.

### Intersection Types
An intersection type allows you to combine multiple types into one. The resulting type has all the properties of the combined types

```typescript
type Person = {
    name: string;
    age: number;
};

type Address = {
    city: string;
    country: string;
};

type PersonWithAddress = Person & Address;

const userWithAddress: PersonWithAddress = {
    name: "Alice",
    age: 30,
    city: "Nairobi",
    country: "Kenya",
};
```


## Type Aliases
Type aliases are nicknames for types that allow you to create custom names for more complex types or, otherwise, shorthand for long type annotations.

### Definition and Syntax
To declare a type alias, you use the keyword `type`, followed by a name for the alias and the actual type definition. 

### Basic Type Aliases
Here’s how you can create a basic type alias

```typescript
type ID = string | number;

let userId: ID = 101; // Valid
userId = "user_202"; // Valid
```

### Alias for Function Types
You can also use type aliases to define function types

```typescript
type Greeting = (name: string) => string;

const greet: Greeting = (name) => `Hello, ${name}!`;

console.log(greet("Alice")); // Outputs: "Hello, Alice!"
```

Here, `Greeting` is a type alias for a function that takes a `string` parameter and returns a `string`.

### Alias for Complex Types
Type aliases are especially useful when dealing with more complex types like unions or intersections

```typescript
type Product = {
    name: string;
    price: number;
};

type DiscountedProduct = Product & {
    discount: number;
};

const saleProduct: DiscountedProduct = {
    name: "Laptop",
    price: 80000,
    discount: 10,
};
```
Here, `DiscountedProduct` is an intersection of `Product` and an additional `discount` property.

>Type aliases are useful when you want to refer to a complex type definition in multiple places, give more meaningful names to types, or make your code more readable by abstracting away the details of complex types.
{: .prompt-tip}

## Interfaces in TypeScript
In TypeScript, interfaces are contracts that define the shape and behavior of objects. They are useful in helping you enforce consistency and assure that objects conform to specific shapes.

### Declaring Interfaces
To create an interface, use the `interface` keyword followed by the interface name and the structure of the object, including property names and their corresponding types.

```typescript
interface User {
    name: string;
    age: number;
    isActive: boolean;
}

const user: User = {
    name: "Alice",
    age: 30,
    isActive: true,
};
```

The `User` interface describes an object that should have `name`, `age`, and `isActive` properties.

#### Optional Properties
Interfaces allow you to specify optional properties by adding a `?` after the property name

```typescript
interface User {
    name: string;
    age: number;
    email?: string; // Optional property
}

const user1: User = { name: "Alice", age: 30 };
const user2: User = { name: "Bob", age: 25, email: "bob@example.com" };
```

In this example, `email` is an optional property.

#### Read-Only Properties
If you want to make a property immutable (read-only), you can use the `readonly `modifier

```typescript
interface User {
    readonly id: number;
    name: string;
    age: number;
}

const user: User = { id: 1, name: "Alice", age: 30 };

// user.id = 2; // Error: Cannot assign to 'id' because it is a read-only property.
```

Here, the `id` property cannot be modified after it is assigned.

#### Interfaces for Functions
You can also define function types with interfaces

```typescript
interface Greeting {
    (name: string): string;
}

const greet: Greeting = (name) => `Hello, ${name}!`;

console.log(greet("Alice")); // Outputs: "Hello, Alice!"
```

### Extending Interfaces
You can extend interfaces to inherit their properties and add new ones. This promotes code reusability and helps you build on existing interfaces without repeating yourself.

```typescript
interface Address {
    city: string;
    country: string;
}

interface Person extends Address {
    name: string;
    age: number;
}

const user: Person = {
    name: "Alice",
    age: 30,
    city: "Nairobi",
    country: "Kenya",
};
```

In this example, the `Person` interface extends `Address`, meaning it has all the properties from `Address` in addition to its own properties.


## Differences Between Type Aliases and Interfaces
Whether you are a TypeScript fanatic or a confused coder, it's essential to know the difference between the type alias and interface. The type alias is like an alias for types, simplifying types into easier-to-read names. Whereas an interface defines the structure that an object must conform to, focusing on the shape rather than the specific instances. In conclusion, type aliases are perfect when you want to simplify a type, while interfaces make the perfect definition of the object shape.

<table>
<thead>
	<tr>
		<th>Feature</th>
		<th>Type</th>
		<th>Interface</th>
	</tr>
</thead>
<tbody>
	<tr>
		<td>Extensibility</td>
		<td>Cannot be re-opened or extended</td>
		<td>Can be extended using extends</td>
	</tr>
	<tr>
		<td>Declaration Merging</td>
		<td>Does not support declaration merging</td>
		<td>Supports declaration merging</td>
	</tr>
	<tr>
		<td>Use Cases</td>
		<td>More suitable for unions, intersections, and complex types</td>
		<td>Best for defining object shapes, classes, or function signatures</td>
	</tr>
	<tr>
		<td>Compatibility</td>
		<td>Cannot define callable signatures and other advanced types directly</td>
		<td>Can define callable signatures and more</td>
	</tr>
</tbody>
</table>


### When to Use Type Aliases
- Use type when you want to define union types, intersection types, or function signatures.
- Use type when you need a type that is a combination of several types.

### When to Use Interfaces
- Use interface when defining the structure of an object, especially when you expect the object to be used in many places and possibly extended.
- Use interface when working with classes or objects that will be passed between different modules.


## Conclusion
TypeScript’s type, type alias, and interface are essential features that help you enforce type safety and define the shape of data structures in your application. Understanding the nuances of these features allows you to write more robust and maintainable code.
- Use type when you need complex types, such as unions and intersections, or when you want to alias primitive types.
- Use interface for defining object shapes, especially when working with classes or extending types.

By mastering these concepts, you can take full advantage of TypeScript’s powerful type system.
