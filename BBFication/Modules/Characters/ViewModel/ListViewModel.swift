//
//  ListViewModel.swift
//  BBFication
//
//  Created by Timothy Storey on 28/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI
import Combine

/// we could use a @FetchedResult in the model but we are using a fetchedresultscontroller because
/// I havent experimented enough with doing the same with a @FetchedResult
class ListViewModel<R: Managed>: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    
    private let controller: NSFetchedResultsController<R>
    var passthroughSubject: PassthroughSubject<[R], Never>

    internal var _objects: [R]!

    init(_ ctx: ManagedContextProtocol) {
        let request = R.sortedFetchRequest
        self.controller = NSFetchedResultsController<R>(fetchRequest: request, managedObjectContext: ctx as! NSManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.passthroughSubject = PassthroughSubject<[R], Never>()
        super.init()
        controller.delegate = self
        try? controller.performFetch()
    }
    
     var fetchedObjects: [R] {
        guard let obj = _objects else {
            _objects = self.controller.fetchedObjects ?? []
            return _objects
        }
        return obj
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    // when we receive an update from the controller we
    // pass through using the Publisher
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        _objects = self.controller.fetchedObjects ?? []
        passthroughSubject.send(_objects!)
    }

}

