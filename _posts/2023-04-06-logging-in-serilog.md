---
layout: post
title: Logging with Serilog in .NET
date: 2023-04-17 00:00:00 
description: Serilog is a popular logging framework for .NET applications that provides powerful yet flexible logging capabilities. It allows developers to easily log events and errors within their applications, making it easier to debug and troubleshoot issues. Unlike traditional logging frameworks.
image:
    path: /assets/img/logging-serilog.png # 
tags: [Productivity, Serilog, .NET] # add tag
categories: [Software Development]
published: true
---

Logging is an essential part of application development, as it allows developers to track and understand what is happening within their code. Serilog is a popular logging framework for .NET applications that provides a highly configurable and easy-to-use logging solution. In this article, we will explore the basics of logging in .NET with Serilog. We will discuss how to set up Serilog in a .NET application, configure logging levels, write structured logs, use sinks to send logs to external sources, and implement best practices for effective logging. Additionally, we will address common troubleshooting issues when working with Serilog in .NET applications.

## Introduction to Serilog

Serilog is a popular logging framework for .NET applications that provides powerful yet flexible logging capabilities. It allows developers to easily log events and errors within their applications, making it easier to debug and troubleshoot issues. Unlike traditional logging frameworks, Serilog focuses on structured logging, which means that logs are recorded in a structured format that can be easily queried and analyzed.

### What is Serilog?

Serilog is a logging library that simplifies logging in .NET applications. It provides a simple and easy-to-use API for logging events and errors, and supports a wide variety of logging sinks. Serilog also integrates seamlessly with popular logging and monitoring tools, such as Seq and Elasticsearch.

Why use Serilog instead of other logging frameworks?

There are several reasons why developers choose to use Serilog over other logging frameworks. First, Serilog's structured logging approach makes it easier to search and analyze logs, enabling developers to quickly identify and fix issues. Second, Serilog provides a wide variety of sinks, which makes it easy to send logs to different destinations, such as a file, console, or database. Finally, Serilog is highly extensible and can be easily customized to meet the needs of any application.

## Setting up Serilog in a .NET application

### Installation and configuration

Setting up Serilog in a .NET application is a straightforward process. Developers can use NuGet to install the Serilog package, and then configure it using a variety of approaches, such as JSON or code-based configuration.

### Using Serilog with ASP.NET Core applications

Serilog works seamlessly with ASP.NET Core applications. Developers can simply add the Serilog package to their project, configure it using the built-in configuration system, and then use it to log events and errors within their application.

## Understanding logging levels and configuring Serilog accordingly

### Log levels and their meaning

Serilog provides several logging levels, each with a specific meaning. These include Debug, Information, Warning, Error, and Fatal. Debug is the lowest level, and is used for debugging purposes. Information is used to record information about the application's operation. Warning is used to log potential issues, while Error is used to log errors that prevent the application from functioning correctly. Finally, Fatal is used to log critical errors that cause the application to crash.

### Setting minimum log levels

Developers can configure Serilog to record logs at a minimum level, which means that only events and errors that meet or exceed this level are logged. This can help to reduce the amount of logging and focus on only the most important events and errors.

### Filtering logs

Serilog provides a powerful filtering system that enables developers to filter logs based on various criteria, such as log level, source, or message. This can help developers to quickly identify and troubleshoot issues within their applications.

### **Writing structured logs with Serilog**

**What are structured logs?**

Structured logs are logs that are recorded in a structured format, such as JSON or XML. This makes it easier to search and analyze logs, as the data is organized in a way that can be easily queried.

**Creating structured logs with Serilog**

Serilog provides a simple API for creating structured logs. Developers can use the built-in logger to record events and errors, and then configure the logging output to be in a structured format. This makes it easy to analyze logs and troubleshoot issues within the application.Using sinks to send logs to external sources with Serilog

When it comes to logging in .NET applications, Serilog is a powerful and flexible tool that provides developers with fine-grained control over logs. One of the key features of Serilog is the ability to use sinks to send logs to external sources.

**What are sinks?**

In Serilog, a sink is a destination where log events are written. Some examples of sinks include:

- The console sink, which writes log events to the console
- The file sink, which writes log events to a file
- The Seq sink, which sends log events to a centralized logger for analysis

**Using built-in sinks**

Serilog comes with a number of built-in sinks that you can use out of the box. For example, to use the console sink, you can simply add the following line to your Serilog configuration:

```csharp
Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();
```

Similarly, to use the file sink, you can add the following line:

```csharp
Log.Logger = new LoggerConfiguration()
    .WriteTo.File("log.txt", rollingInterval: RollingInterval.Day)
    .CreateLogger();
```

**Creating custom sinks**

In addition to the built-in sinks, Serilog supports creating custom sinks to send logs to other external sources. This can be done by creating a class that inherits from the `Serilog.Sinks.PeriodicBatching.PeriodicBatchingSink` class and implementing the `EmitBatchAsync` method.

For example, you could create a custom sink to send logs to a messaging system like RabbitMQ:

```csharp
public class RabbitMqSink : PeriodicBatchingSink
{
    private readonly ILogEventFormatter _formatter;
    private readonly RabbitMQ.Client.IModel _channel;
    private readonly string _routingKey;

    public RabbitMqSink(
        ILogEventFormatter formatter,
        RabbitMQ.Client.IModel channel,
        string routingKey,
        TimeSpan period) : base(1000, period)
    {
        _formatter = formatter;
        _channel = channel;
        _routingKey = routingKey;
    }

    protected override async Task EmitBatchAsync(IEnumerable events)
    {
        foreach (var logEvent in events)
        {
            var message = _formatter.Format(logEvent);
            var body = Encoding.UTF8.GetBytes(message);
            _channel.BasicPublish(exchange: "",
                                  routingKey: _routingKey,
                                  basicProperties: null,
                                  body: body);
        }

        await Task.CompletedTask;
    }
}
```

Then, you can use your custom sink in your Serilog configuration:

```csharp
var factory = new ConnectionFactory() { HostName = "localhost" };
using (var connection = factory.CreateConnection())
using (var channel = connection.CreateModel())
{
    Log.Logger = new LoggerConfiguration()
        .WriteTo.Sink(new RabbitMqSink(new MessageTemplateTextFormatter("{Timestamp:yyyy-MM-dd HH:mm:ss} [{Level}] {Message}{NewLine}{Exception}"), channel, "logs", TimeSpan.FromSeconds(2)))
        .CreateLogger();

    ...
}
```

## Demo Example
To use serilog, we will start by creating a demo project, we can do that by creating a new console project in Visual Studio 2022 and install the serilog package, you can install through the package manager or running the commands below in your terminal:
```bash
$ dotnet add package Serilog
$ dotnet add package Serilog.Sinks.Console
$ dotnet add package Serilog.Sinks.File
```

The above commands will install serilog and console and file sinks to enable us write the logs to a console and files respectively.

We will then proceed and update `program.cs` as below:
```csharp
using Serilog;

Log.Logger = new LoggerConfiguration()
               .MinimumLevel.Debug()
               .WriteTo.Console()
               .WriteTo.File("logs/demo.txt", rollingInterval: RollingInterval.Day)
               .CreateLogger();

Log.Information("Hello, world!");

int a = 10, b = 0;
try
{
    Log.Debug("Dividing {A} by {B}", a, b);
    Console.WriteLine(a / b);
}
catch (Exception ex)
{
    Log.Error(ex, "Something went wrong");
}
finally
{
    Log.CloseAndFlush();
}
```

After executing the program we will get something like below in our terminal
![output](/assets/img/serilog/output-1.png)

We can see it has logged `Hello, World` with the `INFO` level and `Something went wrong` with the `ERROR` level.

We will note that we will have the same output in our `logs.txt` file




## Best practices for logging in .NET with Serilog

Logging is an essential part of software development and can be an invaluable tool for understanding how your application is behaving in production. Here are some best practices for logging in .NET with Serilog:

### Limiting sensitive information in logs

When logging information, it's important to avoid logging sensitive information like passwords, credit card numbers, or personally identifiable information. Ideally, you should only log information that is necessary for troubleshooting and debugging.

One way to limit sensitive information in logs is to use structured logging with Serilog. With structured logging, you can log variables and parameters directly instead of concatenating them with the log message. This makes it easier to filter out sensitive information.

### Using contextual logging

Contextual logging is a technique where you attach additional context to a log event to provide more insight into what's happening in your application. This can include things like user IDs, request IDs, or correlation IDs.

Serilog supports contextual logging with the `LogContext.PushProperty` method. For example, you could push a user ID onto the log context for a particular request:

```csharp
[HttpGet("{id}")]
public async Task> GetUser(int id)
{
    var userId = User.Claims.First(c => c.Type == "sub").Value;
    LogContext.PushProperty("userId", userId);

    ...
}
```

Then, in your Serilog log events, you can include the `userId` property to provide additional context:

```
[2023-04-08 14:23:00] [Information] User with ID 123 requested user data for user 456 (userId: abc123)
```

### Regular log reviews

Finally, it's important to regularly review your logs to identify issues or opportunities for improvement. By analyzing your logs, you can identify patterns of errors or performance issues and take proactive steps to address them.

### Troubleshooting common Serilog issues in .NET applications

Despite its power and flexibility, Serilog can sometimes be tricky to set up and configure correctly in .NET applications. Here are some common issues you might run into and how to troubleshoot them:

### Debugging Serilog configuration issues

If you're having trouble getting Serilog to write any logs at all, a good place to start is by adding the `Debug` sink to your configuration:

```csharp
Log.Logger = new LoggerConfiguration()
    .WriteTo.Debug()
    .CreateLogger();
```

This will write all log events to the `System.Diagnostics.Debug` output.

### Common pitfalls and how to avoid them

One common pitfall when using Serilog is forgetting to dispose the `ILogger` instance when your application shuts down. This can lead to logs not being written correctly, or even to memory leaks.

To avoid this issue, make sure to call the `Dispose` method on your logger instance when your application shuts down:

```csharp
Log.CloseAndFlush();
```

In summary, Serilog is a powerful logging framework that offers a wide range of features to help developers log effectively in .NET applications. By following the best practices discussed in this article, you can ensure that your logs provide valuable insights into your application's behavior and help you identify and fix issues quickly. Whether you are new to Serilog or an experienced user, this article should provide you with the knowledge and skills to log effectively in your .NET applications.

