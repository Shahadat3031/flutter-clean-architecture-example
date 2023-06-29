# Flutter - Clean Architecture proposal

![app](./art/app.png?raw=true)


## Goals

- Keep code clean
- Keep code testable
- Keep code base easily extensible and adaptable
- Make it possible to explore and replace different state management solutions without impacting the project (Currently, the options are: BLoC, Cubit, GetIt, MobX, Provider, and Riverpod)

## Tip

Don't just apply the architecture blindly. Work wisely by using the appropriate levels of abstraction for each project. In the end, this architecture is just a collection of good ideas based on well-founded principles (like Separation of concerns). Seek to understand the problem that each architectural decision aims to solve, so you can determine when and how to apply it.

**THINK** first, then **ACT**.


## A short description about "Clean Architecture"

![architecture](./art/arch_1.png?raw=true)


There are two main points to understand about the architecture: it splits the project into different layers and conforms to the Dependency rule.

The number of layers used can vary slightly from one project to another, but by utilizing them, we promote the principle of 'separation of concerns.' If you're a new developer and have never heard of it before, it's simply a fancy way of saying, 'Hey! I'm a layer, and I'm concerned about one aspect of the system only'. If a layer is responsible for displaying the UI, it won't handle database operations. Conversely, if a layer is responsible for data persistence, it won't have any knowledge of UI components

And what about the Dependency rule? Let's put it in simple terms. First, you need to understand that the layers discussed above are not stacked on top of each other; instead, they resemble the layers of an 'onion.' There is a central layer surrounded by outer layers. The Dependency rule states that classes within a layer can only access classes from their own layer or the outer layers, but never from the inner layers

Usually, when working with this architecture, you'll come across some additional terminology such as Entities, Interface Adapters, Use Cases, DTOs, and other terms. These terms are simply names given to components that also fulfill 'single responsibilities' within the project:

- Entities: Represent the core business objects, often reflecting real-world entities. Examples include Character, Episode, or Location classes. These entities correspond to real-world concepts or objects, possessing **_properties_** specific to them and encapsulating behavior through their own **_methods_**. You'll be **_reading, writting, and transforming entities throughout the layers_**

- Interface Adapters: Also known as Adapters, they're responsible for bridging the gap between layers of the system, **_facilitating the conversion and mapping of data between layers_**. There are various approaches available, such as specialized mapper classes or inheritance. The point is, by using these adapters, each layer can work with data in a format that suits better for its needs. As data moves between layers, it is mapped to a format that is suitable for the next layer. Thus, any future changes can be addressed by modifying these adapters to accommodate the updated format without impacting the layer's internals

- Use Cases: Also known as Interactors, **_they contain the core business logic and coordinate the flow of data_**. For example, they handle user login/logout, data saving or retrieval, and other functionalities. Use Case classes are typically imported and used by classes in the presentation (UI) layer. They also utilize the inversion of control technique to be independent of the data retrieval or sending mechanism, while coordinating the flow of data

- Data Transfer Objects (DTOs): Are objects used for transferring data between different layers of the system. They serve as _**simple containers that carry data**_ without any behavior or business logic

I recommend checking out [this link](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html), provided by Robert C. Martin ('Uncle Bob'), which offers what today may be considered the 'official' explanation

### Known limitations

- The initial setup involves dealing with some boilerplate code
- There is a risk of over-engineering the solution

### Known benefits

- A/B testing can be easily applied
- Feature toggles can be effortlessly implemented
- All layers can be independently unit tested
- The unidirectional data flow facilitates code comprehension


## Clean Architecture and how it's applied in this project

The figure bellow represents the variation applied in this project:

![architecture](./art/arch_2.png?raw=true)

In this case, we're only using three layers: Presentation, Domain and Data. 


### The presentation layer (UI)

This is the layer where the Flutter framework resides. Here, you'll find classes that are part of the framework, such as Widgets, BuildContexts, and libraries that consume the framework, including state management libraries.

Typically, the classes in this layer are responsible for:

- Managing the application's state.
- Handling UI aspects of an app, such as managing page navigation, displaying data, implementing internationalization, and ensuring proper UI updates.


### The domain layer

This layer represents the core domain of the problem we are addressing, encompassing the business rules. Hence, it should be an independent Dart module without dependencies on external layers. It includes:

- Plain entity classes (like Character entity)
- Use-case classes that encapsulate the specific business logic for a given use case (like GetAllCharacters, SignInUser, and others...)
- Abstractions for data access, normally repository or services interfaces

A use-case has no knowledge of the data source, whether it comes from a memory cache, local storage, or the internet. All these implementation details have been abstracted out through the use of Repository Interfaces. From the use-case's perspective, all that matters is that it receives the required data.

### The data layer

This layer serves as a boundary between our application and the external world. Its primary responsibility is to load data from external sources, such as the internet or databases, and convert it to a format that aligns with our Domain expectations. It plays a vital role in supplying data to the use cases and performs the following tasks:

- Data retrieval: It makes network and/or database calls, retrieving data from the appropriate data sources.
- Repository implementations: It includes the implementations of the repositories defined in the domain layer, providing concrete functionality for accessing and manipulating data.
- Data coordination: It coordinates the flow of data between multiple sources. For example, it can fetch data from the network, store it locally, and then return it to the use case.
- Data (de)serialization: It handles the conversion of data to and from JSON format, transforming it into Data Transfer Objects (DTOs) for standardized representation.
- Caching management: It can incorporate caching mechanisms, optimizing performance by storing frequently accessed data for quicker retrieval.


### The DTOs, Entities and States

As mentioned previously, it is essential for each layer to handle data in a way that best suits its specific needs. This is achieved by utilizing classes with specialized characteristics that empower their usage within each layer. In this project, the Data layer employs Data Transfer Objects (DTOs), the Domain layer utilizes Entities, and the Presentation layer employs States.

DTOs are specifically designed for deserializing and serializing data when communicating with the network. Hence, it is logical for them to possess the necessary knowledge of JSON serialization. Entities, on the other hand, represent the core concepts of our domain and contain 'plain' data or methods relevant to their purpose. Lastly, in the Presentation layer, States are used to represent the way we display and interact with the data from Entities in the user interface.

The specific usage of these classes may vary from project to project. The names assigned to them can differ, and there can even be additional types of classes, such as those specifically designed for database mapping. However, the underlying principle remains consistent: By utilizing these classes alongside mappers, we can provide each layer with a suitable data format and the flexibility to adapt to future changes.

<!-- 
### Network
Layer responsible for handle the communication to the network. It has the implementation of the remote abstraction (``RemoteDatasourceInterface``) defined into the Data layer:
- We define the endpoints we are going to use
- We configure any interceptors we need
- We serialize/deserialize the JSON to Data objects

It represents a "boundary" with the external world. We are translating the "language" our API uses to communicate (JSON) to something that we can understand and work better (Data object).

### Local
This layer provides access to any kind of local storage: database, shared preferences, files, and others. It implements the abstractions (``LocalCacheDatasourceInterface``) defined into the Data layer.

It represents a "boundary" with the inner world. I mean, how we store things in our local device. We can use shared-preferences' key-values, serialize/deserialize things into files, read/write from the database, etc.

The point is: Each method has its way to "save" and "read" things, and this layer will translate this way to objects that our Data Layer knows how to handle. -->


<!-- # Generic Error Handling and Data Layer
The Data layer will encapsulate all kinds of try-catches, from this layer upwards there will be no special flow to handle errors. Repositories will return Either a Failure (in case of any error) or a Value in case of success (``Either<Failure, Value>``).

We will also use two generic classes to represent any kind of error that may occur on the Network layer and LocalCache layer - ``ServerFailure``, and ``CacheFailure`` respectively.

If any of these errors occur, Data Layer will also log the event properly. Example:
1. A use-case asks for all characters available
2. The repository verify that the Device is online, and it goes on and tries to fetch data from Network
3. Network layer tries to fetch data from remote API, but an unexpected problem occurs and we've got back an Error 500
4. The repository catches the error
5. The repository logs it on Analytics
6. The repository answers back to use case an ``Either<ServerFailure, null>`` object -->


# References
- [Joe Birch - Google GDE: Clean Architecture Course](https://caster.io/courses/android-clean-architecture)
- [Reso Coder - Flutter TDD Clean Architecture](https://www.youtube.com/playlist?list=PLB6lc7nQ1n4iYGE_khpXRdJkJEp9WOech)
- [Majid Hajian | Flutter Europe - Strategic Domain Driven Design to Flutter](https://youtu.be/lGv6KV5u75k)
- [Guide to app architecture - Jetpack Guides](https://developer.android.com/jetpack/docs/guide#common-principles)
- [ABHISHEK TYAGI - TopTal Developer: Better Android Apps Using MVVM with Clean Architecture](https://www.toptal.com/android/android-apps-mvvm-with-clean-architecture)
- [Jason Taylor (+20 years of experience) - Clean Architecture ](https://youtu.be/Zygw4UAxCdg)
- [Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)