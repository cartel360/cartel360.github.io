---
layout: post
title: Behavioral Design Patterns
date: 2024-11-18 00:00:00 
description: Behavioral design patterns focus on the interaction between objects, defining how they communicate and collaborate. These patterns promote loose coupling and help manage complex flows of control and data.
image: 
    path: /assets/img/behavioral-pattern.jpg
tags: [Productivity, Software, Design-Pattern]
categories: [Software Development]
published: true 
---

Behavioral design patterns focus on the interaction between objects, defining how they communicate and collaborate. These patterns promote loose coupling and help manage complex flows of control and data. In this article, we will explore seven key behavioral design patterns: **Observer**, **Strategy**, **Command**, **Memento**, **Mediator**, **State**, and **Template Method**. 

This is a continuation of **Introduction to Design Patterns**, if you haven't checked it out you can check it [here](/posts/design-patterns/).


## 1. Observer Pattern
The Observer pattern establishes a one-to-many dependency between objects. When one object (the subject) changes its state, all dependent objects (observers) are notified and updated automatically. This pattern is particularly useful for implementing distributed event-handling systems.

### Implementation
- **Subject**: Maintains a list of observers and notifies them of state changes.
- **Observer**: Interface that defines the update method.
- **Concrete Subject**: Implements the subject interface and holds the state.
- **Concrete Observer**: Implements the observer interface and updates itself when notified.

### Use Case
This pattern is commonly used in scenarios where a state change in one object requires updates in multiple other objects, such as in GUI frameworks, event handling systems, or stock price updates.

### Code Example
```csharp
using System;
using System.Collections.Generic;

// Subject interface
public interface ISubject
{
    void Attach(IObserver observer);
    void Detach(IObserver observer);
    void Notify();
}

// Concrete Subject
public class Stock : ISubject
{
    private List<IObserver> observers = new List<IObserver>();
    private string _stockSymbol;
    private double _price;

    public Stock(string stockSymbol, double price)
    {
        _stockSymbol = stockSymbol;
        _price = price;
    }

    public double Price
    {
        get { return _price; }
        set 
        {
            _price = value;
            Notify();
        }
    }

    public void Attach(IObserver observer)
    {
        observers.Add(observer);
    }

    public void Detach(IObserver observer)
    {
        observers.Remove(observer);
    }

    public void Notify()
    {
        foreach (var observer in observers)
        {
            observer.Update(_stockSymbol, _price);
        }
    }
}

// Observer interface
public interface IObserver
{
    void Update(string stockSymbol, double price);
}

// Concrete Observer
public class StockInvestor : IObserver
{
    private string _name;

    public StockInvestor(string name)
    {
        _name = name;
    }

    public void Update(string stockSymbol, double price)
    {
        Console.WriteLine($"Investor {_name} notified: {stockSymbol} price changed to {price}");
    }
}

// Client Code
public class Program
{
    public static void Main(string[] args)
    {
        Stock stock = new Stock("AAPL", 120.0);
        StockInvestor investor1 = new StockInvestor("John");
        StockInvestor investor2 = new StockInvestor("Sarah");

        stock.Attach(investor1);
        stock.Attach(investor2);

        stock.Price = 125.0;
        stock.Price = 130.0;
    }
}
```

### Code Explanation
- The `Stock` class implements the `ISubject` interface and notifies its observers of price changes.
- The `StockInvestor` class implements the `IObserver` interface and receives updates when the stock price changes.

### Summary of the Flow
- The `ISubject` interface allows for attaching and detaching observers.
- The `Stock` class notifies all attached `IObserver` instances when its price changes.
- `StockInvestor` instances receive updates whenever the stock price changes.

### Output
```
Investor John notified: AAPL price changed to 125
Investor Sarah notified: AAPL price changed to 125
Investor John notified: AAPL price changed to 130
Investor Sarah notified: AAPL price changed to 130
```

### Benefits
- Promotes loose coupling between the subject and observers.
- Supports dynamic and flexible systems that can easily add or remove observers.
- Facilitates event-driven programming.

---

## 2. Strategy Pattern

The Strategy pattern defines a family of algorithms, encapsulating each one, and making them interchangeable. This pattern enables clients to choose the algorithm that best fits their needs at runtime.

### Implementation
- **Strategy Interface**: Defines a common interface for all supported algorithms.
- **Concrete Strategies**: Implement the strategy interface with specific algorithms.
- **Context**: Uses a Strategy instance to call the algorithm defined by the Strategy interface.

### Use Case
This pattern is often used in sorting, validation, or any scenario where multiple algorithms can achieve the same goal, allowing for easy switching and customization.

### Code Example
```csharp
using System;

// Strategy interface
public interface ICompressionStrategy
{
    void Compress(string fileName);
}

// Concrete Strategy A
public class ZipCompression : ICompressionStrategy
{
    public void Compress(string fileName)
    {
        Console.WriteLine($"Compressing {fileName} using Zip.");
    }
}

// Concrete Strategy B
public class RarCompression : ICompressionStrategy
{
    public void Compress(string fileName)
    {
        Console.WriteLine($"Compressing {fileName} using Rar.");
    }
}

// Context
public class FileCompressor
{
    private ICompressionStrategy _compressionStrategy;

    public FileCompressor(ICompressionStrategy compressionStrategy)
    {
        _compressionStrategy = compressionStrategy;
    }

    public void SetStrategy(ICompressionStrategy compressionStrategy)
    {
        _compressionStrategy = compressionStrategy;
    }

    public void CompressFile(string fileName)
    {
        _compressionStrategy.Compress(fileName);
    }
}

// Client Code
public class Program
{
    public static void Main(string[] args)
    {
        FileCompressor fileCompressor = new FileCompressor(new ZipCompression());
        fileCompressor.CompressFile("example.txt");

        fileCompressor.SetStrategy(new RarCompression());
        fileCompressor.CompressFile("example.txt");
    }
}
```

### Code Explanation
- The `FileCompressor` class uses an `ICompressionStrategy` to perform file compression.
- Strategies can be switched at runtime by calling `SetStrategy`.

### Summary of the Flow
- The `ICompressionStrategy` interface allows for different compression algorithms.
- The `FileCompressor` class delegates the compression task to the current strategy.
- The client can easily switch strategies as needed.

### Output
```
Compressing example.txt using Zip.
Compressing example.txt using Rar.
```

### Benefits
- Enables selecting algorithms at runtime, promoting flexibility.
- Encapsulates algorithms separately, adhering to the Single Responsibility Principle.
- Simplifies unit testing by allowing the use of mock strategies.

---

## 3. Command Pattern

The Command pattern encapsulates a request as an object, thereby allowing for parameterization of clients with queues, requests, and operations. This pattern promotes decoupling between sender and receiver.

### Implementation
- **Command Interface**: Declares an execution method.
- **Concrete Command**: Implements the command interface and defines the binding between a receiver and an action.
- **Invoker**: Holds commands and calls their execution methods.
- **Receiver**: Knows how to perform the operations associated with the command.

### Use Case
This pattern is useful in scenarios where you need to parameterize objects with operations, queue operations, or support undo functionality.

### Code Example
```csharp
using System;

// Command interface
public interface ICommand
{
    void Execute();
}

// Receiver
public class Light
{
    public void TurnOn()
    {
        Console.WriteLine("Light is ON");
    }

    public void TurnOff()
    {
        Console.WriteLine("Light is OFF");
    }
}

// Concrete Command for turning on the light
public class TurnOnCommand : ICommand
{
    private Light _light;

    public TurnOnCommand(Light light)
    {
        _light = light;
    }

    public void Execute()
    {
        _light.TurnOn();
    }
}

// Concrete Command for turning off the light
public class TurnOffCommand : ICommand
{
    private Light _light;

    public TurnOffCommand(Light light)
    {
        _light = light;
    }

    public void Execute()
    {
        _light.TurnOff();
    }
}

// Invoker
public class RemoteControl
{
    private ICommand _command;

    public void SetCommand(ICommand command)
    {
        _command = command;
    }

    public void PressButton()
    {
        _command.Execute();
    }
}

// Client Code
public class Program
{
    public static void Main(string[] args)
    {
        Light light = new Light();
        ICommand turnOn = new TurnOnCommand(light);
        ICommand turnOff = new TurnOffCommand(light);

        RemoteControl remote = new RemoteControl();

        remote.SetCommand(turnOn);
        remote.PressButton();

        remote.SetCommand(turnOff);
        remote.PressButton();
    }
}
```

### Code Explanation
- The `Light` class is the **Receiver** that performs actions.
- The `TurnOnCommand` and `TurnOffCommand` encapsulate commands.
- The `RemoteControl` class is the **Invoker** that calls the commands.

### Summary of the Flow
- The `ICommand` interface defines an `Execute` method for command execution.
- The `RemoteControl` sets a command and triggers its execution.
- Commands are decoupled from the invoker, promoting flexibility.

### Output
```
Light is ON
Light is OFF
```

### Benefits
- Decouples the sender from the receiver, allowing for easy command management.
- Enables queueing and logging of commands for undo functionality.
- Supports parameterization of clients with various requests.

---

## 4. Memento Pattern

The Memento pattern allows for capturing and externalizing an object's internal state without violating encapsulation, enabling the object to be restored to this state later.

### Implementation
- **Memento**: Stores the internal state of the originator.
- **Originator**: Creates a memento containing a snapshot of its current state.
- **Caretaker**: Maintains the memento, preventing direct access to its content.

### Use Case
This pattern is often used in applications requiring undo mechanisms, such as text editors or gaming applications

 where game states need to be saved and restored.

### Code Example
```csharp
using System;

public class Memento
{
    public string State { get; }

    public Memento(string state)
    {
        State = state;
    }
}

// Originator
public class TextEditor
{
    private string _text = string.Empty;

    public void Write(string text)
    {
        _text = text;
        Console.WriteLine($"Current text: {_text}");
    }

    public Memento Save()
    {
        return new Memento(_text);
    }

    public void Restore(Memento memento)
    {
        _text = memento.State;
        Console.WriteLine($"Restored text: {_text}");
    }
}

// Caretaker
public class Caretaker
{
    private Memento? _memento;

    public void Save(TextEditor editor)
    {
        _memento = editor.Save();
    }

    public void Restore(TextEditor editor)
    {
        if (editor == null) throw new ArgumentNullException(nameof(editor));
        if (_memento == null) throw new InvalidOperationException("No saved state to restore.");
        editor.Restore(_memento);
    }
}

// Client Code
public class Program
{
    public static void Main(string[] args)
    {
        TextEditor editor = new TextEditor();
        Caretaker caretaker = new Caretaker();

        editor.Write("Hello, World!");
        caretaker.Save(editor);

        editor.Write("Hello, Design Patterns!");
        caretaker.Restore(editor);
    }
}
```

### Code Explanation
- The `TextEditor` class acts as the **Originator** that holds the state.
- The `Memento` class captures the state.
- The `Caretaker` manages saving and restoring states.

### Summary of the Flow
- The `TextEditor` creates a `Memento` capturing its current state.
- The `Caretaker` saves the memento and can restore it later.
- State restoration allows the `TextEditor` to revert to previous content.

### Output
```
Current text: Hello, World!
Current text: Hello, Design Patterns!
Restored text: Hello, World!
```

### Benefits
- Encapsulates the state of an object, promoting encapsulation.
- Supports undo operations without exposing internal data structures.
- Simplifies state management in complex systems.

---

## 5. Mediator Pattern

The Mediator pattern defines an object that encapsulates how a set of objects interact. This pattern promotes loose coupling by preventing objects from referring to each other explicitly, allowing for more flexible communication.

### Implementation
- **Mediator**: Interface that defines communication methods.
- **Concrete Mediator**: Implements the mediator interface and coordinates communication between colleagues.
- **Colleagues**: Classes that communicate through the mediator.

### Use Case
This pattern is useful in systems where numerous objects interact in complex ways, such as chat applications or UI components in a window.

### Code Example
```csharp
using System;

// Mediator interface
public interface IMediator
{
    void Notify(object sender, string ev);
}

// Concrete Mediator
public class ChatMediator : IMediator
{
    private User? _user1;
    private User? _user2;

    public User User1
    {
        set { _user1 = value; }
    }

    public User User2
    {
        set { _user2 = value; }
    }

    public void Notify(object sender, string ev)
    {
        if (sender == _user1 && _user2 != null)
        {
            Console.WriteLine($"User1 sends: {ev}");
            _user2.Receive(ev);
        }
        else if (sender == _user2 && _user1 != null)
        {
            Console.WriteLine($"User2 sends: {ev}");
            _user1.Receive(ev);
        }
    }
}

// Colleague
public class User
{
    private IMediator _mediator;
    public string Name { get; }

    public User(string name, IMediator mediator)
    {
        Name = name ?? throw new ArgumentNullException(nameof(name));
        _mediator = mediator ?? throw new ArgumentNullException(nameof(mediator));
    }

    public void Send(string message)
    {
        _mediator.Notify(this, message);
    }

    public void Receive(string message)
    {
        Console.WriteLine($"{Name} received: {message}");
    }
}

// Client Code
public class Program
{
    public static void Main(string[] args)
    {
        ChatMediator mediator = new ChatMediator();

        User user1 = new User("Alice", mediator);
        User user2 = new User("Bob", mediator);

        mediator.User1 = user1;
        mediator.User2 = user2;

        user1.Send("Hello, Bob!");
        user2.Send("Hello, Alice!");
    }
}
```

### Code Explanation
- The `ChatMediator` class manages communication between `User` instances.
- The `User` class sends and receives messages through the mediator.

### Summary of the Flow
- `User` instances communicate via the `IMediator`.
- The `ChatMediator` orchestrates message passing between users.
- This promotes loose coupling and easier modifications.

### Output
```
User1 sends: Hello, Bob!
Bob received: Hello, Bob!
User2 sends: Hello, Alice!
Alice received: Hello, Alice!
```

### Benefits
- Reduces dependencies between objects, promoting flexibility.
- Simplifies communication logic and enhances maintainability.
- Centralizes control logic in one location.

---

## 6. State Pattern

The State pattern allows an object to alter its behavior when its internal state changes. This pattern encapsulates state-specific behavior and transitions, making state management cleaner and easier.

### Implementation
- **State Interface**: Defines the methods for various states.
- **Concrete States**: Implement the state interface and define specific behavior.
- **Context**: Maintains an instance of a concrete state and delegates state-specific behavior to that instance.

### Use Case
This pattern is commonly used in scenarios like UI controls that change behavior based on user interactions or game characters that exhibit different behaviors based on their current state.

### Code Example
```csharp
using System;

// State interface
public interface IState
{
    void Handle(Context context);
}

// Concrete State A
public class HappyState : IState
{
    public void Handle(Context context)
    {
        Console.WriteLine("In a happy state!");
        context.SetState(new SadState());
    }
}

// Concrete State B
public class SadState : IState
{
    public void Handle(Context context)
    {
        Console.WriteLine("In a sad state!");
        context.SetState(new HappyState());
    }
}

// Context
public class Context
{
    public required IState State { get; set; }

    public void SetState(IState state)
    {
        State = state ?? throw new ArgumentNullException(nameof(state));
    }

    public void Request()
    {
        State.Handle(this);
    }
}

// Client Code
public class Program
{
    public static void Main(string[] args)
    {
        Context context = new Context { State = new HappyState() };

        context.SetState(new HappyState());
        context.Request();

        context.Request();
    }
}
```

### Code Explanation
- The `Context` class holds a reference to the current state and delegates behavior to it.
- `HappyState` and `SadState` implement the state interface, providing specific behavior.

### Summary of the Flow
- The `Context` changes its behavior based on the current state.
- States can transition between each other, allowing for flexible behavior management.
- Each state defines specific actions for the context.

### Output
```
In a happy state!
In a sad state!
```

### Benefits
- Simplifies state management by encapsulating state-specific behavior.
- Reduces conditional logic in code, promoting cleaner implementations.
- Supports the addition of new states without modifying existing code.

---

## 7. Template Method Pattern

The Template Method pattern defines the skeleton of an algorithm in a method, deferring some steps to subclasses. This pattern promotes code reuse and consistency by allowing subclasses to redefine certain steps of an algorithm without changing its structure.

### Implementation
- **Abstract Class**: Defines the template method and the steps of the algorithm.
- **Concrete Classes**: Implement specific steps of the algorithm.

### Use Case
This pattern is useful in frameworks where specific steps of an algorithm can vary, such as data processing or rendering operations.

### Code Example
```csharp
using System;

// Abstract Class
public abstract class DataProcessor
{
    public void Process()
    {
        ReadData();
        ProcessData();
        WriteData();
    }

    protected abstract void ReadData();
    protected abstract void ProcessData();
    protected abstract void WriteData();
}

// Concrete Class for XML
public class XmlDataProcessor : DataProcessor
{
    protected override void ReadData()
    {
        Console.WriteLine("Reading XML data...");
    }

    protected override void ProcessData()
    {
        Console.WriteLine("Processing XML data...");
    }

    protected override void WriteData()
    {
        Console.WriteLine("Writing XML data...");
    }
}

// Concrete Class for JSON
public class JsonDataProcessor : DataProcessor
{
    protected override void ReadData()
    {
        Console.WriteLine("Reading JSON data...");
    }

    protected override void ProcessData()
    {
        Console.WriteLine("Processing JSON data...");
    }

    protected override void WriteData()
    {
        Console.WriteLine("Writing JSON data...");
    }
}

// Client Code
public class Program
{
    public static void Main(string[] args)
    {
        DataProcessor xmlProcessor = new XmlDataProcessor();
        xmlProcessor.Process();

        DataProcessor jsonProcessor = new JsonDataProcessor();
        jsonProcessor.Process();
    }
}
```

### Code Explanation
- The `DataProcessor` abstract class defines the template method `Process`, which outlines the algorithm steps.
- Concrete classes implement the specific steps for different data formats.

### Summary of the Flow
- The `DataProcessor` class controls the algorithm structure.
- Subclasses implement specific behaviors for reading, processing, and writing data.
- The template method ensures consistency across different implementations.

### Output
```
Reading XML data...
Processing XML data...
Writing XML data...
Reading JSON data...
Processing JSON data...
Writing JSON data...
```

### Benefits
- Promotes code reuse by encapsulating common algorithm structures.
- Allows customization of specific steps without altering the overall algorithm.
- Enhances maintainability by providing a clear structure.

---

## Conclusion
Behavioral design patterns play a crucial role in defining how objects communicate and collaborate in a system. By implementing these patterns, developers can create flexible, maintainable, and extensible code. Understanding and applying these patterns can lead to more robust software design, enabling easier updates and modifications as requirements evolve. Whether managing state, handling commands, or coordinating interactions, behavioral patterns provide the tools necessary for effective object-oriented design.


>You can get the source code of the examples used on the github <a target="_blank" href="https://github.com/cartel360/Behavioral-Design-Patterns">here</a>
{:.prompt-tip}
