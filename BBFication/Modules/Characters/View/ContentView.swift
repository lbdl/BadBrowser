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
    @State var season = 0

    var body: some View {
        NavigationView {
            List {
                Picker(selection: $season, label: Text("Select Season")) {
                        ForEach(0..<viewModel.availableSeasons.count) {
                            Text("\(self.viewModel.availableSeasons[$0])")
                        }
                }.pickerStyle(SegmentedPickerStyle())
                ForEach(viewModel.filterBySeason(filter: $season.wrappedValue), id: \.cId) {
                    Text("\($0.name)")
                }
                }.navigationBarTitle("Season Filter (0 is all)")
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
//    static var previews: some View {
//        MainContentView().environmentObject(CharacterViewModel(@Environment(\.managedObjectContext)))
//    }
//}
