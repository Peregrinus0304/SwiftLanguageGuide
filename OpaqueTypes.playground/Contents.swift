
// MARK: - 🧖🏽‍♀️ Opaque types (some) 🧖🏽‍♀️

// 🧖🏽‍♀️ About
// You can think of an opaque type like being the reverse of a generic type:
// 👉🏼 Generic types let the code that calls a function pick the type for that function’s parameters and return value in a way that’s abstracted away from the function implementation.
// 👉🏼 An opaque type lets the function implementation pick the type for the value it returns in a way that’s abstracted away from the code that calls the function.

// Or U can combine generics with opaque types, like:

protocol Shape { func make() }

struct ShapeOne: Shape {
    var shape: Shape?
    func make() {}
}

struct ShapeTwo: Shape {
    func make() {}
}

func getOpaqueShape<T: Shape>(_ shape: T) -> some Shape {
    return ShapeOne(shape: shape)
}

// MARK: - 🤴🏾 Opaque types and Protocols as types 🤴🏾

// 🤴🏾 About
// Returning an opaque type looks very similar to using a protocol type as the return type of a function, but these two kinds of return type differ in whether they preserve type identity.
// 👉🏼 An opaque type refers to one specific type, although the caller of the function isn’t able to see which type.
// 👉🏼 A protocol type can refer to any type that conforms to the protocol.

// Generally speaking, protocol types give you more flexibility about the underlying types of the values they store, and opaque types let you make stronger guarantees about those underlying types.

// 🤴🏾 Example

// Opaque type:

func getOpaqueShape(isOpaque: Bool) -> some Shape {
    if isOpaque {
        return ShapeTwo()
    } else {
        return ShapeOne()
    }
    // Error: the return statements in its body do not have matching underlying types
}

// opaque type’s underlying type must be fixed for the scope of the variable:
var someShape: some Shape = ShapeOne()
someShape = ShapeTwo()
// Error: Cannot assign value of type 'ShapeTwo' to type 'some Shape'

// ‼️ Aassigning a new instance of the same concrete type to the variable is also prohibited by the compiler.

// Protocol as type:

func getOpaqueShape(isOpaque: Bool) -> Shape {
    if isOpaque {
        return ShapeTwo()
    } else {
        return ShapeOne()
    }
}

let vehicles: [Shape] = [
    ShapeOne(),
    ShapeOne(),
    ShapeTwo(),
]

// MARK: - 🧚🏼‍♀️ Existential types (any) 🧚🏼‍♀️

// 🧚🏼‍♀️ About
// The any keyword was introduced in Swift 5.6. It is introduced for the purpose of creating an existential type. In Swift 5.6, the any keyword is not mandatory when creating an existential type, but in Swift 5.7, you will get a compile error if you failed to do so.

let myShape: Shape = ShapeOne() // 🔴 Compile error in Swift 5.7: Use of protocol 'Shape' as a type must be written 'any Shape'
let yourShape: any Shape = ShapeOne() // ✅ No compile error in Swift 5.7

// MARK: - 🀄️ AnyObject 🀄️

// 🀄️ About
// AnyObject is a protocol to which all classes implicitly conform.
// All classes, class types, or class-only protocols can use AnyObject as their concrete type. To demonstrate, you could create an array of different types:

class ClassOne {}
class ClassTwo {}

let classOne = ClassOne()
let classTwo = ClassTwo()

let arrayOfAnyObjects: [AnyObject] = [classOne, classTwo]
// You can put anything in one collection as long as all the objects are classes.

// 🀄️ AnyClass
// The standard library contains a type alias AnyClass representing AnyObject.Type:
print(AnyObject.self) // Prints: AnyObject
print(AnyClass.self) // Prints: AnyObject.Type


// MARK: - 🏁 Any 🏁

// 🏁 About
// Any can represent an instance of any type at all, including function types:

let arrayOfAny: [Any] = [
    0,
    "string",
    { (message: String) -> Void in print(message) }
]

// Sources:
// https://swiftsenpai.com/swift/understanding-some-and-any/
// https://www.avanderlee.com/swift/anyobject-any/

