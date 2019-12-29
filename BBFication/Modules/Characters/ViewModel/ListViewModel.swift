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


class ListViewModel<R: Managed>: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    
    private let controller: NSFetchedResultsController<R>

    internal var _objects: [R]?

    init(ctx: ManagedContextProtocol) {
        let request = R.sortedFetchRequest
        self.controller = NSFetchedResultsController<R>(fetchRequest: request, managedObjectContext: ctx as! NSManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        controller.delegate = self
        try? controller.performFetch()
    }
    
     var fetchedObjects: [R] {
        guard let obj = _objects else {
            _objects = self.controller.fetchedObjects ?? []
            return _objects!
        }
        return obj
    }

    // MARK: NSFetchedResultsControllerDelegate
    // when we receive an update from the controller we
    // pass through using the Publisher
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        _objects = self.controller.fetchedObjects ?? []
        objectWillChange.send()
    }
    
    // MARK: ObservableObject
    var objectWillChange = ObservableObjectPublisher()
    
}

