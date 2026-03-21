//
//  dyslexiaApp.swift
//  dyslexia

import SwiftUI
@main
struct dyslexiaApp: App {
    @StateObject private var viewModel = AppViewModel()
    @StateObject private var navigator = MyNavigator()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel, navigator: navigator)
        }
    }
}
