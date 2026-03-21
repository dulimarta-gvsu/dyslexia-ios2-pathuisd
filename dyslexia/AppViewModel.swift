//
//  AppViewModel.swift
//  dyslexia

import Foundation
import Combine
class AppViewModel: ObservableObject {
    @Published var letters: [Letter] = []
    @Published var moves: Int = 0
    @Published var totalScore: Int = 0
    @Published var timeMs: Int = 0
    @Published var message: String = ""
    @Published var gameHistory: [WordRecord] = []
    @Published var minLen: Double = 3
    @Published var maxLen: Double = 10
    @Published var redValue: Double = 255
    @Published var greenValue: Double = 167
    @Published var blueValue: Double = 38
    
    // list ofwords to choose from
    let wordStock: [String] = [ "helium", "oxygen", "hydrogen", "carbon", "nitrogen", "neon", "lithium", "beryllium", "boron", "fluorine", "sodium","magnesium", "aluminum", "silicon", "phosphorus", "sulfur", "chlorine", "argon", "potassium", "calcium", "scandium", "titanium", "vanadium", "chromium", "manganese", "iron", "cobalt", "nickel", "copper", "zinc" ]
    
    // point vals for each letter
    let letterScore: [Character:Int] = [ "A":1, "B":3, "C":3, "D":2, "E":1, "F":4, "G":2, "H":4, "I":1, "J":8,
        "K":5, "L":1, "M":3, "N":1, "O":1, "P":3, "Q":10, "R":1, "S":1, "T":1, "U":1, "V":4, "W":4, "X":8, "Y":4, "Z":10 ]
    
    
    
    private var selectedWord: String = ""
    private var wordStartTime: Date = Date()
    init() {
        selectNewWord()
    }
    // Picks a new word, filters by the selected length range,
    // shuffles the letters, and resets round-specific values.
    func selectNewWord() {
        if !selectedWord.isEmpty && message.isEmpty {
            addHistoryRecord(pointForRecord: 0)
        }
        
        let minValue = Int(minLen)
        let maxValue = Int(maxLen)
        let candidates = wordStock.filter { $0.count >= minValue && $0.count <= maxValue }
        let newWord = (candidates.isEmpty ? wordStock.randomElement()! : candidates.randomElement()!).uppercased()
        selectedWord = newWord
        letters = newWord.map { ch in
            Letter(text: String(ch), point: letterScore[ch] ?? 1)
        }.shuffled()
        moves = 0
        timeMs = 0
        message = ""
        wordStartTime = Date()
    }
    
    
    func rearrange(to newLetters: [Letter]) {
        letters = newLetters
        moves += 1
        checkSolved()
    }
    
    
    private func checkSolved() {
        let guess = letters.prettyPrint()
        if guess != selectedWord {
            return
        }
        
        let elapsed = Int(Date().timeIntervalSince(wordStartTime) * 1000)
        timeMs = elapsed
        let wordPoints = letters.reduce(0) { $0 + $1.point }
        totalScore += wordPoints
        addHistoryRecord(pointForRecord: wordPoints)
        let seconds = Double(elapsed) / 1000.0
        message = "Correct!!! Moves: \(moves). Time: \(String(format: "%.1f", seconds))s +\(wordPoints) points"
    }
    
    
    private func addHistoryRecord(pointForRecord: Int) {
        let elapsedMs: Int
        if pointForRecord > 0 {
            elapsedMs = timeMs
        } else {
            elapsedMs = Int(Date().timeIntervalSince(wordStartTime) * 1000)
        }
        let rec = WordRecord(
            word: selectedWord,
            point: pointForRecord,
            moves: moves,
            seconds: elapsedMs / 1000
        )
        gameHistory.append(rec)
    }
    
    func sortByWord() {
        gameHistory.sort { $0.word < $1.word }
    }
    
    func sortByPoint() {
        gameHistory.sort { $0.point > $1.point }
    }
    
    func sortByMoves() {
        gameHistory.sort { $0.moves < $1.moves }
    }
    
    func sortBySeconds() {
        gameHistory.sort { $0.seconds > $1.seconds }
    }
    
    func setWordLengthRange(min: Double, max: Double) {
        minLen = min
        maxLen = max
    }
    
    func setLetterColor(r: Double, g: Double, b: Double) {
        redValue = r
        greenValue = g
        blueValue = b
    }
    
    func isComplete(record: WordRecord) -> Bool {
        return record.point > 0
    }
    
    func recordAt(index: Int) -> WordRecord? {
        if index < 0 || index >= gameHistory.count {
            return nil
        }
        return gameHistory[index]
    }
}
