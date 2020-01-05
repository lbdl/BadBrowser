#  BBFication general notes

* Essentially a core data and Fetched results project feeding into SwiftUI to acheive  uni-directional data flow.

* Would be simpler to use something like https://github.com/JohnEstropia/CoreStore but anyway part of a process of using code tests to mess with writing things from scratch, may as well make it count for something.

* The data layer is an extention of a core data stack that wraps a bunch of JSON mapping protocols, mainly started as initial experiments into Protocol based code bases and how to use Generics and DI with said.

* Uses submodules for the testing frameworks (Quick/Nimble) __DONT FORGET__ to `git submodule init`

* Was initially (the CoreData stack stuff) done fully TDD, this is more loose but it all remains testable.

* The parsing and persisting is tested out, networking and UI not really.

* It's kind of tempting to write an in memory cache using some sort of wrapper round NSCache but as I already wrote the CoreData stuff for another project... <shrug>

* The `Managed` interface and implementer has not been updated to the (slightly) shorter and newer syntax of CoreData since iOS10

* Datatypes get handled by creeating a `TypeRaw` struct that handles the JSON decoding and then this is persisted to a backing store.

* The mapping of JSON data to objects is handled in a given TYPES Mapper i.e. `<TYPE>` has another file `<TYPEMAPPER>` that is reponsible for mapping using the DECODABLE protocol  that then handles feeding the data into the backing store.

* In terms of filter functionality it is assumed that the user wishes to filter the result set based on Breaking Bad series not  on Better Call Saul series.

* Should update the parsing and persisting to use batch updates `NSBatchInsertRequest` if possible but can't because of the models relationships

* Data is passed into the initial VC as a model which is then filtered as needed further down the SwiftUI stack

* This is more of an update to some older CoreData code and a simple SwiftUI project

* I would add more tests around networking and UI

* There are in fact a whole buch of tests around the network in an older project available here https://github.com/lbdl/airtasker

* The `NSFetchedResultsController` does not for some reason actualy cause the update of the UI as expected, I suspect I have messed up the publiser and TBH I could just use the @FetchedResult wrapper.

* The networking stack is not handed down the VC stack, this is fugly and needs a rework.

* The networking stack should be refactored to use `Combine` anyway so it's left as is.

* Layout? Least said the better !
