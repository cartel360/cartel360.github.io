---
layout: post
title: Structural Design Patterns
date: 2024-10-23 00:00:00 
description: Structural design patterns are one of the most critical aspects of software engineering by offering a formulary to recurring design problems. These patterns fall under the mission of architects and developers who intend to put together systems that can be enhanced, made to scale and remain flexible
image: 
    path: /assets/img/structural-design.jpg
tags: [Productivity, Software, Design-Pattern]
categories: [Software Development]
published: true 
---

Structural design patterns are one of the most critical aspects of software engineering by offering a formulary to recurring design problems. These patterns fall under the mission of architects and developers who intend to put together systems that can be enhanced, made to scale and remain flexible. This article is dedicated to structural design patterns and their consideration: what is their relevance, what types exist, advantages and disadvantages, principles and best practices including examples and problems to avoid. Through this examination of structural design patterns, the readers will learn how to utilize these patterns in their own works in order to enhance the quality and ease of maintenance of the software solutions they provide.

This is a continuation of **Introduction to Design Patterns**, if you haven't checked it out you can check it <a href="https://www.billyokeyo.com/posts/design-patterns/" target="_blank">here</a> 


## Why Use Structural Design Patterns?
In intricate systems, it is important for the objects and classes to cooperate with one another while at the same time remaining loosely coupled. Structural design patterns address this need by concentrating on the composition of the system rather than trying to create a hierarchy of classes through inheritance, thus allowing the construction of elaborate structures with great flexibility. These patterns are particularly useful when one needs to:

- Diminish the complexity of relationships between several objects.
- Add or change the behavior of an object during execution of a program.
- Conceal the details of how an object functions internally.
- Prevent components from being interdependent in a way that will complicate the system’s upkeep and development.

## 1. Adapter Pattern
The Adapter pattern allows objects with incompatible interfaces to collaborate. It converts the interface of a class into another interface that a client expects. This pattern is particularly useful when you want to use a class that doesn't have the expected interface but has the functionality you need.

### Implementation of Adapter Pattern
To implement the Adapter pattern, we create an Adapter class that implements the interface expected by the client (target interface) and wraps an instance of the class with the incompatible interface (adaptee). The adapter translates calls from the client into the format expected by the adaptee.

### Use Case for Adapter Pattern
Imagine we have a system that expects to work with XML data, but we have a third-party library that processes JSON. Using the Adapter pattern, we can create a class that converts XML data into JSON format so that the existing system can continue working without any changes.

Example Use Case: We need to parse XML data using a library that only understands JSON.

```csharp
{% raw %}
using System;

namespace AdapterPatternExample
{
    // Target interface (expected by the client)
    public interface IXmlParser
    {
        void ParseXml(string xmlData);
    }

    // Adaptee class (existing functionality that works with JSON)
    public class JsonParser
    {
        public void ParseJson(string jsonData)
        {
            Console.WriteLine("Parsing JSON data: " + jsonData);
        }
    }

    // Adapter class (converts XML data to JSON format)
    public class JsonParserAdapter : IXmlParser
    {
        private readonly JsonParser _jsonParser;

        public JsonParserAdapter(JsonParser jsonParser)
        {
            _jsonParser = jsonParser;
        }

        public void ParseXml(string xmlData)
        {
            // Mock conversion from XML to JSON
            string jsonData = $"{{ 'data': '{xmlData}' }}";
            _jsonParser.ParseJson(jsonData);
        }
    }

    // Example client code using the adapter
    class Program
    {
        static void Main(string[] args)
        {
            // Client expects IXmlParser but is given a JsonParserAdapter
            IXmlParser xmlParser = new JsonParserAdapter(new JsonParser());

            // Parsing XML data through the adapter
            xmlParser.ParseXml("<xml>Legacy XML Data</xml>");  // Adapter converts XML to JSON and then parses JSON
        }
    }
}
{% endraw %}
```

### Explanation
- Target Interface (`IXmlParser`): The `IXmlParser` interface declares the method` ParseXml(string xmlData)`. This establishes a common interface for XML parsing.
- Adaptee Class (`JsonParser`): The `JsonParser` class implements a method `ParseJson(string jsonData)` to handle JSON data. It does not conform to the `IXmlParser` interface, making it unsuitable for direct use in the client's context.
- Adapter Class (`JsonParserAdapter`): The `JsonParserAdapter` class implements the `IXmlParser` interface and holds a reference to an instance of `JsonParser`. The `ParseXml` method takes XML data, converts it to a mock JSON format, and delegates the actual parsing to the JsonParser.
- Client Code (`Program` Class): The `Main` method demonstrates how the client interacts with the adapter. It creates an instance of `JsonParserAdapter`, passing a new `JsonParser` to its constructor. The `ParseXml` method is called on the adapter with an XML string, which is converted to JSON and processed by the `JsonParser`.

### Summary of the Flow
- The client expects a parser that works with XML.
- The existing `JsonParser` only processes JSON, which doesn't fit the client's requirements.
- The `JsonParserAdapter` bridges this gap, allowing the client to use the `JsonParser` for XML data by converting the XML input to a suitable JSON format.

### Benefits of Adapter Pattern
- Compatibility Between Interfaces: The Adapter pattern allows incompatible interfaces to work together, enabling classes to interact without requiring changes to their existing code. This is particularly useful when integrating legacy systems or third-party libraries.
- Flexibility in Code: By using adapters, you can easily switch between different implementations without affecting the client code, providing greater flexibility and reusability.
- Encapsulation of Complexities: The Adapter pattern hides the complexities of the underlying system or API, allowing the client code to work with a simplified interface.

## 2. Decorator Pattern
The Decorator pattern allows behavior to be added to individual objects dynamically without affecting the behavior of other objects from the same class. This pattern is useful when you want to add functionalities to an object in a flexible and reusable way without modifying its code.

### Implementation of Decorator Pattern
In the Decorator pattern, the decorator class implements the same interface as the original object. The decorator class wraps the original object and can extend or modify its behavior by overriding its methods.

### Use Case for Decorator Pattern
In a coffee shop, you might start with a basic coffee and then dynamically add features like milk or sugar to it. Each "add-on" is a decorator that adds extra functionality (or cost) to the base coffee.

Example Use Case: A coffee shop where you start with a simple coffee and add milk and sugar dynamically.

```csharp
using System;

namespace DecoratorPatternExample
{
    // Component interface
    public interface ICoffee
    {
        string GetDescription();
        double GetCost();
    }

    // Concrete component class
    public class SimpleCoffee : ICoffee
    {
        public string GetDescription() => "Simple Coffee";
        public double GetCost() => 2.0;
    }

    // Base decorator class
    public abstract class CoffeeDecorator : ICoffee
    {
        protected ICoffee _coffee;

        public CoffeeDecorator(ICoffee coffee)
        {
            _coffee = coffee;
        }

        public virtual string GetDescription() => _coffee.GetDescription();
        public virtual double GetCost() => _coffee.GetCost();
    }

    // Concrete decorators
    public class MilkDecorator : CoffeeDecorator
    {
        public MilkDecorator(ICoffee coffee) : base(coffee) { }

        public override string GetDescription() => _coffee.GetDescription() + ", Milk";
        public override double GetCost() => _coffee.GetCost() + 0.5;
    }

    public class SugarDecorator : CoffeeDecorator
    {
        public SugarDecorator(ICoffee coffee) : base(coffee) { }

        public override string GetDescription() => _coffee.GetDescription() + ", Sugar";
        public override double GetCost() => _coffee.GetCost() + 0.2;
    }

    // Example client code using decorators
    class Program
    {
        static void Main(string[] args)
        {
            // Base coffee
            ICoffee coffee = new SimpleCoffee();
            Console.WriteLine($"{coffee.GetDescription()} - ${coffee.GetCost()}");

            // Adding milk
            coffee = new MilkDecorator(coffee);
            Console.WriteLine($"{coffee.GetDescription()} - ${coffee.GetCost()}");

            // Adding sugar
            coffee = new SugarDecorator(coffee);
            Console.WriteLine($"{coffee.GetDescription()} - ${coffee.GetCost()}");
        }
    }
}
```

### Explanation
- **Component Interface (`ICoffee`):** This interface declares the methods `GetDescription()` and `GetCost()`, defining the core functionality that both the concrete component and decorators must provide.
- **Concrete Component Class (`SimpleCoffee`):** Implements the `ICoffee` interface, providing basic functionality. `GetDescription()`: Returns a description of the coffee as "Simple Coffee". `GetCost()`: Returns the cost of the coffee, set at $2.0.
- **Base Decorator Class (`CoffeeDecorator`):** Implements `ICoffee` and holds a reference to an `ICoffee` instance.
The constructor takes an `ICoffee` object, allowing decorators to extend its behavior.
Provides virtual implementations of `GetDescription()` and `GetCost()` that delegate to the wrapped coffee object.
- **Concrete Decorators (`MilkDecorator`, `SugarDecorator`):**
  - `MilkDecorator`: 
      - Extends `CoffeeDecorator`, adding milk to the coffee.
      - Overrides `GetDescription()` to include ", Milk".
      - Overrides `GetCost()` to add 0.5 to the base cost.
  - `SugarDecorator`: 
    - Also extends `CoffeeDecorator`, adding sugar to the coffee.
    - Overrides `GetDescription()` to include ", Sugar".
    - Overrides `GetCost()` to add 0.2 to the base cost.
- **Client Code (`Program` Class):** The `Main` method demonstrates how to create a base coffee (`SimpleCoffee`) and then add decorations (milk and sugar) to it.
Each time a decorator is applied, the `GetDescription()` and `GetCost()` methods reflect the updated state of the coffee.

### Output
```
Simple Coffee - $2
Simple Coffee, Milk - $2.5
Simple Coffee, Milk, Sugar - $2.7
```

### Summary of the Flow
- The client starts with a simple coffee object.
- It uses the decorators to add functionality (milk and sugar) without altering the existing `SimpleCoffee` class.
- Each decoration enhances the coffee's description and cost.

### Benefits of Decorator Pattern
- Dynamic Behavior Modification: The Decorator pattern enables adding new functionality to existing objects dynamically without altering their structure. This allows for more flexibility and adaptability to changing requirements.
- Single Responsibility Principle: It adheres to the Single Responsibility Principle by allowing functionality to be divided among various decorators, making the code easier to manage and maintain.
- Enhanced Extensibility: New decorators can be created without modifying existing code, making it easy to extend the functionality of classes in a scalable way.

## 3. Facade Pattern
The Facade pattern provides a simplified interface to a complex subsystem. It hides the complexity of the underlying components and exposes only the necessary parts to the client. This pattern is particularly useful when working with complex libraries or systems that have multiple interacting components.

### Implementation of Facade Pattern
A facade class provides methods that simplify client interactions with multiple subsystems. It abstracts the complexity and reduces dependencies by exposing only high-level operations.

### Use Case for Facade Pattern
Imagine a home theater system with multiple devices like a projector, sound system, and DVD player. Each of these devices has a complex interface. The Facade pattern can be used to provide a simplified interface for controlling the entire home theater.

Example Use Case: Simplify controlling a home theater system with a facade that turns on the projector, sound system, and DVD player.

```csharp
using System;

namespace FacadePatternExample
{
    // Subsystem classes
    public class Projector
    {
        public void On() => Console.WriteLine("Projector is on.");
        public void Off() => Console.WriteLine("Projector is off.");
    }

    public class SoundSystem
    {
        public void On() => Console.WriteLine("Sound system is on.");
        public void Off() => Console.WriteLine("Sound system is off.");
    }

    public class DvdPlayer
    {
        public void Play() => Console.WriteLine("DVD is playing.");
        public void Stop() => Console.WriteLine("DVD stopped.");
    }

    // Facade class
    public class HomeTheaterFacade
    {
        private readonly Projector _projector;
        private readonly SoundSystem _soundSystem;
        private readonly DvdPlayer _dvdPlayer;

        public HomeTheaterFacade(Projector projector, SoundSystem soundSystem, DvdPlayer dvdPlayer)
        {
            _projector = projector;
            _soundSystem = soundSystem;
            _dvdPlayer = dvdPlayer;
        }

        public void StartMovie()
        {
            _projector.On();
            _soundSystem.On();
            _dvdPlayer.Play();
            Console.WriteLine("Movie started.");
        }

        public void EndMovie()
        {
            _dvdPlayer.Stop();
            _soundSystem.Off();
            _projector.Off();
            Console.WriteLine("Movie ended.");
        }
    }

    // Example client code using the facade
    class Program
    {
        static void Main(string[] args)
        {
            // Facade simplifies the interaction with complex subsystems
            var homeTheater = new HomeTheaterFacade(new Projector(), new SoundSystem(), new DvdPlayer());

            // Start a movie
            homeTheater.StartMovie();
            
            // End the movie
            homeTheater.EndMovie();
        }
    }
}
```

### Output
```
Projector is on.
Sound system is on.
DVD is playing.
Movie started.
DVD stopped.
Sound system is off.
Projector is off.
Movie ended.
```

### Explanation
- **Subsystem Classes:** 
  - **Projector:** Has methods to turn the projector on and off, providing simple output messages to indicate the current state.
  - **SoundSystem:** Similar to `Projector`, with methods to manage the sound system state.
  - **DvdPlayer:** Manages DVD playback with methods to play and stop the DVD.
- **Facade Class (`HomeTheaterFacade`):**
  - Provides a simplified interface to interact with multiple subsystems.
  - Constructor takes instances of the subsystems, allowing the facade to control them.
  - `StartMovie()` method orchestrates the interactions needed to start a movie:
    - Turns on the projector and sound system.
    - Starts playing the DVD.
    - Prints a message indicating the movie has started.
  - `EndMovie()` method orchestrates the cleanup after the movie:
    - Stops the DVD playback.
    - Turns off the sound system and projector.
    - Prints a message indicating the movie has ended.
- **Client Code (`Program` Class):**
  - The `Main` method demonstrates how the HomeTheaterFacade simplifies the interaction with the various subsystems.
  - The client creates an instance of the facade, which wraps the complexity of managing multiple components.
  - It calls `StartMovie()` to initiate the movie experience and `EndMovie()` to conclude it.

### Summary of the Flow
- The client interacts with the `HomeTheaterFacade` rather than each individual subsystem.
- The facade handles the sequence of operations required to start and stop a movie.

### Benefits of Facade Pattern
- Simplified Interface: The Facade pattern provides a simplified interface to a complex subsystem, making it easier for clients to interact with the system. This reduces the learning curve for new users and developers.
- Encapsulation of Complexity: It encapsulates the complexities of the subsystem, promoting loose coupling between the client and the subsystem components. This helps in managing the system’s complexity.
- Improved Code Maintainability: By reducing dependencies on the underlying components, the Facade pattern improves maintainability. Changes to the subsystem can be made with minimal impact on the client code.

## 4. Flyweight Pattern
The Flyweight pattern is used to minimize memory usage by sharing as much data as possible with similar objects. This is particularly useful when dealing with large numbers of objects that have a lot of common properties. Flyweight allows you to store common data externally and share it among multiple instances.

### Implementation of Flyweight Pattern
The Flyweight pattern uses a FlyweightFactory to create and manage the shared objects (flyweights). These flyweights contain intrinsic state (common properties shared across many objects) and extrinsic state (unique data for each instance).

### Use Case for Flyweight Pattern
Suppose you're developing a game that involves a lot of trees being rendered in a forest. Each tree has properties like type, color, and texture that can be shared among all trees of the same type. By using the Flyweight pattern, you can store these properties externally and reuse them to save memory.

Example Use Case: A tree visualization where we reuse shared attributes (type, color) for multiple trees while keeping their unique positions separate.

```csharp
using System;
using System.Collections.Generic;

namespace FlyweightPatternExample
{
    // Flyweight (intrinsic shared state)
    public class TreeType
    {
        public string Name { get; private set; }
        public string Color { get; private set; }

        public TreeType(string name, string color)
        {
            Name = name;
            Color = color;
        }

        public void Display(int x, int y)
        {
            Console.WriteLine($"Displaying {Name} tree of color {Color} at coordinates ({x},{y}).");
        }
    }

    // Flyweight Factory
    public class TreeFactory
    {
        private static Dictionary<string, TreeType> _treeTypes = new Dictionary<string, TreeType>();

        public static TreeType GetTreeType(string name, string color)
        {
            string key = $"{name}_{color}";
            if (!_treeTypes.ContainsKey(key))
            {
                _treeTypes[key] = new TreeType(name, color);
            }
            return _treeTypes[key];
        }
    }

    // Context (extrinsic state: unique location for each tree)
    public class Tree
    {
        private int _x;
        private int _y;
        private TreeType _treeType;

        public Tree(int x, int y, TreeType treeType)
        {
            _x = x;
            _y = y;
            _treeType = treeType;
        }

        public void Display()
        {
            _treeType.Display(_x, _y);
        }
    }

    // Example client code
    class Program
    {
        static void Main(string[] args)
        {
            // Creating trees with shared attributes using Flyweight pattern
            Tree tree1 = new Tree(1, 2, TreeFactory.GetTreeType("Oak", "Green"));
            Tree tree2 = new Tree(3, 4, TreeFactory.GetTreeType("Pine", "Dark Green"));
            Tree tree3 = new Tree(5, 6, TreeFactory.GetTreeType("Oak", "Green"));

            // Display trees
            tree1.Display(); 
            tree2.Display(); 
            tree3.Display(); 

            // Notice that the Oak tree with the same color is reused
        }
    }
}
```

### Output
```
Displaying Oak tree of color Green at coordinates (1,2).
Displaying Pine tree of color Dark Green at coordinates (3,4).
Displaying Oak tree of color Green at coordinates (5,6).
```

### Explanation
- **Flyweight (Intrinsic State):**
  - TreeType:
    - Represents shared state (intrinsic state) for tree objects.
    - The constructor initializes the Name and Color properties.
    - The `Display(int x, int y)` method is responsible for outputting the tree's information, including its position on a coordinate plane.
- **Flyweight Factory:**
  - TreeFactory:
    - Manages the creation and retrieval of TreeType instances.
    - The static dictionary `_treeTypes` keeps track of existing tree types.
    - The `GetTreeType(string name, string color)` method checks if a `TreeType` with the specified name and color exists; if not, it creates a new instance and adds it to the dictionary.
- **Context (Extrinsic State):**
  - Tree:
    - Represents individual trees with their unique coordinates.
    - Holds a reference to a shared `TreeType` (flyweight).
    - The constructor initializes the tree's position and associates it with a `TreeType`.
    - The `Display()` method calls the `Display()` method of the TreeType to print the tree's details along with its coordinates.
- **Client Code (`Program` Class):**
  - The `Main` method demonstrates the Flyweight Pattern in action.
  - Three `Tree` instances are created, with `tree1` and `tree3` sharing the same `TreeType` (Oak tree of color Green).
  - The `Display()` method is called on each tree to output its details.

### Summary of the Flow
- The `TreeFactory` is used to create or retrieve `TreeType` instances.
- Individual Tree instances hold their unique state (coordinates) while sharing the intrinsic state (type and color) from `TreeType`.

### Benefits of Flyweight Pattern
- Memory Efficiency: The Flyweight pattern significantly reduces memory usage by sharing common parts of the state (intrinsic state) among multiple objects. This is particularly beneficial in scenarios where a large number of objects need to be created with similar attributes.
- Improved Performance: By minimizing the overhead of object creation and memory allocation, the Flyweight pattern can improve the performance of applications that handle many similar objects.
- Separation of Concerns: The Flyweight pattern encourages the separation of intrinsic and extrinsic states, which helps in organizing code better and making it easier to maintain and extend.

## 5. Composite Pattern
The Composite pattern is used to treat individual objects and compositions of objects uniformly. It allows you to build a tree structure of objects where individual objects (leaf nodes) and groups of objects (composite nodes) are treated the same. This pattern is useful when you want to work with hierarchical structures like file systems, where folders and files need to be handled in the same way.

### Implementation of Composite Pattern
You define a component interface that both individual objects (leaf) and composite objects (containing multiple children) will implement. The composite objects can hold references to other components.

### Use Case for Composite Pattern
Let's take the example of a company structure where employees can either be individual contributors (leaf nodes) or managers (composite nodes) who manage other employees. Both types should be able to perform work, but managers can also delegate work to their subordinates.

Example Use Case: Modeling a company’s hierarchy where managers can manage employees or other managers.

```csharp
using System;
using System.Collections.Generic;

namespace CompositePatternExample
{
    // Component interface
    public interface IEmployee
    {
        void ShowDetails();
    }

    // Leaf class (individual employee)
    public class Developer : IEmployee
    {
        private string _name;
        private string _position;

        public Developer(string name, string position)
        {
            _name = name;
            _position = position;
        }

        public void ShowDetails()
        {
            Console.WriteLine($"{_name} works as a {_position}.");
        }
    }

    // Composite class (manager with subordinates)
    public class Manager : IEmployee
    {
        private string _name;
        private string _position;
        private List<IEmployee> _subordinates = new List<IEmployee>();

        public Manager(string name, string position)
        {
            _name = name;
            _position = position;
        }

        public void AddSubordinate(IEmployee employee)
        {
            _subordinates.Add(employee);
        }

        public void ShowDetails()
        {
            Console.WriteLine($"{_name} works as a {_position} and manages:");
            foreach (var subordinate in _subordinates)
            {
                subordinate.ShowDetails();
            }
        }
    }

    // Example client code
    class Program
    {
        static void Main(string[] args)
        {
            // Creating individual employees (leaf nodes)
            IEmployee dev1 = new Developer("John", "Backend Developer");
            IEmployee dev2 = new Developer("Alice", "Frontend Developer");

            // Creating manager (composite node)
            Manager manager = new Manager("Michael", "Team Lead");
            manager.AddSubordinate(dev1);
            manager.AddSubordinate(dev2);

            // Display details of manager and subordinates
            manager.ShowDetails();
            
        }
    }
}
```

### Output
```
Michael works as a Team Lead and manages:
John works as a Backend Developer.
Alice works as a Frontend Developer.
```

### Explanation
- **Component Interface:**
  - `IEmployee`:
  - This interface defines a common contract for all employee classes.
  - The `ShowDetails()` method will be used to output details for both leaf and composite nodes.
- **Leaf Class:**
  - Developer:
    - Represents an individual employee (leaf node).
    - Contains properties for the employee's name and position.
    - The constructor initializes these properties.
    - The `ShowDetails()` method prints the developer's name and position.
- **Composite Class:**
  - Manager:
    - Represents a manager who can have subordinates (other employees).
    - Contains properties for the manager's name and position, and a list of subordinates.
    - The constructor initializes the manager's name and position.
    - The AddSubordinate(IEmployee employee) method allows adding an `IEmployee` (which can be either a Developer or another Manager) to the list of subordinates.
    - The `ShowDetails()` method prints the manager's name and position, followed by details of each subordinate by calling their `ShowDetails()` method.
- **Client Code (`Program` Class):**
  - The `Main` method demonstrates the Composite Pattern in action.
  - Two Developer instances are created (leaf nodes), and a Manager instance is created (composite node).
  - The `AddSubordinate()` method is called on the manager to add the two developers as subordinates.
  - Finally, `ShowDetails()` is called on the manager to print out the hierarchy of employees.

### Summary of the Flow
- The `IEmployee` interface allows both leaf and composite objects to be treated uniformly.
- `Developer` instances represent individual employees with no further subdivisions.
- The `Manager` instance can manage multiple `IEmployee` objects, whether they are `Developer` instances or other `Manager` instances.

### Benefits of Composite Pattern
- Unified Treatment of Objects: The Composite pattern allows you to treat individual objects and compositions of objects uniformly, simplifying client code. This is especially useful when dealing with hierarchical structures, as it provides a consistent interface.
- Flexibility in Composition: It enables easy composition of objects into tree structures, making it easy to add or remove components without affecting the client code.
- Simplifies Client Code: Clients can work with complex tree structures without needing to understand the details of the underlying implementation. This leads to cleaner and more manageable code.

## 6. Bridge Pattern
The Bridge pattern decouples an abstraction from its implementation so that the two can vary independently. This pattern is useful when you want to avoid a permanent binding between an abstraction and its implementation. It’s often used when dealing with different platforms or operating systems to abstract differences between them.

### Implementation of Bridge Pattern
You define an abstraction and an implementation interface. The abstraction holds a reference to an implementation object, and the concrete implementation provides the details.

### Use Case for Bridge Pattern
Imagine you're developing a remote control for different devices (e.g., TV, Radio). The remote control should be able to work with different devices without hardcoding the functionality for each one. The Bridge pattern allows you to separate the control (abstraction) from the actual devices (implementation).

Example Use Case: A remote control that can operate different types of devices such as TVs and Radios using the Bridge pattern.

```csharp
using System;

namespace BridgePatternExample
{
    // Implementor interface (device control interface)
    public interface IDevice
    {
        void TurnOn();
        void TurnOff();
        void SetVolume(int volume);
    }

    // Concrete implementor (TV)
    public class TV : IDevice
    {
        public void TurnOn() => Console.WriteLine("TV is turned on.");
        public void TurnOff() => Console.WriteLine("TV is turned off.");
        public void SetVolume(int volume) => Console.WriteLine($"TV volume set to {volume}.");
    }

    // Concrete implementor (Radio)
    public class Radio : IDevice
    {
        public void TurnOn() => Console.WriteLine("Radio is turned on.");
        public void TurnOff() => Console.WriteLine("Radio is turned off.");
        public void SetVolume(int volume) => Console.WriteLine($"Radio volume set to {volume}.");
    }

    // Abstraction (Remote Control)
    public class RemoteControl
    {
        protected IDevice _device;

        public RemoteControl(IDevice device)
        {
            _device = device;
        }

        public void TurnOn() => _device.TurnOn();
        public void TurnOff() => _device.TurnOff();
        public void SetVolume(int volume) => _device.SetVolume(volume);
    }

    // Refined abstraction (Advanced Remote Control)
    public class AdvancedRemoteControl : RemoteControl
    {
        public AdvancedRemoteControl(IDevice device) : base(device) { }

        public void Mute()
        {
            Console.WriteLine("Muting the device.");
            _device.SetVolume(0);
        }
    }

    // Example client code
    class Program
    {
        static void Main(string[] args)
        {
            // Controlling a TV with basic remote
            RemoteControl tvRemote = new RemoteControl(new TV());
            tvRemote.TurnOn();
            tvRemote.SetVolume(20);
            tvRemote.TurnOff();

            // Controlling a Radio with advanced remote
            AdvancedRemoteControl radioRemote = new AdvancedRemoteControl(new Radio());
            radioRemote.TurnOn();
            radioRemote.SetVolume(15);
            radioRemote.Mute();
            radioRemote.TurnOff();
        }
    }
}

```

### Output
```
TV is turned on.
TV volume set to 20.
TV is turned off.
Radio is turned on.
Radio volume set to 15.
Muting the device.
Radio volume set to 0.
Radio is turned off.
```

### Explanation:
- **Implementor Interface (`IDevice`)**: This interface defines the methods for controlling a device: `TurnOn()`, `TurnOff()`, and `SetVolume(int volume)`. It acts as the contract for concrete device implementations.
- **Concrete Implementors (`TV`, `Radio`)**: These classes implement the `IDevice` interface and provide specific implementations for a TV and a Radio. Each has methods to turn the device on or off and set the volume:
  - `TV`: Implements `TurnOn()`, `TurnOff()`, and `SetVolume()` for a TV device.
  - `Radio`: Implements `TurnOn()`, `TurnOff()`, and `SetVolume()` for a Radio device.
- **Abstraction (`RemoteControl`)**: This class represents the abstraction, which maintains a reference to an `IDevice` object. It defines high-level operations (`TurnOn()`, `TurnOff()`, and `SetVolume()`), which delegate the work to the associated device implementor (`IDevice`).
- **Refined Abstraction (`AdvancedRemoteControl`)**: Extends `RemoteControl` to provide additional functionality (e.g., a `Mute()` method that sets the volume to 0). This class adds new behavior while using the `IDevice` methods from the base class.
- **Client Code (`Program` Class)**: The `Main` method demonstrates how to use the bridge pattern by controlling different devices (TV and Radio) using remote controls. 
  - A `RemoteControl` is used to control the TV by turning it on, setting the volume, and turning it off.
  - An `AdvancedRemoteControl` is used to control the Radio by turning it on, adjusting the volume, muting it, and turning it off. The advanced remote has an additional `Mute()` functionality.

### Summary of the Flow
- The `IDevice` interface defines the basic operations that all device types (like TV and Radio) must implement.
- The `RemoteControl` abstraction allows different devices to be controlled using a common interface, decoupling device control from specific implementations.
- The `AdvancedRemoteControl` extends functionality by adding features like `Mute`, providing additional control without modifying the underlying devices.

### Benefits of Bridge Pattern
- Decoupling of Abstraction and Implementation: The Bridge pattern allows the abstraction and its implementation to vary independently. This means you can change the implementation without modifying the abstraction and vice versa.
- Enhances Code Flexibility and Scalability: By separating concerns, it becomes easier to extend the system. New implementations can be added without changing the existing code structure.
- Improves Code Maintainability: The clear separation of abstraction and implementation helps improve the maintainability of the codebase. Changes in one part of the code are less likely to impact other parts.


Structural design patterns focus on how objects and classes are composed to form larger structures while keeping these structures flexible and efficient. They simplify relationships between entities and allow systems to be extended or modified without major refactoring. Patterns like Adapter, Decorator, Facade, Flyweight, Composite, and Bridge offer different approaches to enhance code modularity, reusability, and flexibility, making systems easier to maintain and extend. Understanding these patterns helps in building systems that are more adaptable to change and scalable in the long run.

>You can get the source code of the examples used on the github <a target="_blank" href="https://github.com/cartel360/Structural-Design-Patterns">here</a>
{:.prompt-tip}



