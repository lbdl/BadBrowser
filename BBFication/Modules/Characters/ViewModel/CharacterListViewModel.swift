//
//  CharacterListViewModel.swift
//  BBFication
//
//  Created by Tim Storey on 29/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import Foundation

protocol SeasonFilter {
    func filterBySeason()
}

final class CharacterViewModel: ListViewModel<Character> {
    var seasonFilter: Int?
    let availableSeasons:[Int] = [0,1,2,3,4,5]
    //let dataManager: DataControllerPrototcol
}

extension CharacterViewModel: SeasonFilter {
    func filterBySeason() {
        guard let f = seasonFilter, f > 0 else {return}
        let filteredObjects = self.fetchedObjects.filter({
            return $0.appearsIn(series: f)
        })
        self._objects = filteredObjects
    }
}
