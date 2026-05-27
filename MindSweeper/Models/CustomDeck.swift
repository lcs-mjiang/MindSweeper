//
//  CustomDeck.swift
//  MindSweeper
//
//  Created by Michael on 2026/5/27.
//
import Foundation
import SwiftData

@Model
final class CustomDeck {
    var id: UUID
    var title: String
    
    @Relationship(deleteRule: .cascade, inverse: \CustomCard.deck)
    var cards: [CustomCard] = []
    
    init(title: String) {
        self.id = UUID()
        self.title = title
    }
}

@Model
final class CustomCard {
    var id: UUID
    var question: String
    var answer: String
    var hint: String?
    
    var deck: CustomDeck?
    
    init(question: String, answer: String, hint: String? = nil) {
        self.id = UUID()
        self.question = question
        self.answer = answer
        self.hint = hint
    }
}
