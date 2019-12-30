//
//  ContentView.swift
//  BBFication
//
//  Created by Tim Storey on 14/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var viewModel: CharacterViewModel

    var body: some View {
        NavigationView {
            List {
                Picker(selection: $viewModel.seasonFilter, label: Text("Select Season")) {
                        ForEach(0..<viewModel.availableSeasons.count) {
                            Text("\(self.viewModel.availableSeasons[$0])")
                        }
                    }
            }.navigationBarTitle("Chose a season (0 is all)")
        }
    }
}

//struct CharacterView: View {
//    @EnvironmentObject var viewModel: CharacterViewModel
//
//    var body: some View {
//
//    }
//}

//struct ContentView_Previews: PreviewProvider {
//
//    static var previews: some View {
////        let scene = UIApplication.shared.connectedScenes.first
////        let sd = scene!.delegate as! SceneDelegate
////        let vm = CharacterViewModel(ctx: sd.dataManager!.persistenceManager.context)
//        MainContentView().environmentObject(ViewModelMock())
//    }
//}
