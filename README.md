#  BBFication

Essentially a core data and Fetched results project feeding into SwiftUI to acheive  uni-directional data flow.

The data layer is an extention of a core data library that wraps a bunch of JSON mapping protocols.

Uses submodules for the testing frameworks (Quick/Nimble)

The parsing and persisting is tested out, networking and UI not really.

Filtering acheived via use of predicates against the backing store.

It's kind fo tempting to write an in memory cache using some sort of wrapper round NSCache but as I already wrote the CoreData stuff for another project  <shrugs>...

The `DataManager` class should be made generic over type as essentially its going to be the same for all objects

Datatypes get handled by creeating a `TypeRaw` struct that handles the JSON decoding and then this is persisted to a backing store.

The mapping of JSON data to objects is handled in a Types given Mapper i.e. `<TYPE>` has another file `<TYPEMAPPER>` that is reponsible for... mapping acheieved using the DECODABLE protocol and a class that then handles feeding the data into the backing store.
