import Foundation

// MARK: - 🎃 Error handling 🎃

// 🎃 About
// In Swift, errors are represented by values of types that conform to the Error protocol, like:

enum PasswordError: Error {
    case short(count: Int), obvious
}

enum SomeUnknownedError: Error {}

func checkPassword(_ password: String) throws -> String {
    if password.count < 5 {
        throw PasswordError.short(count: password.count)
    }
    
    if password == "12345" {
        throw PasswordError.obvious
    }
    
    if password.count < 8 {
        return "OK"
    } else if password.count < 10 {
        return "Good"
    } else {
        return "Excellent"
    }
}



// ‼️‼️‼️ There are four ways to handle errors in Swift: ‼️‼️‼️

// 🎃 You can propagate the error further (to the code that calls that function):

func propagateErrorFurther() throws {
    try checkPassword("")
}

// 🎃 handle the error using a do-catch statement,

do {
    try checkPassword("")
} catch {
    print("Ah, the password is bad.")
}

// OR

// Match against several catch clauses to determine which one of them can handle the error:

do {
    try checkPassword("")
    
} catch is SomeUnknownedError {
    print("This is an error of type SomeUnknownedError")
}
catch PasswordError.obvious {
    print("Password is obvious")
}
catch PasswordError.short(count: let count) where count == 1 {
    print("Password is too short. It has only one sign")
}
catch PasswordError.short(count: let count) where count == 2 {
    print("Password is too short. It has only two signs")
}
catch PasswordError.short {
    print("Password is too short")
}
catch {
    // If no pattern is matched, the error gets caught by the final catch clause and is bound to a local error constant
    print("Default case - unknown error - \(error)")
}

// 🎃 Handle the error as an optional value.
// You use try? to handle an error by converting it to an optional value, like:
func validate() {
    guard let validationResult = try? checkPassword("") else { return }
    print(validationResult)
}


// 🎃 Disable error propagation.
// You can write try! before the expression to disable error propagation and wrap the call in a runtime assertion that no error will be thrown. If an error actually is thrown, you’ll get a runtime error.
let theOkPassword = try! checkPassword("123456")

// 🎃 Throwing initializers

struct Validator {
    let password: String
    init(password: String) throws {
        self.password = password
        try checkPassword(password)
    }
}

// MARK: - 👻 Result 👻

// 👻 About
// A Result type, introduced into the standard library in Swift 5, gives us a simpler, clearer way of handling errors in complex code such as asynchronous APIs.

// Swift’s Result type is implemented as an enum that has two cases: success and failure. Both are implemented using generics so they can have an associated value of your choosing, but failure must be something that conforms to Swift’s Error type. If you want, you can use your own custom error types.

// Think of Result as a super-powered Optional: it wraps a successful value, but can also wrap a second case that expresses the absence of a value. With Result, though, that absence conveys bonus data, because rather than just being nil it instead tells us what went wrong.

// 👻 Example
enum NetworkError: Error {
    case badURL
}

func fetchUnreadCount1(from urlString: String, completionHandler: @escaping (Result<Int, NetworkError>) -> Void)  {
    guard let url = URL(string: urlString) else {
        completionHandler(.failure(.badURL))
        return
    }

    // complicated networking code here
    print("Fetching \(url.absoluteString)...")
    completionHandler(.success(5))
}

fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
    switch result {
    case .success(let count):
        print("\(count) unread messages.")
    case .failure(let error):
        print(error.localizedDescription)
    }
}

// 👻 Benefits of using Result over "throwing" error handling

// ✅ The error is strongly typed.
// Swift’s regular throwing functions are unchecked and so can throw any type of error.

// ✅ It is clear that we get either successful data or an error – it is not possible to get both or neither of them.
// For example, the dataTask() method from URLSession uses the old Obj-C approach of completion handlers: it calls its completion handler with (Data?, URLResponse?, Error?). That might give us some data, a response, and an error, or any combination of the three – the Swift Evolution proposal calls this situation “awkwardly disparate”.

// ✅ It is significantly less complicated to read.

// ✅ Result has a get() method that either returns the successful value if it exists, or throws its error otherwise. This allows you to convert Result into a regular throwing call, like this:

fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
    if let count = try? result.get() {
        print("\(count) unread messages.")
    }
}

// OR

// Result has an initializer that accepts a throwing closure: if the closure returns a value successfully that gets used for the success case, otherwise the thrown error is placed into the failure case, like:

let validationResult = Result { try checkPassword("") }

// ✅ Transforming Result
// Result has four other methods that may prove useful: map(), flatMap(), mapError(), and flatMapError().

// 👉🏼 map() - looks inside the Result, and transforms the success value into a different kind of value using a closure you specify (However, if it finds failure instead, it just uses that directly and ignores your transformation).

// 👉🏼 flatMap() - flattenes the Result down (e.g. Result<Result<Int, FactorError>, FactorError> is flattened down into Result<Int, FactorError>).

// 👉🏼 mapError() AND flatMapError() - do similar things except they transform the error value rather than the success value.


// Sources:
// https://www.hackingwithswift.com/quick-start/beginners/how-to-handle-errors-in-functions
// https://www.hackingwithswift.com/articles/161/how-to-use-result-in-swift

