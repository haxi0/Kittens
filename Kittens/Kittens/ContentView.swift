//
//  ContentView.swift
//  Kittens
//
//  Created by Анохин Юрий on 02.12.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            KittenView()
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("Random Pictures")
                }
            OptionsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Options")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
