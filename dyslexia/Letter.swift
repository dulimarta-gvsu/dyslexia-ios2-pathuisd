//
//  Letter.swift
//  dyslexia

import Foundation
struct Letter: Equatable, Hashable {
    var text: String = ""
    var point: Int = 0
}
struct WordRecord: Identifiable, Hashable {
    let id = UUID()
    let word: String
    let point: Int
    let moves: Int
    let seconds: Int
}
extension Array<Letter> {
    func prettyPrint() -> String {
        return self
            .map { "\($0.text)" }
            .joined(separator: "")
    }
}




