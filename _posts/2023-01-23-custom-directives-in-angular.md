---
layout: post
title: Custom Directives in Angular
date: 2023-01-23 00:00:00 
description: One of the key features of Angular is the ability to create custom directives. Directives are markers on a DOM element that tell Angular to attach a specific behavior or functionality to that element
image:
  path: /assets/img/custom-directives-angular.png 
tags: [Productivity, Software, Angular] # add tag
categories: [Software Development]
published: true
---
 One of the key features of Angular is the ability to create custom directives. Directives are markers on a DOM element that tell Angular to attach a specific behavior or functionality to that element. Custom directives allow developers to extend the functionality of Angular and create reusable components that can be used throughout an application.

There are two types of directives in Angular: 
- Structural Directives
- Attribute Directives.
- Component Directives

__Structural directives__ alter the structure of the DOM, such as by adding or removing elements. An example of a structural directive is ngFor, which is used to loop through an array and create multiple elements for each item in the array. 

__Attribute directives__, on the other hand, change the appearance or behavior of an element without altering its structure. An example of an attribute directive is ngClass, which can be used to add or remove CSS classes from an element based on certain conditions.

__Component directives__ is a directive that is also a component. In other words, it is a class decorated with the `@Component` decorator in addition to the `@Directive` decorator. These directives are typically used to create reusable UI components such as a custom button or a custom form input.

To create a custom directive, first, a new TypeScript class is created that defines the directive's behavior and functionality. This class is decorated with the `@Directive` decorator, which is imported from the `@angular/core` module. The `@Directive` decorator takes an object that defines the selector for the directive and the type of directive it is (structural or attribute). 

### Custom Attribute Directive Example
```ts
import { Directive } from '@angular/core';

@Directive({
  selector: '[appHighlight]',
  host: {
    '(mouseenter)': 'onMouseEnter()',
    '(mouseleave)': 'onMouseLeave()'
  }
})
export class HighlightDirective {
  onMouseEnter() {
    // logic to highlight element
  }

  onMouseLeave() {
    // logic to remove highlight
  }
}
```
In this example, the directive is an attribute directive with the selector appHighlight. The host property is used to attach event listeners to the element the directive is applied to, in this case, the mouseenter and mouseleave events. The onMouseEnter and onMouseLeave methods contain the logic for highlighting and removing the highlight from the element.

Once the directive is created, it needs to be added to the declarations array of the module where it will be used.
```ts
import { HighlightDirective } from './highlight.directive';

@NgModule({
  declarations: [HighlightDirective],
  // ...
})
export class AppModule { }
```
The directive can now be used in the template by applying the selector as an attribute to an element.
```html
<div appHighlight>This text will be highlighted on mouse over</div>
```

### Custom Structural Directive Example
Here is an example of a custom structural directive that can be used to conditionally show or hide an element based on a boolean value:
```ts
import { Directive, Input, TemplateRef, ViewContainerRef } from '@angular/core';

@Directive({
  selector: '[appShowHide]'
})
export class ShowHideDirective {
  @Input() set appShowHide(condition: boolean) {
    if (condition) {
      this.viewContainer.createEmbeddedView(this.templateRef);
    } else {
      this.viewContainer.clear();
    }
  }

  constructor(private templateRef: TemplateRef<any>, private viewContainer: ViewContainerRef) { }
}
```

In this example, the directive is a structural directive with the selector appShowHide. The directive has an input setter that takes a boolean value. If the value is true, the directive will create an embedded view of the template and add it to the DOM. If the value is false, the directive will clear the view container, effectively removing the element from the DOM.

The directive can be used in the template like this:
```html
<div *appShowHide="showElement">This will be shown or hidden based on the value of "showElement"</div>
```

In this example, the directive is used with the * (asterisk) notation, which is a shorthand for using the ng-template directive. By using the * notation, the element that the directive is applied to is not included in the final DOM and the directive is responsible for adding or removing the element.

This is just one example of a custom structural directive, you can create a structural directive that performs other tasks such as creating new elements or manipulating the structure of the DOM.

### Custom Component Directive Example
Here's an example of a custom component directive that creates a reusable button component:
```ts
import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-custom-button',
  template: `
    <button (click)="onClick()">{{ label }}</button>
  `,
  styles: []
})
export class CustomButtonComponent {
  @Input() label: string;
  @Output() click = new EventEmitter<void>();

  onClick() {
    this.click.emit();
  }
}
```

In this example, the directive is a component directive with the selector "app-custom-button", It has an input property "label" that can be used to set the label of the button, and an output event "click" that is emitted when the button is clicked.

This component can be used in a template like this:
```html
<app-custom-button label="Click me" (click)="handleClick()"></app-custom-button>
```


It's important to note that the custom structural directive should be added to the declarations array of the module where it will be used, similarly to custom attribute directives.

When creating custom directives, it's important to consider the best practices for creating maintainable and scalable code. This includes keeping the directive's functionality small and specific, isolating the directive's logic from the parent component, and properly handling inputs and outputs.

In addition to the basic functionality provided by the directive, developers can also pass inputs to the directive using the `@Input` decorator, which allows data to be passed into the directive from the parent component. Outputs can also be used with the @Output decorator to emit events from the directive to the parent component.

Another important aspect of custom directives is their ability to manipulate the DOM. With the help of the Renderer2 class, which is provided by Angular, developers can perform actions such as creating new elements, setting styles and attributes, and adding and removing classes. This allows for greater flexibility and control over the appearance and behavior of elements on the page.

It's also worth noting that custom directives can be used in combination with other Angular features such as services and pipes to create more powerful and complex functionality. For example, a custom directive can be used to make an HTTP request to an API and display the data in a specific format using a pipe.

In conclusion, Custom Directives are powerful feature provided by Angular which allows extending the functionality of the framework, Creating reusable components and encapsulating complex logic and behavior into a single, easy-to-use element that can be applied throughout an application. They are simple to create and use, and can greatly improve the maintainability and scalability of an Angular application.
