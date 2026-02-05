import SwiftUI

struct MainView: View {
    // Qui creiamo l'istanza del "Cervello" che gestirà tutta la sessione
    @StateObject private var viewModel = StoryViewModel()
    
    // Questa variabile controlla la navigazione: False = Menu, True = Storia
    @State private var isPlaying = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Sfondo Home
                Image("home")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    // Titolo
                    Text("Aisha")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                    
                    Text("choices that matter")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 5)
                    
                    Spacer()
                    
                    // Bottone Play
                    Button(action: {
                        // 1. Resetta la storia all'inizio
                        viewModel.startStory()
                        // 2. Attiva la navigazione verso la storia
                        isPlaying = true
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Gioca")
                                .fontWeight(.bold)
                        }
                        .font(.title)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .shadow(radius: 10)
                        .overlay(
                            Capsule().stroke(Color.white, lineWidth: 2)
                        )
                    }
                    .padding(.bottom, 60)
                }
            }
            // NAVIGAZIONE:
            // Quando 'isPlaying' diventa vero, lo schermo cambia e mostra GenericChapterView
            .navigationDestination(isPresented: $isPlaying) {
                GenericChapterView(viewModel: viewModel)
                    .navigationBarBackButtonHidden(true) // Nascondiamo il tasto "Indietro" standard di iOS
            }
        }
    }
}

#Preview {
    MainView()
}
