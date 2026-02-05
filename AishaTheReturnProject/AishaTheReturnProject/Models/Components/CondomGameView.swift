import SwiftUI

struct CondomGameView: View {
    // Questa funzione viene chiamata quando hai vinto, per dire alla storia di proseguire
    var onWin: () -> Void
    
    @State private var isOpened = false
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Sfondo
            Image("sfondom") // Assicurati di avere 'sfondom' negli Assets, altrimenti usa un colore
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Text(isOpened ? "Ben Fatto!" : "Scorri verso il basso per aprire")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(15)
                    .padding(.top, 50)
                
                Spacer()
                
                ZStack {
                    // Immagine Preservativo
                    Image(isOpened ? "condomopen" : "condomclose")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .offset(y: isOpened ? 0 : dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Permetti solo il movimento verso il basso
                                    if !isOpened && value.translation.height > 0 {
                                        dragOffset = value.translation.height
                                    }
                                }
                                .onEnded { value in
                                    // Se trascini abbastanza, si apre
                                    if value.translation.height > 100 {
                                        withAnimation {
                                            isOpened = true
                                            dragOffset = 0
                                        }
                                        // Dopo 1.5 secondi, vinci e vai avanti
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            onWin()
                                        }
                                    } else {
                                        // Se lasci troppo presto, torna su
                                        withAnimation {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )
                }
                Spacer()
            }
        }
    }
}

#Preview {
    CondomGameView(onWin: {})
}
