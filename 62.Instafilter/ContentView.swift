//
//  ContentView.swift
//  62.Instafilter
//
//  Created by Валентин on 26.08.2025.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        ShareLink(item: URL(string: "https://www.hackingwithswift.com")!) {
            Label("Srpread the word about Swift", systemImage: "swift")
        }
    }
}

#Preview {
    ContentView()
}
