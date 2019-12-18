#  BBFication

Essentially a core data and Fetched results project feeding into SwiftUI to acheive  uni directional data flow.

The data layer is an extention of a core data library that wraps a bunch of JSON mapping protocols etc that allow for JSON serialisation to custom objects
that in turn get written into a SQLite (or whatever) iOS supplied persisted store.

Uses submodules for the testing frameworks (Quick/Nimble)

The parsing and persisting is tested out, networking and UI not really.

Filtering acheived via use of predicates against the backing store.

It's kind fo tempting to write an in memory cache using some sort of wrapper round NSCache but as I already wrote the CoreData stuff for another project  <shrugs>...

