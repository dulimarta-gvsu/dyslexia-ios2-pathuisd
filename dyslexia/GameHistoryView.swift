//
//  GameHistoryView.swift
//  dyslexia
//
//  Created by Hayden Alvyn C. Oly on 3/19/26.
//
import SwiftUI
struct GameHistoryView: View {
    @ObservedObject private var viewModel: AppViewModel
    private var onBack: () -> Void
    private var onSelectIndex: (Int) -> Void
    init(
        viewModel: AppViewModel,
        onBack: @escaping () -> Void,
        onSelectIndex: @escaping (Int) -> Void
    ) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.onBack = onBack
        self.onSelectIndex = onSelectIndex
    }
    var body: some View {
        VStack {
            HStack {
                Button("Back") {
                    onBack()
                }
                Button("Word") {
                    viewModel.sortByWord()
                }
                Button("Point") {
                    viewModel.sortByPoint()
                }
                Button("Moves") {
                    viewModel.sortByMoves()
                }
                Button("Time") {
                    viewModel.sortBySeconds()
                }
            }
            .buttonStyle(.bordered)
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(Array(viewModel.gameHistory.enumerated()), id: \.element.id) { idx, record in
                        let complete = viewModel.isComplete(record: record)
                        VStack(alignment: .leading) {
                            Text(record.word)
                                .font(.headline)
                            Text("Points: \(record.point)   Moves: \(record.moves)   Time: \(record.seconds)s")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(complete ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(complete ? Color.green : Color.red, lineWidth: 2)
                        )
                        .onTapGesture {
                            onSelectIndex(idx)
                        }
                    }
                }
                .padding(.top, 12)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

