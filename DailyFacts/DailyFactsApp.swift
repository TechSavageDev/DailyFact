//
//  DailyFactsApp.swift
//  DailyFacts
//
//  Created by Genadi C on 10/08/2023.
//

import SwiftUI
import FirebaseCore

@main
struct DailyFactsApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
