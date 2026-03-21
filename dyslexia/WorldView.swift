//
//  WordView.swift
//  dyslexia
//
//  Created by Hayden Alvyn C. Oly on 3/19/26.
//
import SwiftUI
struct WordView: View {
    @ObservedObject private var viewModel: AppViewModel
    private var onGoHistory: () -> Void
    private var onGoSettings: () -> Void
    @State private var letters: [Letter] = []
    init(
        viewModel: AppViewModel,
        onGoHistory: @escaping () -> Void,
        onGoSettings: @escaping () -> Void
    ) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.onGoHistory = onGoHistory
        self.onGoSettings = onGoSettings
    }
    var body: some View {
        let boxColor = Color(
            red: viewModel.redValue / 255.0,
            green: viewModel.greenValue / 255.0,
            blue: viewModel.blueValue / 255.0
        )
        VStack {
            HStack {
                Button("New Word") {
                    viewModel.selectNewWord()
                }
                .buttonStyle(.borderedProminent)
                Button("History") {
                    onGoHistory()
                }
                .buttonStyle(.bordered)
                Button("Settings") {
                    onGoSettings()
                }
                .buttonStyle(.bordered)
            }
            HStack {
                Text("Move: \(viewModel.moves)")
                Text("Time: \(viewModel.timeMs / 1000) seconds")
            }
            .font(.system(size: 18))
            Text("Total Score: \(viewModel.totalScore)")
                .font(.system(size: 18))
            if !viewModel.message.isEmpty {
                Text(viewModel.message)
                    .font(.system(size: 18))
                    .padding(.top, 4)
            }
            Spacer()
            LetterGroup(
                letters: $letters,
                boxColor: boxColor
            ) { arr in
                viewModel.rearrange(to: arr)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onAppear {
            letters = viewModel.letters
        }
        .onReceive(viewModel.$letters) { newValue in
            letters = newValue
        }
    }
}
