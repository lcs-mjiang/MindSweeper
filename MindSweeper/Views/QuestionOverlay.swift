import SwiftUI

struct QuestionOverlay: View {
    let card: Card
    let onSubmit: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var answer: String = ""
    @State private var showHint: Bool = false
    
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text(card.question)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.top)

            if let hint = card.hint {
                Toggle("Show hint", isOn: $showHint)
                    .padding(.horizontal)
                
                if showHint {
                    Text(hint)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }

            TextField("Enter your answer", text: $answer)
                .textFieldStyle(.roundedBorder)
                .focused($isInputFocused)
                .onSubmit {
                    submitAnswer()
                }
                .padding(.horizontal)

            Button("Submit") {
                submitAnswer()
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
            
            Spacer()
        }
        .padding()
        .onAppear {
            isInputFocused = true
            answer = ""
        }
    }
    
    private func submitAnswer() {
        onSubmit(answer)
        dismiss() 
    }
}
