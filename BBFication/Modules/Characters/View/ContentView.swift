//
//  ContentView.swift
//  BBFication
//
//  Created by Tim Storey on 14/12/2019.
//  Copyright © 2019 Tim Storey. All rights reserved.
//

import SwiftUI
import URLImage

struct MainContentView: View {
    
    @EnvironmentObject var viewModel: CharacterViewModel
    @State var season = 0

    var body: some View {
        NavigationView {
            List {
                Text("Select A Season (0 selects all !)").bold()
                Picker(selection: $season, label: Text("Select Season")) {
                        ForEach(0..<viewModel.availableSeasons.count) {
                            Text("\(self.viewModel.availableSeasons[$0])")
                        }
                }.pickerStyle(SegmentedPickerStyle())
                ForEach(viewModel.filterBySeason(filter: $season.wrappedValue), id: \.cId) { character in
                    NavigationLink(destination: CharacterDetailView(model: character)) {
                        CharacterView(model: character)
                    }
                }
                Spacer()
                }.navigationBarTitle("Characters")
        }
    }
}


struct CharacterView: View {
    var model: Character
    var body: some View {
        HStack {
            URLImage(URL(string: model.img_url)!, incremental: true) { proxy in
                proxy.image
                .resizable()
                    .aspectRatio(contentMode: .fill)
                .clipShape(Circle.init())
                    .padding(.all, 5.0)
                    .shadow(radius: 10.0)
            }
            .frame(width: 70.0, height: 70.0)
            Text("\(model.name)")
        }
    }
}


struct CharacterDetailView: View {
    var model: Character
    var body: some View {
        VStack{
            URLImage(URL(string: model.img_url)!, incremental: true) { proxy in
                proxy.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle.init())
                    .padding(.all, 20.0)
                    .shadow(radius: 10.0)
            }
            .frame(width: 150.0, height: 150.0)
            VStack{
                Text("\(model.name)")
                Text("\(model.nickname)")
            }
            OccupationView(model: Array(model.occupations))
            Text("\(model.status)")
            AppearanceDetailView(model: Array(model.appearances), showName: "Breaking Bad")
            AppearanceDetailView(model: Array(model.appearances), showName: "Better Call Saul")
        }
    }
}

struct OccupationView: View {
    var model: [Occupation]
    var body: some View {
        VStack {
            HStack {
                ForEach (model, id:\.name) { occupation in
                    Text("\(occupation.name)")
                }
            }
        }
    }
}


/// We use a filter and a sort on the data here
/// this might be more appropriate in the model itself
/// as there may be some performance hit on BIG arrays according
/// to some SO posts. This supposition remains untested by myself.
struct AppearanceDetailView: View {
    var model: [Appearance]
    var showName: String
    var body: some View {
        VStack {
            Text("Appears in \(showName), seasons:")
        HStack {
            ForEach(model.filter({return $0.episode.season.show.name == showName }).sorted{$0.episode.season.name < $1.episode.season.name}, id: \.name) { app in
                Text("\(app.episode.season.name)")
            }
        }
        }
    }
}
