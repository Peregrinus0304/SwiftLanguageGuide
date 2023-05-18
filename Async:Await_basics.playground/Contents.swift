import Foundation

// MARK: - 🧵 Async func 🧵

// 🧵 About - (await)
// It is a special kind of function or method that can be suspended while it’s partway through execution.

func listPhotos(inGallery name: String) async -> [String] {
    let result = "some asynchronous networking code ..."
    return [result]
}

// ❗️ you write async before throws

// When calling an asynchronous method, execution suspends until that method returns.

let photoNames = await listPhotos(inGallery: "Summer Vacation")
let sortedNames = photoNames.sorted()
let name = sortedNames[0]
print(name)
// While this code’s execution is suspended, some other concurrent code in the same program runs.
// ❗️ This is also called yielding the thread because, behind the scenes, Swift suspends the execution of your code on the current thread and runs some other code on that thread instead. ❗️

// 🧵 Asynchronous Sequences - (for-await-in loop)
// ❗️ A for-await-in loop potentially suspends execution at the beginning of each iteration, when it’s waiting for the next element to be available.

// ❗️ You can use your own types in a for-await-in loop by adding conformance to the AsyncSequence protocol.

let handle = FileHandle.standardInput
for try await line in handle.bytes.lines {
    print(line)
}

// 🧵 Calling Asynchronous Functions in Parallel - (async-let)

// If we have several async operations there are two approaches:

// Sequential approach
// Each photo downloads completely before the next one starts downloading.

let firstPhoto = await listPhotos(inGallery: "One")
let secondPhoto = await listPhotos(inGallery: "Two")
let thirdPhoto = await listPhotos(inGallery: "Three")

let fotos = [firstPhoto, secondPhoto, thirdPhoto]
print(fotos)

// Parallel execution
// Each photo can download independently, or even at the same time.
async let first = listPhotos(inGallery: "One")
async let second = listPhotos(inGallery: "Two")
async let third = listPhotos(inGallery: "Three")

let photos = await [first, second, third]
print(photos)

// All three calls start without waiting for the previous one to complete. If there are enough system resources available, they can run at the same time.
// ❗️ Call asynchronous functions with async-let when you don’t need the result until later in your code.


// MARK: - ☂️ Tasks and Task Groups ☂️

// ☂️ Structured concurrency
// Tasks are arranged in a hierarchy and each task in a task group has the same parent task, and each task can have child tasks.
// Task - a unit of work that can be run asynchronously as part of your program.

// ❗️ Although you take on some of the responsibility for correctness, the explicit parent-child relationships between tasks let Swift handle some behaviors like propagating cancellation for you, and lets Swift detect some errors at compile time.

await withTaskGroup(of: String.self) { taskGroup in
    let photoNames = await listPhotos(inGallery: "Summer Vacation")
    for name in photoNames {
        taskGroup.addTask { await listPhotos(inGallery: name)[0] }
    }
}

// ☂️ Unstructured concurrency
// An unstructured task doesn’t have a parent task.
// ❗️ You have complete flexibility to manage unstructured tasks in whatever way your program needs, but you’re also completely responsible for their correctness.
// To create an unstructured task:
// 👉🏼 Task.init(priority:operation:) - creates task that runs on the current actor.
// 👉🏼 Task.detached(priority:operation:) - creates an unstructured task that’s not part of the current actor (detached task).

let someHandle = Task {
    return await listPhotos(inGallery: "Spring Adventures")
}
let result = await someHandle.value

// MARK: - ⛑ Task Cancellation ⛑
// Each task checks whether it has been canceled at the appropriate points in its execution, and responds to cancellation in whatever way is appropriate (depending on the work you’re doing):

// 👉🏼 Throwing an error like CancellationError

// 👉🏼 Returning nil or an empty collection

// 👉🏼 Returning the partially completed work

// To check for cancellation:
// 👉🏼 call Task.checkCancellation() - throws CancellationError if the task has been canceled
// 👉🏼 check the value of Task.isCancelled

// To propagate cancellation manually, call Task.cancel().

// MARK: - 👔 Actors 👔

// Actors let you safely share information between concurrent code.
// ❗️ Are reference types.
// ❗️ Unlike classes, actors allow only one task to access their mutable state at a time, which makes it safe for code in multiple tasks to interact with the same instance of an actor.

// Example:
actor TemperatureLogger {
    let label: String
    var measurements: [Int]
    private(set) var max: Int

    init(label: String, measurement: Int) {
        self.label = label
        self.measurements = [measurement]
        self.max = measurement
    }
}

// Usage:
let logger = TemperatureLogger(label: "Outdoors", measurement: 25)
// Accessing logger.max without writing await fails because the properties of an actor are part of that actor’s isolated local state. Swift guarantees that only code inside an actor can access the actor’s local state. This guarantee is known as actor isolation:
print(logger.max) // compile-time Error

print(await logger.max) // Prints "25"

// ❗️ Because the actor allows only one task at a time to access its mutable state, if code from another task is already interacting with the logger, this code suspends while it waits to access the property.


// MARK: - 🩳 Sendable Types 🩳

// Inside of a task or an instance of an actor, the part of a program that contains mutable state, like variables and properties, is called a concurrency domain. Some kinds of data can’t be shared between concurrency domains, because that data contains mutable state.

// So, sendable type - a type that can be shared from one concurrency domain to another.

// You mark a type as being sendable by declaring conformance to the Sendable protocol.
// That protocol doesn’t have any code requirements, but it does have semantic requirements:

// 👉🏼 The type is a value type, all of it`s stored properties are sendable (an enumeration with associated values that are sendable).

