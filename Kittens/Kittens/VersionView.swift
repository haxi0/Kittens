//
//  VersionView.swift
//  Kittens
//
//  Created by Анохин Юрий on 03.12.2022.
//

import SwiftUI

struct VersionView: View {
    
    var body: some View {
        ZStack {
            Image("Kittens")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        Text("Kittens")
            .bold() // Make the text outstand. :O
        Text("Version \(UIApplication.appVersion!)")
            .opacity(0.3)
    }
}

struct VersionView_Previews: PreviewProvider {
    static var previews: some View {
        VersionView()
    }
}
