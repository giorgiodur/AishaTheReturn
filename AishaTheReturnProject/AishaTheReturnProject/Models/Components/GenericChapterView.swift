import SwiftUI

struct GenericChapterView: View {
    // Riceve il "cervello" (ViewModel) dal Menu principale
    @ObservedObject var viewModel: StoryViewModel
    
    var body: some View {
        ZStack {
            // 1. SFONDO DINAMICO
            // Cambia automaticamente leggendo viewModel.currentBackground
            Image(viewModel.currentBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                // Sfoca leggermente se non è un gioco, per rendere leggibile il testo
                .blur(radius: (isGame ? 0 : 4))
            
            // 2. CONTENUTO DINAMICO
            // Controlliamo: c'è una pagina da mostrare?
            if let node = viewModel.currentNode {
                VStack {
                    // Switch controlla CHE TIPO di pagina è (Narrativa, Dialogo, Scelta...)
                    switch node.type {
                        
                    // CASO A: Narrativa (Titolo + Intro)
                    case .narrative(let title, let text):
                        Spacer()
                        ChapterView(title: title, introduction: text)
                            .onTapGesture { viewModel.next() } // Al tocco, vai avanti
                        Spacer()
                        Text("Tocca per continuare")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.bottom, 50)
                            
                    // CASO B: Dialogo (Personaggio + Box Testo)
                    case .dialogue(let character, let text, let isLeft):
                        Spacer()
                        // Mostriamo il personaggio solo se esiste
                        if character != .none {
                            HStack {
                                // Se isLeft è false, spingiamo il personaggio a destra con uno Spacer
                                if !isLeft { Spacer() }
                                
                                // Assicurati che l'immagine esista in Assets, altrimenti sarà vuota
                                Image(character.rawValue)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 350) // Altezza personaggio
                                    .shadow(radius: 5)
                                
                                // Se isLeft è true, spingiamo il personaggio a sinistra con uno Spacer dopo
                                if isLeft { Spacer() }
                            }
                        }
                        // Il Box del testo
                        DialogueBoxView(text: text)
                            .onTapGesture { viewModel.next() }
                            .padding(.bottom, 50)
                            
                    // CASO C: Scelta (Aisha che pensa + Bottoni)
                    case .choice(let options):
                        Spacer()
                        Image("aisha") // Aisha pensierosa
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                        
                        // Lista bottoni
                        ChoiceView(options: options) { selectedOption in
                            // Quando l'utente sceglie, lo diciamo al cervello
                            viewModel.makeChoice(selectedOption)
                        }
                        .padding(.bottom, 50)
                        
                    // CASO D: Morale (Fine capitolo)
                    case .moral(let good, let title, let text):
                        Spacer()
                        MoralView(good: good, title: title, text: text)
                            .onTapGesture { viewModel.next() }
                        Spacer()
                        
                    // CASO E: Finale Punteggio
                    case .ending(let score):
                        Spacer()
                        FinalScoreView(score: score) {
                            // Al click su "Torna alla Home", riavviamo la storia
                            viewModel.startStory()
                        }
                        Spacer()
                        
                    // CASO F: Giochi (COLLEGAMENTO EFFETTUATO QUI)
                    case .game(let type):
                        if type == .condom {
                            // Mostra il gioco del preservativo
                            CondomGameView {
                                // Questa parte viene eseguita QUANDO VINCI:
                                viewModel.next() // Vai alla prossima pagina
                            }
                        } else if type == .car {
                            // Mostra il gioco della macchina
                            CarGameView {
                                // Questa parte viene eseguita QUANDO VINCI:
                                viewModel.next() // Vai alla prossima pagina
                            }
                        }
                    }
                }
                .padding()
                // Animazione fluida quando cambia la pagina
                .animation(.easeInOut, value: node.id)
            }
        }
    }
    
    // Helper: ci dice se la pagina corrente è un gioco (per togliere la sfocatura allo sfondo)
    var isGame: Bool {
        if let type = viewModel.currentNode?.type, case .game = type {
            return true
        }
        return false
    }
}

#Preview {
    GenericChapterView(viewModel: StoryViewModel())
}
