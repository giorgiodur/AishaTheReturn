import SwiftUI
import Combine

class StoryViewModel: ObservableObject {
    // VARIABILI CHE LA GRAFICA ASCOLTA
    @Published var currentNode: StoryNode?       // La pagina attuale
    @Published var currentScore: Int = 0         // Il punteggio
    @Published var currentBackground: String = "home" // Lo sfondo attuale
    
    // IL DATABASE (Qui dentro ci sarà tutta la storia)
    var storyNodes: [String: StoryNode] = [:]
    
    init() {
        setupStory()
        startStory()
    }
    
    // Funzione per ricominciare da capo
    func startStory() {
        currentScore = 0
        loadNode(id: "start")
    }
    
    // Carica una pagina specifica tramite ID
    func loadNode(id: String) {
        if let node = storyNodes[id] {
            self.currentNode = node
            self.currentBackground = node.background.rawValue
        } else {
            print("❌ ERRORE: Non trovo il nodo con id: \(id)")
        }
    }
    
    // Va alla pagina successiva
    func next() {
        if let nextID = currentNode?.nextNodeID {
            loadNode(id: nextID)
        }
    }
    
    // Gestisce la scelta
    func makeChoice(_ option: ChoiceOption) {
        currentScore += option.scoreImpact
        loadNode(id: option.nextNodeID)
    }
    
    // --- STORIA DI TEST ---
    func setupStory() {
        storyNodes["start"] = StoryNode(
            id: "start",
            type: .narrative(title: "Chapter 1", text: "Aisha is at home with Carlos. He proposes to have sex."),
            background: .house,
            nextNodeID: "1_dial_1"
        )
        
        storyNodes["1_dial_1"] = StoryNode(
            id: "1_dial_1",
            type: .dialogue(character: .aisha, text: "Carlos, I like you, but I want to be safe.", isLeft: true),
            background: .house,
            nextNodeID: "1_dial_2"
        )
        
        storyNodes["1_dial_2"] = StoryNode(
            id: "1_dial_2",
            type: .dialogue(character: .carlos, text: "Trust me, we don't need condoms if we love each other.", isLeft: false),
            background: .house,
            nextNodeID: "1_choice"
        )
        
        storyNodes["1_choice"] = StoryNode(
            id: "1_choice",
            type: .choice(options: [
                ChoiceOption(text: "Say No & Explain", nextNodeID: "end_good", scoreImpact: 2),
                ChoiceOption(text: "Give in", nextNodeID: "end_bad", scoreImpact: -1)
            ]),
            background: .house,
            nextNodeID: nil
        )
        
        storyNodes["end_good"] = StoryNode(id: "end_good", type: .ending(score: 0), background: .house, nextNodeID: nil)
        storyNodes["end_bad"] = StoryNode(id: "end_bad", type: .ending(score: 0), background: .house, nextNodeID: nil)
    }
}
