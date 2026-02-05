import SwiftUI

struct CarGameView: View {
    var onWin: () -> Void
    
    @State private var carPosition: CGPoint = CGPoint(x: 100, y: 150)
    @State private var hasWon = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Sfondo Città
                Image("city")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Ospedale (Target)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("hospital2") // Assicurati di avere 'hospital2' in Assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding()
                    }
                }
                
                // Istruzioni
                if !hasWon {
                    VStack {
                        Text("Trascina l'auto all'ospedale!")
                            .font(.headline)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.top, 50)
                        Spacer()
                    }
                } else {
                    Text("OTTIMO LAVORO!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                }
                
                // Macchina (Draggable)
                Image("car")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                    .position(carPosition)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if !hasWon {
                                    carPosition = value.location
                                }
                            }
                            .onEnded { value in
                                // Controlliamo se la macchina è vicina all'angolo in basso a destra (Ospedale)
                                let targetX = geometry.size.width - 100
                                let targetY = geometry.size.height - 100
                                let currentX = value.location.x
                                let currentY = value.location.y
                                
                                // Distanza semplice
                                if currentX > (targetX - 100) && currentY > (targetY - 100) {
                                    withAnimation {
                                        hasWon = true
                                        // Posiziona l'auto perfettamente
                                        carPosition = CGPoint(x: targetX, y: targetY)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        onWin()
                                    }
                                }
                            }
                    )
            }
        }
    }
}

#Preview {
    CarGameView(onWin: {})
}
