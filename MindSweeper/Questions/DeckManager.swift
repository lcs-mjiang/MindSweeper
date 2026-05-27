import Foundation

struct DeckManager {
    private(set) var cards: [Card] = []

    // MARK: - Loading

    /// Load a preset deck by subject and shuffle the cards.
    mutating func loadPreset(_ subject: Subject) {
        switch subject {
        case .math:        cards = DeckManager.mathCards
        case .history:     cards = DeckManager.historyCards
        case .science:     cards = DeckManager.scienceCards
        case .vocabulary:  cards = DeckManager.vocabCards
        }
        cards.shuffle()
    }
    mutating func loadCustomDeck(_ customDeck: CustomDeck) {
            self.cards = customDeck.cards.map { customCard in
                Card(question: customCard.question, answer: customCard.answer, hint: customCard.hint)
            }
            self.cards.shuffle()
        }

    enum Subject: String, CaseIterable {
        case math, history, science, vocabulary
    }

    // MARK: - Drawing

    /// Draw a random card and remove it from the pool. Returns nil when empty.
    mutating func drawCard() -> Card? {
        guard !cards.isEmpty else { return nil }
        let index = Int.random(in: 0..<cards.count)
        return cards.remove(at: index)
    }

    // MARK: - Answer Checking

    /// Normalise a raw answer string — trim, lowercase, collapse whitespace.
    func normalizeAnswer(_ raw: String) -> String {
        raw.trimmingCharacters(in: .whitespaces)
           .lowercased()
           .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    }

    /// Return true if the player's answer matches the card's answer.
    func checkAnswer(card: Card, playerAnswer: String) -> Bool {
        normalizeAnswer(playerAnswer) == normalizeAnswer(card.answer)
    }
}
