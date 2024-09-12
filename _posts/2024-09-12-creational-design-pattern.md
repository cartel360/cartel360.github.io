---
layout: post
title: Creational Design Patterns
date: 2024-09-12 00:00:00 
description: Creational design patterns play a crucial role in software development by providing solutions for object creation mechanisms. These patterns help in encapsulating and abstracting the instantiation process, promoting flexibility and reusability in code.
image: 
    path: /assets/img/creational-design.jpg
tags: [Productivity, Software, Design-Pattern]
categories: [Software Development]
published: true 
canonical_url: https://www.innova.co.ke/advanced-exception-handling-in-python/
---

In software engineering, especially software design, a number of techniques are used to address the development of the processes of creating complex objects, called creational design patterns. The purposes of these patterns include the storing and hiding of the instantiation of an object, thereby facilitating the reuse and flexibility of the source code. The possibility of design and usage of a software system many times determines how robust and maintainable this system will be. This article provides an overview of a number of creational design patterns including, but not limited to, the Singleton, Factory Method, Abstract Factory, Prototype, and Builder patterns with their approaches, implementations, and use cases.

This is a continuation of **Introduction to Design Patterns**, if you haven't checked it out you can check it <a href="https://www.billyokeyo.com/posts/design-patterns/" target="_blank">here</a> 

## Creational Design Patterns: Where Objects Are Born
### Definition of Creational Design Patterns
Think about how nice it would be if there is an unlimited scope to recreate Geographical Area objects without restrictions. Creational design patterns are the templates that help in achieving this vision. They specify the rules which are to be followed for the creation of objects in a way that is appropriate and which can be reversed when need be.

### Importance of Creational Design Patterns
If you were a chef with a collection of recipes, developers would use different types of creational design patterns to cook an object in an orderly and sophisticated manner. These patterns assist in isolating the creation of an object away from the working code, therefore improving manageability and maintainability. In brief, these simplifications facilitate a usually complex process of creating an object.

## 1. Singleton Pattern
Let us welcome the attention seeking Singleton pattern, which most rightly might be considered the James Bond of the design patterns: the most elegant and the most reserved. This pattern guarantees that a class has only one object and provides a way of accessing that object. The very best in situations when you need to have one object which will be responsible, for instance, for the storage of configuration data or the control of the access to certain functionalities

### Implementation of Singleton Pattern
In effect, we are adding creative touch in establishing a Singleton by introducing a static method that controls the process of object creation in such a way that only one object is created and no more. It’s like having a restricted access object where there will be no clones or copies of the object only exclusive usage for the person with granted permissions..

### Use Cases for Singleton Pattern
Want to have one logger for all your application? Worry not, Singleton is here for you. One of the most useful patterns for managing things like the persistence of a database connection or the scope of a user session is the singleton pattern – when one instance is all you need.

```csharp
using System;
using System.IO;

namespace SingletonPatternExample
{
    // Singleton Logger class
    public sealed class Logger
    {
        private static Logger _instance = null;
        private static readonly object _lock = new object();
        private string _logFilePath;

        // Private constructor to prevent direct instantiation
        private Logger()
        {
            // Log file path (can be any location you prefer)
            _logFilePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "log.txt");
        }

        // Public static property to access the single instance
        public static Logger Instance
        {
            get
            {
                // Thread-safe double-check locking to ensure only one instance is created
                if (_instance == null)
                {
                    lock (_lock)
                    {
                        if (_instance == null)
                        {
                            _instance = new Logger();
                        }
                    }
                }
                return _instance;
            }
        }

        // Method to log a message
        public void Log(string message)
        {
            string logMessage = $"{DateTime.Now}: {message}";
            Console.WriteLine(logMessage); // Output to the console
            File.AppendAllText(_logFilePath, logMessage + Environment.NewLine); // Append to log file
        }
    }

    // Example class using the Logger
    class Database
    {
        public void Connect()
        {
            Logger.Instance.Log("Database connected.");
        }
    }

    // Example class using the Logger
    class UserSession
    {
        public void StartSession(string userName)
        {
            Logger.Instance.Log($"User session started for {userName}.");
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Using the singleton logger in different parts of the application
            Logger.Instance.Log("Application started.");

            Database db = new Database();
            db.Connect();

            UserSession session = new UserSession();
            session.StartSession("JohnDoe");

            Logger.Instance.Log("Application finished.");
        }
    }
}

```

#### Key Points
**Logger Singleton**: The `Logger` class is a Singleton with a private constructor to prevent multiple instances. It uses a lock to ensure thread safety in multi-threaded environments.

**Log File**: Logs are written to both the console and a text file `log.txt` within the application's directory.

**Double-Checked Locking**: The `Instance` property ensures only one instance of the Logger is created, using double-checked locking to manage thread safety.

**Multiple Usage Scenarios**: Classes like `Database` and `UserSession` use the same `logger` instance to log their actions.

#### Output
```
Application started.
Database connected.
User session started for JohnDoe.
Application finished.
```

And in the `log.txt` file, the same messages will be appended with timestamps.

## 2. Factory Method Pattern
Imagine a situation where there is a factory and different objects are produced based on a generic interface.Present pattern is an example of factory method design pattern. This pattern enables a class to handle object creation by passing on the word to the subclasses, who can figure out the exact class to be created.

### Differences between Factory Method Pattern and Simple Factory Pattern
The Simple Factory pattern defines a single class in charge of object creation. For its part, the Factory Method Pattern allows dividing this responsibility between the classes by delegating the creation to subclass(es). It is self-service where one can make his or her own burger or sit back at the restaurant and order whatever is on the menu..

### Example of Factory Method Pattern in Action
Let us consider an assembly line of vehicles where each and every factory(s subclass) makes a particular category of vehicles. Be it car factory making saloons or a bicycle factory making bicycle’s. The Factory Method pattern helps to create objects with ease without making the creator class do all the work.

```csharp
using System;

namespace FactoryMethodPattern
{
    // Abstract Product: Vehicle
    public abstract class Vehicle
    {
        public abstract void Drive();
    }

    // Concrete Product: Car
    public class Car : Vehicle
    {
        public override void Drive()
        {
            Console.WriteLine("Driving a car.");
        }
    }

    // Concrete Product: Bike
    public class Bike : Vehicle
    {
        public override void Drive()
        {
            Console.WriteLine("Riding a bike.");
        }
    }

    // Abstract Creator: VehicleFactory
    public abstract class VehicleFactory
    {
        // Factory Method
        public abstract Vehicle CreateVehicle();

        public void AssembleVehicle()
        {
            // The factory method is called to create a vehicle.
            Vehicle vehicle = CreateVehicle();
            Console.WriteLine("Assembling vehicle.");
            vehicle.Drive();
        }
    }

    // Concrete Creator: CarFactory
    public class CarFactory : VehicleFactory
    {
        public override Vehicle CreateVehicle()
        {
            return new Car();
        }
    }

    // Concrete Creator: BikeFactory
    public class BikeFactory : VehicleFactory
    {
        public override Vehicle CreateVehicle()
        {
            return new Bike();
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Create a car factory and assemble a car
            VehicleFactory carFactory = new CarFactory();
            carFactory.AssembleVehicle();

            Console.WriteLine();

            // Create a bike factory and assemble a bike
            VehicleFactory bikeFactory = new BikeFactory();
            bikeFactory.AssembleVehicle();
        }
    }
}
```

#### Explanation
**Abstract Product (Vehicle)**: Defines the interface for all vehicles. In this case, it has a method Drive().

**Concrete Products (Car and Bike)**: These are the actual vehicle classes that inherit from the Vehicle class. Each concrete product provides its own implementation of the Drive() method.

**Abstract Creator (VehicleFactory)**: Declares the Factory Method (CreateVehicle()), which subclasses must implement to return a specific product (vehicle). It also contains an operation AssembleVehicle() that relies on the factory method.

**Concrete Creators (CarFactory and BikeFactory)**: These are the factories that implement the CreateVehicle() method to return specific types of vehicles (Car and Bike).

#### Output
```
Assembling vehicle.
Driving a car.

Assembling vehicle.
Riding a bike.
```

#### How it Works
**Factory Method**: The `CreateVehicle()` method in `VehicleFactory` is abstract, allowing each subclass (i.e., `CarFactory` or `BikeFactory`) to define which type of vehicle to instantiate.

**Flexible Creation**: The client code (in this case, `AssembleVehicle()`) doesn't know which concrete vehicle is being created; it simply calls the factory method, and the subclass takes care of the specific object creation.


## 3. Abstract Factory Pattern
Now when you start searching for the Abstract Factory pattern it is almost as if you have walk into a design room in which various sets of design objects are brought together at the same time. This design pattern allows us to create sets of related or dependent objects without the need for their concrete classes to be defined.

### Relationship between Abstract Factory Pattern and Factory Method Pattern
So, Factory Method style aims on particular object creation, while working with the Abstract Factory pattern consolidates such objects into a group. See Factory Method as cooking one single meal, while in Abstract Factory you are preparing a number of different dishes from one specific cuisine type

### Benefits of Abstract Factory Pattern:
**Encapsulation of Object Creation**: The factories encapsulate the creation of related objects, making it easy to extend with new product families (e.g., a Linux GUI).

**Flexibility**: You can change the family of objects used throughout the codebase without changing the client code, making your system more flexible.

### Real-world Application of Abstract Factory Pattern
Whether it be producing parts of the application’s User Interface for every operating system or creating parts needed to connect the application with the databases of several different database vendors, the Abstract Factory style excels in areas where the need is to assemble sets of objects that are consistent and well integrated. It’s like getting a design set of custom parts pressed to fit together perfectly without the hassle of ever specifying which class to design for what part

In this example, we’ll create GUI components (buttons and checkboxes) for two different operating systems: Windows and Mac. The Abstract Factory pattern will allow us to create these components without tying our code to specific concrete classes.

```csharp
using System;

namespace AbstractFactoryPattern
{
    // Abstract Product A: Button
    public interface IButton
    {
        void Paint();
    }

    // Concrete Product A1: Windows Button
    public class WindowsButton : IButton
    {
        public void Paint()
        {
            Console.WriteLine("Rendering a button in Windows style.");
        }
    }

    // Concrete Product A2: Mac Button
    public class MacButton : IButton
    {
        public void Paint()
        {
            Console.WriteLine("Rendering a button in Mac style.");
        }
    }

    // Abstract Product B: Checkbox
    public interface ICheckbox
    {
        void Paint();
    }

    // Concrete Product B1: Windows Checkbox
    public class WindowsCheckbox : ICheckbox
    {
        public void Paint()
        {
            Console.WriteLine("Rendering a checkbox in Windows style.");
        }
    }

    // Concrete Product B2: Mac Checkbox
    public class MacCheckbox : ICheckbox
    {
        public void Paint()
        {
            Console.WriteLine("Rendering a checkbox in Mac style.");
        }
    }

    // Abstract Factory: GUI Factory
    public interface IGUIFactory
    {
        IButton CreateButton();
        ICheckbox CreateCheckbox();
    }

    // Concrete Factory 1: Windows Factory
    public class WindowsFactory : IGUIFactory
    {
        public IButton CreateButton()
        {
            return new WindowsButton();
        }

        public ICheckbox CreateCheckbox()
        {
            return new WindowsCheckbox();
        }
    }

    // Concrete Factory 2: Mac Factory
    public class MacFactory : IGUIFactory
    {
        public IButton CreateButton()
        {
            return new MacButton();
        }

        public ICheckbox CreateCheckbox()
        {
            return new MacCheckbox();
        }
    }

    // Client class that uses the factories
    public class Application
    {
        private readonly IButton _button;
        private readonly ICheckbox _checkbox;

        // The client code works with factories through their abstract interface
        public Application(IGUIFactory factory)
        {
            _button = factory.CreateButton();
            _checkbox = factory.CreateCheckbox();
        }

        public void Render()
        {
            _button.Paint();
            _checkbox.Paint();
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Simulating client decision based on operating system
            IGUIFactory factory;

            Console.WriteLine("Select operating system (windows/mac): ");
            string os = Console.ReadLine().ToLower();

            if (os == "windows")
            {
                factory = new WindowsFactory();
            }
            else if (os == "mac")
            {
                factory = new MacFactory();
            }
            else
            {
                throw new ArgumentException("Unsupported operating system.");
            }

            // Create and use application
            Application app = new Application(factory);
            app.Render();
        }
    }
}
```
#### Explanation
**Abstract Products (`IButton` and `ICheckbox`)**: These interfaces define the methods that all buttons and checkboxes must implement.

**Concrete Products (`WindowsButton`, `MacButton`, `WindowsCheckbox`, `MacCheckbox`)**: These classes provide specific implementations of buttons and checkboxes for Windows and Mac operating systems.

**Abstract Factory (`IGUIFactory`)**: This interface declares methods for creating abstract products (buttons and checkboxes).

**Concrete Factories (`WindowsFactory`, `MacFactory`)**: These factories create the concrete products (Windows-style or Mac-style buttons and checkboxes).

**Client (`Application`)**: The client class interacts with the factories through the abstract factory interface. It doesn't know the concrete classes it’s dealing with, making the client code independent of the product-specific logic.

#### How It Works
When the client (user) selects an operating system (`windows` or `mac`), the corresponding factory is instantiated.

The client calls the `Render()` method, which internally creates and paints the buttons and checkboxes for the selected operating system.

The Abstract Factory pattern ensures that all products (buttons and checkboxes) are compatible, meaning you won't mix, for example, a Windows button with a Mac checkbox.

If the user selects `windows`:
```
Rendering a button in Windows style.
Rendering a checkbox in Windows style.
```

If the user selects `mac`:
```
Rendering a button in Mac style.
Rendering a checkbox in Mac style.
```

### Benefits of Abstract Factory Pattern:
- **Encapsulation of Object Creation**: The factories encapsulate the creation of related objects, making it easy to extend with new product families (e.g., a Linux GUI).
- **Flexibility**: You can change the family of objects used throughout the codebase without changing the client code, making your system more flexible.

## 4. Prototype Pattern
Some would say that the Prototype Pattern is a 'redesign' of the revision of design-purpose use. It lets you instantiate clones of existing objects without having your production code tethered to subclassed objects, it’s like an object Xerox machine

### How Prototype Pattern Works
The Prototype Pattern does assist in avoiding wasteful and unproductive practice of reusing these resources. It is like having the ability to photocopy the objects

### Scenario: Cloning Different Types of Cars
In this example, we’ll create different types of vehicles (car, bike) and clone them using the Prototype pattern.

```csharp
using System;

namespace PrototypePattern
{
    // Prototype interface
    public abstract class Vehicle
    {
        public string Model { get; set; }
        public string Color { get; set; }

        // Abstract method to clone the object
        public abstract Vehicle Clone();

        public void DisplayInfo()
        {
            Console.WriteLine($"Vehicle: {this.GetType().Name}, Model: {Model}, Color: {Color}");
        }
    }

    // Concrete Prototype 1: Car
    public class Car : Vehicle
    {
        public int NumberOfDoors { get; set; }

        public Car(string model, string color, int numberOfDoors)
        {
            Model = model;
            Color = color;
            NumberOfDoors = numberOfDoors;
        }

        // Clone method to return a copy of the Car object
        public override Vehicle Clone()
        {
            Console.WriteLine("Cloning Car...");
            return (Vehicle)this.MemberwiseClone(); // Shallow copy
        }
    }

    // Concrete Prototype 2: Bike
    public class Bike : Vehicle
    {
        public bool HasCarrier { get; set; }

        public Bike(string model, string color, bool hasCarrier)
        {
            Model = model;
            Color = color;
            HasCarrier = hasCarrier;
        }

        // Clone method to return a copy of the Bike object
        public override Vehicle Clone()
        {
            Console.WriteLine("Cloning Bike...");
            return (Vehicle)this.MemberwiseClone(); // Shallow copy
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Original Car object
            Car originalCar = new Car("Sedan", "Red", 4);
            originalCar.DisplayInfo();

            // Clone the Car object
            Car clonedCar = (Car)originalCar.Clone();
            clonedCar.DisplayInfo();

            Console.WriteLine();

            // Original Bike object
            Bike originalBike = new Bike("Mountain Bike", "Blue", true);
            originalBike.DisplayInfo();

            // Clone the Bike object
            Bike clonedBike = (Bike)originalBike.Clone();
            clonedBike.DisplayInfo();
        }
    }
}
```

#### Explanation:
**Prototype Interface (`Vehicle`)**: The `Vehicle` abstract class defines a `Clone()` method that must be implemented by concrete prototypes. It also has common properties like `Model` and `Color`.

**Concrete Prototypes (`Car`, `Bike`)**: The `Car` and `Bike` classes inherit from `Vehicle` and implement the `Clone()` method, which uses the `MemberwiseClone()` method to create a shallow copy of the object.

**Shallow Copy**: In this case, `MemberwiseClone()` creates a shallow copy of the object, meaning it copies the object itself but not any complex objects it references. This is suitable here since all the properties are value types (e.g., `string`, `int`, `bool`).

#### Output
```
Vehicle: Car, Model: Sedan, Color: Red
Cloning Car...
Vehicle: Car, Model: Sedan, Color: Red

Vehicle: Bike, Model: Mountain Bike, Color: Blue
Cloning Bike...
Vehicle: Bike, Model: Mountain Bike, Color: Blue
```

#### Key Points
**Cloning**: The Prototype pattern allows creating a new object by copying an existing one. This can be more efficient than creating a new object from scratch, especially when object creation is costly.

**Shallow Copy**: In the example, we use `MemberwiseClone()` to perform a shallow copy. If the object has references to other objects, a deep copy might be required.

**Flexibility**: The client code (`Program` class) doesn't depend on concrete classes like `Car` or `Bike` to create new objects. It can clone any object that implements the `Clone()` method.

### Benefits of the Prototype Pattern:
- **Efficient Object Creation**: Useful when creating objects is resource-intensive.
- **Less Subclassing**: Reduces the need to create subclasses for object creation.
- **Dynamic Object Creation**: Objects can be created dynamically at runtime without hardcoding types.

## 5. Builder Pattern
The Builder Pattern helps in designing complex objects the same way. -------Your personal sandwich artist. Builder is the person who constructs and assembles the parts of complex objects, ändern is the solution that involves creating different flavors without mess managerial hands.

### Comparison with Factory Pattern
Although, the Factory Pattern may be likened to placing an order from a pre-defined set of options, using the Builder Pattern one can place an order and add his own toppings or special request

### Scenario: Building a Customizable Car
In this example, we'll create a Car object, which can be built in different configurations (e.g., Sports Car, SUV). The Builder pattern will be used to handle the construction of the car's features step by step.

```csharp
using System;

namespace BuilderPattern
{
    // Product: The complex object we are going to build
    public class Car
    {
        public string Engine { get; set; }
        public string Transmission { get; set; }
        public int Wheels { get; set; }
        public bool HasGPS { get; set; }
        public bool HasSunroof { get; set; }

        public void DisplaySpecifications()
        {
            Console.WriteLine($"Engine: {Engine}");
            Console.WriteLine($"Transmission: {Transmission}");
            Console.WriteLine($"Wheels: {Wheels}");
            Console.WriteLine($"GPS: {(HasGPS ? "Yes" : "No")}");
            Console.WriteLine($"Sunroof: {(HasSunroof ? "Yes" : "No")}");
        }
    }

    // Abstract Builder: Defines the steps to create a product
    public abstract class CarBuilder
    {
        protected Car car;

        public void CreateNewCar()
        {
            car = new Car();
        }

        public Car GetCar()
        {
            return car;
        }

        public abstract void SetEngine();
        public abstract void SetTransmission();
        public abstract void SetWheels();
        public abstract void SetGPS();
        public abstract void SetSunroof();
    }

    // Concrete Builder 1: Builds a sports car
    public class SportsCarBuilder : CarBuilder
    {
        public override void SetEngine()
        {
            car.Engine = "V8 Engine";
        }

        public override void SetTransmission()
        {
            car.Transmission = "Manual";
        }

        public override void SetWheels()
        {
            car.Wheels = 4;
        }

        public override void SetGPS()
        {
            car.HasGPS = true;
        }

        public override void SetSunroof()
        {
            car.HasSunroof = true;
        }
    }

    // Concrete Builder 2: Builds an SUV
    public class SUVBuilder : CarBuilder
    {
        public override void SetEngine()
        {
            car.Engine = "V6 Engine";
        }

        public override void SetTransmission()
        {
            car.Transmission = "Automatic";
        }

        public override void SetWheels()
        {
            car.Wheels = 4;
        }

        public override void SetGPS()
        {
            car.HasGPS = true;
        }

        public override void SetSunroof()
        {
            car.HasSunroof = false;
        }
    }

    // Director: Controls the building process
    public class CarDirector
    {
        private CarBuilder _builder;

        public CarDirector(CarBuilder builder)
        {
            _builder = builder;
        }

        // Construct the car by calling the builder's methods step by step
        public void ConstructCar()
        {
            _builder.CreateNewCar();
            _builder.SetEngine();
            _builder.SetTransmission();
            _builder.SetWheels();
            _builder.SetGPS();
            _builder.SetSunroof();
        }

        public Car GetCar()
        {
            return _builder.GetCar();
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Building a sports car
            CarBuilder sportsCarBuilder = new SportsCarBuilder();
            CarDirector sportsCarDirector = new CarDirector(sportsCarBuilder);

            sportsCarDirector.ConstructCar();
            Car sportsCar = sportsCarDirector.GetCar();
            Console.WriteLine("Sports Car Specifications:");
            sportsCar.DisplaySpecifications();

            Console.WriteLine();

            // Building an SUV
            CarBuilder suvBuilder = new SUVBuilder();
            CarDirector suvDirector = new CarDirector(suvBuilder);

            suvDirector.ConstructCar();
            Car suv = suvDirector.GetCar();
            Console.WriteLine("SUV Specifications:");
            suv.DisplaySpecifications();
        }
    }
}
```

#### Explanation
**Product (`Car`)**: This is the complex object being built. It has various attributes (e.g., engine, transmission, wheels, GPS, sunroof).

**Abstract Builder (`CarBuilder`)**: Defines the steps required to build a car (e.g., setting the engine, transmission, wheels, etc.). Each step is abstract, allowing different builders to implement them in their own way.

**Concrete Builders (`SportsCarBuilder`, `SUVBuilder`)**: Implement the steps to build a specific type of car. For example, a sports car might have a V8 engine and manual transmission, while an SUV has a V6 engine and automatic transmission.

**Director (`CarDirector`)**: Controls the building process. It calls the builder’s methods step by step to construct the car. The director ensures the car is built in a specific sequence.

**Client (`Program`)**: The client uses the director to build the car by providing a specific builder. Once the car is built, it is retrieved and displayed.

#### Output
```
Sports Car Specifications:
Engine: V8 Engine
Transmission: Manual
Wheels: 4
GPS: Yes
Sunroof: Yes

SUV Specifications:
Engine: V6 Engine
Transmission: Automatic
Wheels: 4
GPS: Yes
Sunroof: No
```

#### How It Works
The **Client** decides what kind of car to build by selecting a builder (e.g., `SportsCarBuilder` or `SUVBuilder`).

The **Director** orchestrates the building process, ensuring the steps (e.g., engine, transmission, etc.) are followed in a particular order.

The **Concrete Builder** defines how each step is performed (e.g., a sports car has a V8 engine, while an SUV has a V6 engine).

### Benefits of the Builder Pattern:
- **Encapsulation of Construction**: The construction process is encapsulated in the builder, keeping the product creation details hidden.
- **Step-by-Step Construction**: The director controls the process step by step, which is useful when building complex objects.
- **Reusability**: The same construction process can build different types of products by swapping out builders (e.g., you can add a `TruckBuilder` without modifying the director or the product).

