//
//  ContentView.swift
//  DailyFacts
//
//  Created by Genadi C on 10/08/2023.
//

import Foundation
import SwiftUI
import Firebase

struct ContentView: View {
    
    @AppStorage("uid") var userID: String = ""
    @State private var isUserSignAuthenticated: Bool = false
    
    var body: some View {
        if userID == "" || isUserSignAuthenticated{
            AuthVIew()
        }else{
            CustomBar()
        }
    }
}

#Preview{
    ContentView()
}
