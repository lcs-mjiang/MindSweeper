//
//  CustomDeckListView.swift
//  MindSweeper
//
//  Created by Michael on 2026/5/27.
//

import SwiftUI
import SwiftData

struct CustomDeckListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var decks: [CustomDeck]
    
    @State private var showingNewDeckAlert = false
    @State private var newDeckTitle = ""
    
    var body: some View {
        List {
            ForEach(decks) { deck in
                NavigationLink(destination: CustomDeckEditorView(deck: deck)) {
                    VStack(alignment: .leading) {
                        Text(deck.title).font(.headline)
                        Text("\(deck.cards.count) cards").font(.caption).foregroundColor(.secondary)
                    }
                }
            }
            .onDelete(perform: deleteDecks)
        }
        .navigationTitle("My Decks")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingNewDeckAlert = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("New Deck", isPresented: $showingNewDeckAlert) {
            TextField("Deck Title", text: $newDeckTitle)
            Button("Cancel", role: .cancel) { newDeckTitle = "" }
            Button("Create") {
                let deck = CustomDeck(title: newDeckTitle)
                modelContext.insert(deck)
                newDeckTitle = ""
            }
        } message: {
            Text("Enter a name for your new flashcard deck.")
        }
    }
    
    private func deleteDecks(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(decks[index])
        }
    }
}
