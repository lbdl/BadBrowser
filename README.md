#  BBFication

Essentially a core data and Fetched results project feeding into SwiftUI to acheive  uni-directional data flow.

Would be simpler to use someting like https://github.com/JohnEstropia/CoreStore but anyway part of a process of using code tests to mess with writing things from scratch, may as well make it count for something.

The data layer is an extention of a core data stack that wraps a bunch of JSON mapping protocols, mainly started as a process in experiments into Protocol based code bases and moving to TDD and testing in general in such.

Uses submodules for the testing frameworks (Quick/Nimble)

The parsing and persisting is tested out, networking and UI not really.

It's kind fo tempting to write an in memory cache using some sort of wrapper round NSCache but as I already wrote the CoreData stuff for another project  as In mentioned <shrug>...

The `DataManager` class should be made generic over type as essentially its going to be the same for all objects

The `Managed` interface and implementer has not been updated to the (slightly) shorter and newer syntax of CoreData since iOS10

Datatypes get handled by creeating a `TypeRaw` struct that handles the JSON decoding and then this is persisted to a backing store.

The mapping of JSON data to objects is handled in a Types given Mapper i.e. `<TYPE>` has another file `<TYPEMAPPER>` that is reponsible for... mapping acheieved using the DECODABLE protocol and a class that then handles feeding the data into the backing store.

In terms of filter functionality it is assumed that the user wishes to filter the result set based on Breaking Bad series not  on Better Call Saul series.

Should update the parsing and persisting to use batch updates `NSBatchInsertRequest` if possible but cant because of the models relationships
