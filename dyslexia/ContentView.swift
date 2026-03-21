//
//  ContentView.swift
//  dyslexia

import SwiftUI
struct ContentView: View {
    @ObservedObject private var viewModel: AppViewModel
    @ObservedObject private var navigator: MyNavigator
    init(viewModel: AppViewModel, navigator: MyNavigator) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self._navigator = ObservedObject(wrappedValue: navigator)
    }
    var body: some View {
        NavigationStack(path: $navigator.navPath) {
            WordView(
                viewModel: viewModel,
                onGoHistory: {
                    navigator.navigate(to: .history)
                },
                onGoSettings: {
                    navigator.navigate(to: .settings)
                }
            )
            .navigationDestination(for: Route.self) { dest in
                switch dest {
                case .history:
                    GameHistoryView(
                        viewModel: viewModel,
                        onBack: {
                            navigator.navigateBack()
                        },
                        onSelectIndex: { idx in
                            navigator.navigate(to: .detail(index: idx))
                        }
                    )
                case .detail(let index):
                    GameDetailView(
                        viewModel: viewModel,
                        index: index,
                        onBack: {
                            navigator.navigateBack()
                        }
                    )
                case .settings:
                    GameSettingsView(
                        viewModel: viewModel,
                        onBack: {
                            navigator.navigateBack()
                        }
                    )
                }
            }
        }
    }
}
