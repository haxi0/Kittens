//
//  OptionsView.swift
//  Kittens
//
//  Created by Анохин Юрий on 03.12.2022.
//

import SwiftUI

struct OptionsView: View {
    @Environment(\.openURL) var openURL // I feel like using openURL more. ¯\_(ツ)_/¯
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Other projects used")) {
                    Button("SDWebImageSwiftUI Project") {
                        openURL(URL(string: "https://github.com/SDWebImage/SDWebImageSwiftUI")!)
                    }
                    Button("SDWebImageSwiftUI MIT License") {
                        openURL(URL(string: "https://github.com/SDWebImage/SDWebImageSwiftUI/blob/master/LICENSE")!)
                    }
                    Button("Cataas API") {
                        openURL(URL(string: "https://cataas.com/")!)
                    }
                }
                NavigationLink(destination: VersionView(), label: {
                    Text("About")
                })
            }
            .navigationTitle("Options")
        }
        .navigationViewStyle(.stack)
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
