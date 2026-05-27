import SwiftUI
import Combine

struct BoardView: View {

    // MARK: - Stored properties
    
    let subject: DeckManager.Subject
    var gameState: GameState

    @State private var deck = DeckManager()
    @State private var currentCard: Card?
    @State private var isShowingQuestion = false
    @State private var playerAnswer = ""
    @State private var timeString = "00:00"
    @Environment(\.dismiss) private var dismiss

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 9)

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            // MARK: - HUD
            HStack {
                Text("❤️ \(gameState.lives)")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("Score: \(gameState.score)")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()

                if gameState.status == .lost {
                    Text("💥 LOST")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                } else if gameState.status == .won {
                    Text("🏆 WON")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                } else {
                    Text("⏱ \(timeString)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer()

            // MARK: - Grid
            let totalCells = gameState.board.rows * gameState.board.cols

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(0..<totalCells, id: \.self) { index in
                    let row = index / gameState.board.cols
                    let col = index % gameState.board.cols
                    let cell = gameState.board.cells[row][col]

                    CellTile(cell: cell)
                        .onTapGesture {
                            handleTap(row: row, col: col)
                        }
                        .onLongPressGesture {
                            gameState.toggleFlag(row: row, col: col)
                        }
                }
            }
            .padding(.horizontal, 12)

            Spacer()
        }
        .onAppear {
            deck.loadPreset(subject)
        }
        .navigationTitle(subject.rawValue.capitalized)
        .onReceive(timer) { _ in
            if gameState.status == .playing {
                let seconds = gameState.elapsedSeconds
                timeString = String(format: "%02d:%02d", seconds / 60, seconds % 60)
            }
        }
        .sheet(isPresented: $isShowingQuestion) {
            if let card = currentCard {
                QuestionOverlay(
                    card: card,
                    playerAnswer: $playerAnswer,
                    onSubmit: { answer in
                        isShowingQuestion = false
                        if deck.checkAnswer(card: card, playerAnswer: answer) {
                            gameState.applyCorrectAnswer()
                        } else {
                            gameState.applyWrongAnswer()
                        }
                    }
                )
            }
        }
        .fullScreenCover(
            isPresented: Binding(
                get: { gameState.status == .won || gameState.status == .lost },
                set: { _ in }
            ),
            onDismiss: {
                gameState.reset()
                dismiss()
            }
        ) {
            GameOverView(gameState: gameState)
        }
    }

    // MARK: - Tap Handling

    private func handleTap(row: Int, col: Int) {
        let cell = gameState.board.cells[row][col]
        guard !cell.isRevealed, !cell.isFlagged else { return }

        gameState.cellTapped(row: row, col: col)

        guard gameState.status != .lost else { return }

        if deck.cards.isEmpty {
            deck.loadPreset(subject)
        }

        if let card = deck.drawCard() {
            currentCard = card
            playerAnswer = ""
            isShowingQuestion = true
        }
    }
}

// MARK: - Cell Subview

struct CellTile: View {
    let cell: Cell

    var body: some View {
        ZStack {
            Rectangle()
                .fill(cell.isRevealed
                      ? (cell.isMine ? Color.red.opacity(0.4) : Color(UIColor.systemGray5))
                      : Color.gray.opacity(0.6))
                .aspectRatio(1.0, contentMode: .fill)
                .cornerRadius(4)

            if cell.isRevealed {
                if cell.isMine {
                    Text("💣")
                        .font(.title2)
                } else if cell.neighborCount > 0 {
                    Text("\(cell.neighborCount)")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(numberColor(cell.neighborCount))
                }
            } else if cell.isFlagged {
                Image(systemName: "flag.fill")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    private func numberColor(_ count: Int) -> Color {
        switch count {
        case 1: return .blue
        case 2: return .green
        case 3: return .red
        case 4: return .purple
        case 5: return .orange
        case 6: return .cyan
        case 7: return .black
        default: return .gray
        }
    }
}

#Preview {
    NavigationStack {
        BoardView(subject: .math, gameState: GameState())
    }
}

