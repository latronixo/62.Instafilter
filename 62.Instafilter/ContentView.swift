//
//  ContentView.swift
//  62.Instafilter
//
//  Created by Валентин on 26.08.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let example = Image(.example)
        ShareLink(item: example, preview: SharePreview("картинка из приложения BestRecipe", image: example)) {
            Label("click to share", systemImage: "airplane")
        }
    }
}

#Preview {
    ContentView()
}
