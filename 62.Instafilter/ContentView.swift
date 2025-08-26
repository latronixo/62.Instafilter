//
//  ContentView.swift
//  62.Instafilter
//
//  Created by Валентин on 26.08.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ContentUnavailableView("No snippets", systemImage: "swift", description: Text("You don't have any saved snippets yet"))
    }
}

#Preview {
    ContentView()
}
