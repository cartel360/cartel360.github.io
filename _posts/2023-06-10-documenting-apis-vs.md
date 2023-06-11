---
layout: post
title: Effortless API Testing & Debugging with .http Files in Visual Studio
date: 2023-06-12 00:00:00 
description: Building RESTful APIs has become an essential part of web development, allowing developers to create powerful, scalable, and flexible applications that can be accessed by clients across a range of devices and platforms.
image: 
    path: /assets/img/Http-File.jpg 
tags: [Productivity, APIs, Tips] 
categories: [Software Development]
published: true
mermaid: true
---
Visual Studio, one of the most popular integrated development environments (IDEs), has introduced an exciting new feature that simplifies the process of testing APIs. With the addition of HTTP files support, developers can now conveniently create and execute HTTP requests directly within Visual Studio, streamlining the testing and debugging of APIs. This article explores this new feature and highlights its benefits for developers.


## Streamlining API Testing with HTTP Files:
There are a bunch of tools you can use to test your apis, postman is one of the most popular tools for testing apis. It is a great tool for testing apis. However, it can be a bit cumbersome to use. You have to create a new request every time you want to test an api. This can be a bit tedious. Visual Studio has introduced a new feature that makes it easier to test apis. You can now create http files in visual studio. These files contain all the information you need to test an api. You can then execute these files directly from visual studio. This makes it much easier to test apis. You don't have to create a new request every time you want to test an api. You can just execute the http file and it will send the request to the server. This is a great feature for developers who want to test apis quickly and easily.

## What are HTTP Files?
HTTP files are a new feature in Visual Studio that allows developers to create and execute HTTP requests directly within the IDE. These files contain all the information needed to send an HTTP request, including the URL, headers, and body. Developers can then execute these files to send the request to the server.

## Creating HTTP Files in Visual Studio
These files have a .http extension and contain HTTP requests and their associated responses

To create an HTTP file in Visual Studio, open the Solution Explorer and right-click on the project. Select Add > New Item, give the file a name and add the .http extension and click Add. The file will be created in the project's root directory.

![Structure]({{site.baseurl}}/assets/img/http-files/structure.jpg)

In the image above, i have chosen to create a folder named `Docs` and within that folder, I have created a file named `Todo.http`. This file will contain all the information needed to send an HTTP request to the server. I am have made some modifications to the default project and gpt rid of `WeatherForecast.cs` and `WeatherForecastController.cs` and added a new controller named `TodoItemController.cs` and a `TodoItem.cs` file. This controller will be used to handle all the requests sent to the server.

The content of the files are as follows:

TodoItem.cs
```csharp
namespace TestHttp
{
    public class TodoItem
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public bool IsCompleted { get; set; }
    }

}
```

TodoItemController.cs
```csharp
using Microsoft.AspNetCore.Mvc;

namespace TestHttp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TodoItemsController : ControllerBase
    {
        private static List<TodoItem> _todoItems = new List<TodoItem>();
        private static int _nextId = 1;

        // GET: api/TodoItems
        [HttpGet]
        public IEnumerable<TodoItem> Get()
        {
            return _todoItems;
        }

        // GET: api/TodoItems/{id}
        [HttpGet("{id}")]
        public ActionResult<TodoItem> Get(int id)
        {
            var todoItem = _todoItems.FirstOrDefault(item => item.Id == id);
            if (todoItem == null)
            {
                return NotFound();
            }
            return todoItem;
        }

        // POST: api/TodoItems
        [HttpPost]
        public ActionResult<TodoItem> Post(TodoItem todoItem)
        {
            todoItem.Id = _nextId++;
            _todoItems.Add(todoItem);

            return CreatedAtAction(nameof(Get), new { id = todoItem.Id }, todoItem);
        }

        // PUT: api/TodoItems/{id}
        [HttpPut("{id}")]
        public IActionResult Put(int id, TodoItem updatedTodoItem)
        {
            var existingTodoItem = _todoItems.FirstOrDefault(item => item.Id == id);
            if (existingTodoItem == null)
            {
                return NotFound();
            }

            existingTodoItem.Title = updatedTodoItem.Title;
            existingTodoItem.IsCompleted = updatedTodoItem.IsCompleted;

            return NoContent();
        }

        // DELETE: api/TodoItems/{id}
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var todoItem = _todoItems.FirstOrDefault(item => item.Id == id);
            if (todoItem == null)
            {
                return NotFound();
            }

            _todoItems.Remove(todoItem);

            return NoContent();
        }
    }

}
```

I have created a simple api that will be able to add, edit, view and delete todo items.

### Understanding the http file

In my `Todo.http` file, I have added the following code:

```
@rootUrl = https://localhost:7037/api

### Get all the TodoItems
GET {{rootUrl}}/TodoItems


### Create a new todo item
POST {{rootUrl}}/TodoItems
Content-Type: application/json

{
    "title": "Task Five",
    "isCompleted": true
}


### Get a single todo item 
GET {{rootUrl}}/TodoItems/1


### Update a todo item
PUT {{rootUrl}}/TodoItems/3
Content-Type: application/json

{
    "title": "Task Three Edited",
    "isCompleted": true
}


### Delete a todo item
DELETE {{rootUrl}}/TodoItems/4
```

In my example above, I have different http methods to interact with the api, notice after every method there is `###` this is used to separate the different methods. You can also choose to add descriptions after `###` to explain what the method does and you can also add more comments within the file by having `#` before the comment as shown below:
```
### Get all the TodoItems
# This is a comment
GET /TodoItems
```

The `@rootUrl` is used to store the base url of the api, this is used to avoid repeating the url in every method.

Visual studio will automatically detect the http file and will display a `Run` button at the top of the file. Clicking on the `Run` button will execute all the methods in the file, as shown below:

![Run]({{site.baseurl}}/assets/img/http-files/methods.jpg)

Clicking the `Run` button on each method will execute the method and display the response in the `Output` window. The response will be displayed in the `Output` window as shown in the highlighted section below:

![Output]({{site.baseurl}}/assets/img/http-files/output.jpg)



### Why Documentation is Essential for APIs?
API documentation is critical for developers to understand the functionality and behavior of an API. It offers a clear understanding of the API's purpose, parameters, and returns, reducing the chance of misinterpretation and promoting consistency. Documentation also helps in the API's maintenance and enables developers to troubleshoot issues. Furthermore, API documentation can serve as a reference for other developers who may require insight into your codebase, ensuring that your codebase is accessible to all.


>HTTP files offer a clear and straightforward way to document APIs. HTTP files can be used to document APIs for testing purposes and to create reference documentation. The files' format allows developers to write code in a simple format that can be easily understood. Moreover, Integration with Visual Studio makes the process of generating API documentation far more manageable for developers.
{: .prompt-tip }

The source code for this article can be found  <a href="https://github.com/cartel360/Test-Http-VS" target="_blank">here</a>.
