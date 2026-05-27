//
//  CustomDeckEditorView.swift
//  MindSweeper
//
//  Created by Michael on 2026/5/27.
//
import SwiftUI
import SwiftData

struct CustomDeckEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var deck: CustomDeck
    
    @State private var showingAddCard = false
    @State private var newQuestion = ""
    @State private var newAnswer = ""
    @State private var newHint = ""
    
    var body: some View {
        Form {
            Section("Deck Name") {
                TextField("Title", text: $deck.title)
            }
            
            Section("Cards") {
                ForEach(deck.cards) { card in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Q: \(card.question)").fontWeight(.semibold)
                        Text("A: \(card.answer)").foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteCards)
                
                Button(action: { showingAddCard = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Card")
                    }
                }
            }
        }
        .navigationTitle("Edit Deck")
        .sheet(isPresented: $showingAddCard) {
            NavigationStack {
                Form {
                    Section {
                        TextField("Question", text: $newQuestion)
                        TextField("Answer", text: $newAnswer)
                    }
                    Section("Hint (Optional)") {
                        TextField("Enter hint", text: $newHint)
                    }
                }
                .navigationTitle("New Card")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { resetForm() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let card = CustomCard(
                                question: newQuestion,
                                answer: newAnswer,
                                hint: newHint.isEmpty ? nil : newHint
                            )
                            deck.cards.append(card)
                            resetForm()
                        }
                        .disabled(newQuestion.trimmingCharacters(in: .whitespaces).isEmpty ||
                                  newAnswer.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
        }
    }
    
    private func deleteCards(offsets: IndexSet) {
        for index in offsets {
            let card = deck.cards[index]
            modelContext.delete(card)
        }
    }
    
    private func resetForm() {
        newQuestion = ""
        newAnswer = ""
        newHint = ""
        showingAddCard = false
    }
}
