//
//  ContentView.swift
//  62.Instafilter
//
//  Created by Валентин on 26.08.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var image: Image?
     
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }
    private func loadImage() {
        image = Image(.example)
    }
}

#Preview {
    ContentView()
}
