import SwiftUI

// 1. IL DESIGN DEL BOX (Bordo Blu e fondo bianco)
// Questo viene usato da tutti gli altri componenti per avere uno stile coerente.
struct NiceBox: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerRadius: CGFloat = 20
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        return path
    }
}

struct DecorativeBox: View {
    var body: some View {
        NiceBox()
            .fill(Color.white)
            .overlay(
                NiceBox()
                    .stroke(Color.blue, lineWidth: 3)
            )
            .shadow(radius: 5)
    }
}

// 2. SCHERMATA CAPITOLO (Titolo + Intro)
struct ChapterView: View {
    var title: String
    var introduction: String
    
    var body: some View {
        VStack(spacing: 30) {
            Text(title)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.black)
                .padding()
                .background(DecorativeBox())
            
            Text(introduction)
                .font(.system(size: 22))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding()
                .background(DecorativeBox())
        }
        .padding()
    }
}

// 3. BOX DIALOGO (Dove appare il testo dei personaggi)
struct DialogueBoxView: View {
    var text: String
    
    var body: some View {
        ZStack {
            DecorativeBox()
            Text(text)
                .font(.title3)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
        }
        .frame(minHeight: 120) // Altezza minima per essere leggibile
        .padding(.horizontal, 20)
    }
}

// 4. BOX DELLE SCELTE (I bottoni)
struct ChoiceView: View {
    let options: [ChoiceOption]
    let onSelect: (ChoiceOption) -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(options, id: \.text) { option in
                Button(action: { onSelect(option) }) {
                    Text(option.text)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue, lineWidth: 3)
                        )
                        .shadow(radius: 3)
                }
            }
        }
        .padding()
    }
}

// 5. SCHERMATA MORALE (Feedback fine capitolo)
struct MoralView: View {
    var good: Bool
    var title: String
    var text: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .bold()
                .foregroundColor(good ? .green : .red) // Verde se bravo, Rosso se male
                .padding()
                .background(DecorativeBox())
            
            Text(text)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .background(DecorativeBox())
        }
        .padding()
    }
}

// 6. SCHERMATA PUNTEGGIO FINALE
struct FinalScoreView: View {
    var score: Int
    var onRestart: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Final Score")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .shadow(radius: 5)
            
            ZStack {
                DecorativeBox()
                Text("\(score)")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.blue)
            }
            .frame(width: 200, height: 200)
            
            Button(action: onRestart) {
                Text("Back to Home")
                    .font(.title2)
                    .bold()
                    .padding()
                    .frame(width: 200)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
            }
        }
        .padding()
    }
}

// Anteprima per controllare che sia tutto bello
#Preview {
    ZStack {
        Color.gray
        VStack {
            DialogueBoxView(text: "Questo è un test di dialogo.")
            ChoiceView(options: [ChoiceOption(text: "Opzione 1", nextNodeID: "", scoreImpact: 0)], onSelect: {_ in})
        }
    }
}
