//
//  GameDetailView.swift
//  dyslexia
//
//  Created by Hayden Alvyn C. Oly on 3/19/26.
//
import SwiftUI
struct GameDetailView: View {
    @ObservedObject private var viewModel: AppViewModel
    private let index: Int
    private var onBack: () -> Void
    init(
        viewModel: AppViewModel,
        index: Int,
        onBack: @escaping () -> Void
    ) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.index = index
        self.onBack = onBack
    }
    var body: some View {
        let record = viewModel.recordAt(index: index)
        VStack(alignment: .leading, spacing: 12) {
            Button("Back") {
                onBack()
            }
            .buttonStyle(.bordered)
            if let record = record {
                let complete = record.point > 0
                Text("Word: \(record.word)")
                Text("Complete: \(complete ? "true" : "false")")
                Text("Points: \(record.point)")
                Text("Moves: \(record.moves)")
                Text("Seconds: \(record.seconds)")
            } else {
                Text("No record found.")
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
