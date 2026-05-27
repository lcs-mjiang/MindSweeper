import SwiftUI

struct SubjectPickerView: View {

    var gameState: GameState

    var body: some View {
        VStack(spacing: 24) {
            header
            subjectGrid
        }
        .padding()
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 56))
                .foregroundStyle(.tint)
            Text("MindSweeper")
                .font(.largeTitle)
                .bold()
            Text("Pick a subject to begin")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 16)
    }

    private var subjectGrid: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                NavigationLink(destination: BoardView(subject: .math, gameState: gameState)) {
                    SubjectCard(label: "Math", icon: "function", color: .blue)
                }
                NavigationLink(destination: BoardView(subject: .history, gameState: gameState)) {
                    SubjectCard(label: "History", icon: "building.columns", color: .orange)
                }
            }
            HStack(spacing: 16) {
                NavigationLink(destination: BoardView(subject: .science, gameState: gameState)) {
                    SubjectCard(label: "Science", icon: "atom", color: .green)
                }
                NavigationLink(destination: BoardView(subject: .vocabulary, gameState: gameState)) {
                    SubjectCard(label: "Vocabulary", icon: "text.book.closed", color: .purple)
                }
            }
        }
    }
}

// MARK: - Subject Card

private struct SubjectCard: View {

    // MARK: - Stored properties

    let label: String
    let icon: String
    let color: Color

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundStyle(.white)
            Text(label)
                .font(.headline)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(color.gradient)
                .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    NavigationStack {
        SubjectPickerView(gameState: GameState())
    }
}
