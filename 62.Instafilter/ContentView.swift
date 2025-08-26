//
//  ContentView.swift
//  62.Instafilter
//
//  Created by Валентин on 26.08.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ContentUnavailableView{
            Label("No snippets", systemImage: "swift")
        } description: {
            Text("You don't have any saved snippets yet")
        } actions: {
            Button("Create snippet") {
                //create a snippet
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentView()
}
