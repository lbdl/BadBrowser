//
//  CharacterListViewModel.swift
//  BBFication
//
//  Created by Tim Storey on 29/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation

protocol SeasonFilter {
    func filterBySeason(filter: Int)
}

final class CharacterViewModel: ListViewModel<Character> {
    let availableSeasons:[Int] = [0,1,2,3,4,5]
    //let dataManager: DataControllerPrototcol
}

extension CharacterViewModel: SeasonFilter {
    func filterBySeason(filter: Int) {
//        guard case let f = filter > 0 else {return}
//        let filteredObjects = self.fetchedObjects.filter({
//            return $0.appearsIn(series: f)
//        })
//        self._objects = filteredObjects
    }
}
