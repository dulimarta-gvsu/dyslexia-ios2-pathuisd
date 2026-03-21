//
//  GameSettingsView.swift
//  dyslexia
//
//  Created by Hayden Alvyn C. Oly on 3/19/26.
//
import SwiftUI
struct GameSettingsView: View {
    @ObservedObject private var viewModel: AppViewModel
    private var onBack: () -> Void
    init(
        viewModel: AppViewModel,
        onBack: @escaping () -> Void
    ) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.onBack = onBack
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button("Back") {
                onBack()
            }
            .buttonStyle(.bordered)
            Text("Word length range: \(Int(viewModel.minLen)) to \(Int(viewModel.maxLen))")
            VStack(alignment: .leading) {
                Text("Min Length")
                Slider(
                    value: Binding(
                        get: { viewModel.minLen },
                        set: { newValue in
                            let fixedMin = min(newValue, viewModel.maxLen)
                            viewModel.setWordLengthRange(min: fixedMin, max: viewModel.maxLen)
                        }
                    ),
                    in: 2...16,
                    step: 1
                )
                Text("Max Length")
                Slider(
                    value: Binding(
                        get: { viewModel.maxLen },
                        set: { newValue in
                            let fixedMax = max(newValue, viewModel.minLen)
                            viewModel.setWordLengthRange(min: viewModel.minLen, max: fixedMax)
                        }
                    ),
                    in: 2...16,
                    step: 1
                )
            }
            Text("Letter background color (RGB)")
            Text("R: \(Int(viewModel.redValue))")
            Slider(
                value: Binding(
                    get: { viewModel.redValue },
                    set: { viewModel.setLetterColor(r: $0, g: viewModel.greenValue, b: viewModel.blueValue) }
                ),
                in: 0...255,
                step: 1
            )
            Text("G: \(Int(viewModel.greenValue))")
            Slider(
                value: Binding(
                    get: { viewModel.greenValue },
                    set: { viewModel.setLetterColor(r: viewModel.redValue, g: $0, b: viewModel.blueValue) }
                ),
                in: 0...255,
                step: 1
            )
            Text("B: \(Int(viewModel.blueValue))")
            Slider(
                value: Binding(
                    get: { viewModel.blueValue },
                    set: { viewModel.setLetterColor(r: viewModel.redValue, g: viewModel.greenValue, b: $0) }
                ),
                in: 0...255,
                step: 1
            )
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

