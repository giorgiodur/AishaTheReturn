import Foundation

// 1. I Personaggi (i nomi devono essere uguali a quelli nel file Assets)
enum Character: String {
    case aisha = "aisha"
    case carlos = "carlos"
    case lina = "lina"
    case rania = "rania"
    case mother = "mother"
    case doctor = "doctor"
    case none = "" // Quando parla il narratore
}

// 2. Gli Sfondi (i nomi devono essere uguali a quelli nel file Assets)
enum Background: String {
    case house = "house"
    case school = "school"
    case square = "square"
    case hospital = "hospital"
    case hospitalInternal = "hospital2"
    case room = "room"
    case city = "city"
}

// 3. I Tipi di Minigiochi
enum GameType {
    case condom
    case car
}

// 4. I Tipi di "Pagina" della storia
enum StoryNodeType {
    case narrative(title: String, text: String)         // Titolo e Intro
    case dialogue(character: Character, text: String, isLeft: Bool) // Dialogo
    case choice(options: [ChoiceOption])                // Scelta multipla
    case moral(good: Bool, title: String, text: String) // Schermata Morale
    case game(GameType)                                 // Minigioco
    case ending(score: Int)                             // Finale Punteggio
}

// 5. Struttura di una Scelta
struct ChoiceOption {
    let text: String        // Cosa c'è scritto sul bottone
    let nextNodeID: String  // Dove porta questa scelta (ID della prossima pagina)
    let scoreImpact: Int    // Punti (+2 o -1)
}

// 6. Il "Mattoncino" della storia (Una singola schermata)
struct StoryNode {
    let id: String              // ID unico (es. "cap1_intro")
    let type: StoryNodeType     // Che tipo di pagina è?
    let background: Background  // Che sfondo ha?
    let nextNodeID: String?     // Qual è la prossima pagina automatica? (nil se è una scelta)
}
