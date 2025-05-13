---
layout: post
title: Building a Modern GraphQL API with .NET 9
categories: [Software Development]
image: /assets/img/dotnet-graphql.jpg
tags: [.NET, GraphQL, API]
description: In today's API-driven world, GraphQL has emerged as a powerful alternative to REST, offering clients exactly the data they need in a single request. When combined with .NET 9's performance improvements and Hot Chocolate's rich feature set, developers can create incredibly efficient and flexible APIs. This article will guide you through building a simple product catalog API with real-time capabilities. 
---

In today's API-driven world, GraphQL has emerged as a powerful alternative to REST, offering clients exactly the data they need in a single request. When combined with .NET 9's performance improvements and Hot Chocolate's rich feature set, developers can create incredibly efficient and flexible APIs. This article will guide you through building a simple product catalog API with real-time capabilities. 

This is a continuation of <a href="/_posts/2025-04-28-understanding-graphql-in-net.md"> Understanding GraphQL in .NET </a>

## Why GraphQL in .NET 9?

Before diving into implementation, let's understand why this combination works so well:

1. **Precise Data Fetching**: Clients request only what they need
2. **Strong Typing**: Compile-time validation of queries
3. **Real-time Updates**: Built-in subscription support
4. **Performance**: .NET 9's optimized runtime with Hot Chocolate's efficient execution

## Setting Up the Foundation

Every robust GraphQL API starts with proper project configuration. Here's how to initialize your .NET 9 project with all necessary components:

```csharp
// Program.cs
var builder = WebApplication.CreateBuilder(args);

// Configure GraphQL server with essential features
builder.Services
    .AddGraphQLServer()
    .AddQueryType<Query>()
    .AddMutationType<Mutation>()
    .AddSubscriptionType<Subscription>()
    .AddInMemorySubscriptions()
    .AddFiltering()
    .AddSorting();
```

This configuration gives us:
- Query support for data fetching
- Mutation capabilities for data modification
- Real-time subscriptions via WebSockets
- Client-controlled filtering and sorting

## Designing the Domain Model

Our product catalog needs a well-structured domain model. Let's create entities with proper relationships:

```csharp
// Models/Product.cs
public class Product
{
    public int Id { get; set; }
    
    [Required, StringLength(100)]
    public string Name { get; set; } = string.Empty;
    
    public string? Description { get; set; }
    
    [Range(0.01, 10000)]
    public decimal Price { get; set; }
    
    public int CategoryId { get; set; }
    public Category? Category { get; set; }
}


public class Category
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public List<Product> Products { get; set; } = new();
}
```

Notice how we:
- Added data annotations for validation
- Established a many-to-one relationship between products and categories
- Used proper nullability annotations

## Implementing Core GraphQL Operations

### Powerful Query Implementation

The query type serves as the entry point for all data fetching operations. Here's how to implement it with advanced features:

```csharp
// GraphQL/Query.cs
public class Query
{
    [UsePaging]
    [UseProjection]
    [UseFiltering]
    [UseSorting]
    public IQueryable<Product> GetProducts([Service] AppDbContext context)
    {
        return context.Products.Include(p => p.Category);
    }
    
    public async Task<Product?> GetProductById(
        [ID] int id,
        ProductBatchDataLoader dataLoader)
    {
        return await dataLoader.LoadAsync(id);
    }
}
```

Key aspects to note:
- `UsePaging` enables cursor-based pagination
- The DataLoader pattern prevents N+1 query issues
- Entity Framework's `Include` ensures efficient loading of related data

### Robust Mutations for Data Modification

Mutations handle all create, update, and delete operations. Here's a comprehensive implementation:

```csharp
//GraphQL/Mutation.cs
public class Mutation
{
    public async Task<Product> AddProduct(
        AddProductInput input,
        [Service] AppDbContext context,
        [Service] ITopicEventSender eventSender)
    {
        var product = new Product
        {
            Name = input.Name,
            Price = input.Price,
            Description = input.Description,
            CategoryId = input.CategoryId
        };
        
        context.Products.Add(product);
        await context.SaveChangesAsync();
        
        await eventSender.SendAsync(nameof(Subscription.ProductAdded), product);
        
        return product;
    }
}
```

This mutation:
- Accepts an input type for better validation
- Publishes events for real-time subscribers
- Returns the complete created entity

## Real-time Capabilities with Subscriptions

GraphQL subscriptions push data to clients when events occur. Here's how to implement them:

```csharp
// GraphQL/Subscription.cs
public class Subscription
{
    [Subscribe]
    [Topic]
    public Product ProductAdded([EventMessage] Product product) => product;
    
    [Subscribe]
    [Topic("productUpdated_{id}")]
    public Product ProductUpdated(
        [ID] int id,
        [EventMessage] Product product) => product;
}
```

Clients can subscribe to:
- New product additions
- Updates to specific products
- Deletion events (implementation similar to updates)

## Solving Common Performance Issues

### The N+1 Problem and DataLoaders

One of GraphQL's potential pitfalls is the N+1 query problem. Here's how to solve it:

```csharp
// GraphQL/DataLoaders/ProductBatchDataLoader.cs
public class ProductBatchDataLoader : BatchDataLoader<int, Product>
{
    private readonly AppDbContext _dbContext;
    
    public ProductBatchDataLoader(
        AppDbContext dbContext,
        IBatchScheduler scheduler)
        : base(scheduler)
    {
        _dbContext = dbContext;
    }
    
    protected override async Task<IReadOnlyDictionary<int, Product>> LoadBatchAsync(
        IReadOnlyList<int> keys, CancellationToken ct)
    {
        return await _dbContext.Products
            .Where(p => keys.Contains(p.Id))
            .ToDictionaryAsync(p => p.Id, ct);
    }
}
```

This DataLoader:
- Batches multiple requests into single database calls
- Works automatically with Hot Chocolate's resolver pipeline
- Dramatically improves performance for nested queries

## Error Handling and Validation

Proper error handling is crucial for production APIs. Here's a comprehensive approach:

```csharp
public class CustomErrorFilter : IErrorFilter
{
    public IError OnError(IError error)
    {
        // Handle database errors
        if (error.Exception is DbUpdateException dbEx)
        {
            return error.WithMessage("Database operation failed")
                       .RemoveException();
        }
        
        // Hide internal details in production
        if (!Debugger.IsAttached)
        {
            return error.RemoveException()
                       .RemoveLocations()
                       .RemovePath();
        }
        
        return error;
    }
}
```

This filter:
- Protects sensitive information in production
- Provides friendly error messages
- Maintains detailed errors during development

## Testing Your GraphQL API

Comprehensive testing ensures reliability. Here's an example integration test:

```csharp
[Fact]
public async Task AddProduct_ReturnsValidResponse()
{
    var request = new
    {
        query = @"mutation ($input: AddProductInput!) {
            addProduct(input: $input) {
                id
                name
                price
            }
        }",
        variables = new
        {
            input = new { name = "Test", price = 9.99, categoryId = 1 }
        }
    };
    
    var response = await _client.PostAsJsonAsync("/graphql", request);
    var result = await response.Content.ReadFromJsonAsync<JsonElement>();
    
    Assert.True(result.GetProperty("data").GetProperty("addProduct").GetProperty("id").GetInt32() > 0);
}
```

This test verifies:
- Successful mutation execution
- Proper response structure
- Data persistence


### Using GraphQL Playground
Navigate to /graphql in your browser to access the playground. Try these queries:

#### Query:
```graphql
query {
  products(where: { price: { gt: 100 } }) {
    nodes {
      id
      name
      price
      category {
        id
        name
      }
    }
    pageInfo {
      hasNextPage
    }
  }
}
```

Running this query will return products with a price greater than 100, along with pagination information. So for the first time, no data will be returned.

#### Mutation:
```graphql
mutation CreateProduct {
  addProduct(input: {
    name: "Premium Wireless Headphones",
    price: 199.99,
    description: "Noise-cancelling Bluetooth headphones with 30hr battery life",
    categoryId: 1
  }) {
    id
    name
    price
    description
    category {
      id
      name
    }
  }
}
```
This mutation will add a new product to the database and return its details.

#### Subscription:
```graphql
subscription {
  productAdded {
    id
    name
    price
  }
}
```
This subscription will notify clients in real-time whenever a new product is added.


### Health Checks

Add monitoring endpoints for production:

```csharp
app.MapHealthChecks("/health");
app.MapGet("/", () => "GraphQL API ready at /graphql");
```

## Conclusion

We've built a complete GraphQL API with .NET 9 that includes:

1. **Efficient data fetching** with pagination and filtering
2. **Reliable mutations** with proper validation
3. **Real-time updates** through subscriptions
4. **Production-ready features** like error handling and health checks

The full implementation is available on [GitHub](https://github.com/cartel360/graphql-dotnet9-demo), including additional features like:


This architecture provides an excellent foundation for any .NET GraphQL API, combining the flexibility of GraphQL with the robustness of .NET 9. Whether you're building a simple internal API or a complex public-facing service, these patterns will serve you well.
