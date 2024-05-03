// MARK: - 🗼 Overview 🗼

// Access to memory happens every time we read or write some value:

// write
var one = 1

// read
print("We're number \(one)!")

//❕ A conflicting access to memory can occur when different parts of our code are trying to access the same location in memory at the same time.

//❕ E.g. problems can occur when variable is being modified and read at the same time.
//❕ The proccess of modifying value can be devided into 3 stages: 1. Before (the old value), 2. In the middle (the value can be corrupted as it is in the proccess of modification), 3. After (correct modified value).

// In case of conflicting access within a single thread we’ll get an error at either compile time or runtime. In case we use multithreaded code - we will get no error, just corrupted or incorrect value.

// ❗ Characteristics of Memory Access:

// 👉 whether the access is a read or a write
// 👉 duration of the access (either instantaneous or long-term)
// 👉 location in memory being accessed

// ❗ Conditions of conflict in Memory Access (all 3 should be met):

// 👉🏻 At least one is a write access or a nonatomic access
// In Swift the nonatomic is the default (and only) choice, so it is not required, unlike Objective-C where atomic is the default. A write access changes the location in memory.

// 👉🏻 They access the same location in memory

// 👉🏻 Their durations overlap
// An access is instantaneous if it’s not possible for other code to run after that access starts but before it ends. By their nature, two instantaneous accesses can’t happen at the same time. Most memory access is instantaneous.
// Overlapping accesses appear primarily in code that uses in-out parameters in functions and methods or mutating methods of a structure.

// 💥 ONE 💥 E.g. we can’t access the original variable that was passed as in-out — any access to the original creates a conflict:

var stepSize = 1

func increment(_ number: inout Int) {
    number += stepSize // if the lfs and the rhs values refer to the same adress in memory - it is overlaping access.
}

increment(&stepSize)
// Error: conflicting accesses to stepSize

// To avoid the error we can make a copy of the original variable.

// 💥 TWO 💥 E.g. we can’t we can't pass one variable as the argument for multiple in-out parameters of the same function:

func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}
var playerOneScore = 42
var playerTwoScore = 30
balance(&playerOneScore, &playerTwoScore)  // OK
balance(&playerOneScore, &playerOneScore)
// Error: conflicting accesses to playerOneScore

/*
 ❗ The restriction against overlapping access to properties of a structure isn’t always necessary to preserve memory safety. Memory safety is the desired guarantee, but exclusive access is a stricter requirement than memory safety — which means some code preserves memory safety, even though it violates exclusive access to memory. Swift allows this memory-safe code if the compiler can prove that the nonexclusive access to memory is still safe. Specifically, it can prove that overlapping access to properties of a structure is safe if the following conditions apply:
 
 👉🏻 You’re accessing only stored properties of an instance, not computed properties or class properties.
 👉🏻 The structure is the value of a local variable, not a global variable.
 👉🏻 The structure is either not captured by any closures, or it’s captured only by nonescaping closures.
 
 If the compiler can’t prove the access is safe, it doesn’t allow the access. ❗
 */

