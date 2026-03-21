//
//  LetterGroup.swift
//  dyslexia

import SwiftUI

struct LetterGroup: View {
    @Binding var letters: [Letter]
    var boxColor: Color
    var onRearrangeLetters: ([Letter]) -> Void

    @State var boxSize = CGSize.zero
    @State var startCellIndex: Int? = nil
    @State var blankCellIndex: Int? = nil
    @State var pointerIndex: Float? = nil
    @State var dragOffset = CGPoint.zero
    @State var draggedLetter: Letter? = nil
    @State var startPointerPosition = CGPoint.zero

    var body: some View {
        GeometryReader { geo in
            ZStack {
                let availableWidth = geo.size.width
                let letterSize = min(80, (availableWidth - 32) / CGFloat(max(letters.count, 1)))

                if let draggedLetter {
                    BigLetter(letter: draggedLetter, size: letterSize, boxColor: boxColor)
                        .offset(
                            x: dragOffset.x + startPointerPosition.x - boxSize.width / 2,
                            y: dragOffset.y
                        )
                }

                VStack {
                    HStack(spacing: 2) {
                        if letters.count > 0 {
                            ForEach(Array(self.letters.enumerated()), id: \.offset) { pos, letter in
                                BigLetter(letter: letter, size: letterSize, boxColor: boxColor)
                            }
                        } else {
                            BigLetter(letter: Letter(), size: letterSize, boxColor: boxColor)
                        }
                    }
                    .onGeometryChange(for: CGSize.self, of: { $0.size }) {
                        boxSize = $0
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { drag in
                                guard letters.count > 0 else { return }

                                let percentage = drag.location.x / boxSize.width
                                var index = percentage * CGFloat(letters.count)
                                startPointerPosition = drag.startLocation

                                if index < 0 {
                                    index = 0
                                } else if index > CGFloat(letters.count - 1) {
                                    index = CGFloat(letters.count - 1)
                                }

                                if draggedLetter == nil {
                                    blankCellIndex = Int(index)
                                    draggedLetter = letters[blankCellIndex!]
                                    letters[blankCellIndex!] = Letter()
                                }

                                if startCellIndex == nil {
                                    startCellIndex = Int(index)
                                }

                                if blankCellIndex != Int(index) {
                                    letters[blankCellIndex!] = letters[Int(index)]
                                    letters[Int(index)] = Letter()
                                    blankCellIndex = Int(index)
                                }

                                pointerIndex = Float(index)
                                dragOffset = CGPoint(
                                    x: drag.location.x - drag.startLocation.x,
                                    y: drag.location.y - drag.startLocation.y
                                )
                            }
                            .onEnded { _ in
                                guard letters.count > 0, blankCellIndex != nil else {
                                    draggedLetter = nil
                                    pointerIndex = nil
                                    startCellIndex = nil
                                    blankCellIndex = nil
                                    startPointerPosition = CGPoint.zero
                                    dragOffset = CGPoint.zero
                                    return
                                }

                                letters[blankCellIndex!] = draggedLetter!
                                draggedLetter = nil
                                pointerIndex = nil
                                startCellIndex = nil
                                blankCellIndex = nil
                                startPointerPosition = CGPoint.zero
                                dragOffset = CGPoint.zero
                                self.onRearrangeLetters(letters)
                            }
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct BigLetter: View {
    private let ch: String
    private let pt: Int
    let size: CGFloat
    let boxColor: Color
    init(letter: Letter, size: CGFloat = 44, boxColor: Color = .mint) {
        self.ch = String(letter.text)
        self.pt = letter.point
        self.size = size
        self.boxColor = boxColor
    }
    var body: some View {
        ZStack {
            Text(self.ch)
                .font(Font.system(size: 0.8 * self.size, weight: .bold))
            if pt != 0 {
                VStack {
                    Spacer()
                    HStack {
                        Text("\(pt)")
                            .font(.system(size: 0.18 * self.size))
                        Spacer()
                    }
                    .padding(.leading, 4)
                    .padding(.bottom, 2)
                }
            }
        }
        .frame(width: self.size, height: self.size)
        .background(self.pt == 0 ? .clear : boxColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black, lineWidth: 2)
        )
    }
}


