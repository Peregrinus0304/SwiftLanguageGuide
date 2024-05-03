import SwiftUI
import Observation

// 👉🏼 Allows to create code during compilation (before building your code as usual)
// 👉🏼 Never delete or modify existing code

// ❗ There are 2 types of macros:

// MARK: - 🤖 Freestanding 🤖 (appear on their own, without being attached to a declaration)

func myFunction() {
    let macrosResult = #function
    print("Currently running \(macrosResult)")
    #warning("Something's wrong")
}



// MARK: - 👾 Attached 👾 (modify the declaration that they’re attached to)

// Instead of:
final class CounterViewModel: ObservableObject {
    @Published private(set) var count: Int = 0

    func increaseCount() {
        count += 1
    }
}

// Can do:
@Observable
final class ObservedCounterViewModel {
    private(set) var count: Int = 0

    func increaseCount() {
        count += 1
    }
}

// MARK: - 👽 Custom macros 👽

// 👽 We can declare a macro having one of these roles:

// 👉🏼 @freestanding(expression)
// Creates a piece of code that returns a value

// 👉🏼 @freestanding(declaration)
// Creates one or more declarations

// 👉🏼 @attached(peer)
// Adds new declarations alongside the declaration it’s applied to

// 👉🏼 @attached(accessor)
// Adds accessors to a property

// 👉🏼 @attached(memberAttribute)
// Adds attributes to the declarations in the type/extension it’s applied to

// 👉🏼 @attached(member)
// Adds new declarations inside the type/extension it’s applied to

// 👉🏼 @attached(conformance)
// Adds conformances to the type/extension it’s applied to



// Results:

myFunction()


// Sources

// https://avanderlee.com/swift/macros/
