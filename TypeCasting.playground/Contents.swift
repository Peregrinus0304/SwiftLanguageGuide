// MARK: - 🍔 Overview 🍔

// Type casting in Swift is implemented with the is and as operators. These two operators provide a simple and expressive way to check the type of a value or cast a value to a different type.

// We can also use type casting to check whether a type conforms to a protocol

//❕ Base class

class MediaItem {
  var name: String
  init(name: String) {
    self.name = name
  }
}

//❕ Subclasses

class Movie: MediaItem {
  var director: String
  init(name: String, director: String) {
    self.director = director
    super.init(name: name)
  }
}

class Song: MediaItem {
  var artist: String
  init(name: String, artist: String) {
    self.artist = artist
    super.init(name: name)
  }
}

let library = [
  Movie(name: "Casablanca", director: "Michael Curtiz"),
  Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
  Movie(name: "Citizen Kane", director: "Orson Welles"),
  Song(name: "The One And Only", artist: "Chesney Hawkes"),
  Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]
// ❗ the type of the array is inferred to be [MediaItem]

print(type(of: library)) // this is of type Array<MediaItem>
library.forEach { print(type(of: $0)) } // each element is casted to it's subclass type

// MARK: - 🥦 Checking type 🥦

// 🥦 "is" operator

let someMediaItem = library[.zero]

let isMovie = someMediaItem is Movie // False
let isSong = someMediaItem is Song // True

// 🥦 Downcasting ("as?/as!")

if let movie = someMediaItem as? Movie {
  print("Movie: \(movie.name), dir. \(movie.director)")
} else if let song = someMediaItem as? Song {
  print("Song: \(song.name), by \(song.artist)")
}

// MARK: - 🍄 Type Casting for Any and AnyObjectin page link 🍄


// Any can represent an instance of any type at all, including function types.
// AnyObject can represent an instance of any class type.

// Optional types is included into Any.
var things: [Any] = []

let optionalNumber: Int? = 3
things.append(optionalNumber)        // Warning
things.append(optionalNumber as Any) // No warning
