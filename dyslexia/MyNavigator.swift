//
//  MyNavigator.swift
//  dyslexia
//
//  Created by Hayden Alvyn C. Oly on 3/19/26.
//
import Foundation
import Combine
class MyNavigator: ObservableObject {
    @Published var navPath: [Route] = []
    
    func navigate(to dest: Route) {
        navPath.append(dest)
    }
    
    func navigateBack() {
        if !navPath.isEmpty {
            navPath.removeLast()
        }
    }
    
    func navigateBackToRoot() {
        navPath.removeAll()
    }
}

