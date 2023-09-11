//
//  SignOutView.swift
//  DailyFacts
//
//  Created by Genadi C on 15/08/2023.
//

import SwiftUI
import FirebaseAuth

struct SignOutView: View {
    @StateObject private var sessionManager = SessionManager()
@State private var currentViewShowing: String = "login"
    
    var body: some View {
        NavigationView {
            if sessionManager.isLoggedIn {
                // Show the main authenticated content
                Text("Welcome to the app!")
                    .navigationBarItems(trailing: Button("Sign Out") {
                        sessionManager.signOut()
                    })
            } else {
                // Navigate to SignInView when the user is not logged in
                NavigationLink("", destination: ContentView(), isActive: $sessionManager.showSignInView)
                    .hidden()
            }
        }
        .environmentObject(sessionManager)
    }
}

class SessionManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var showSignInView = false
    
    init() {
        // Check initial authentication status
        checkAuthenticationStatus()
    }
    
    func checkAuthenticationStatus() {
        // Check Firebase authentication status and update isLoggedIn accordingly
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
            showSignInView = true // Show the SignInView when not logged in
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            showSignInView = true // Show the SignInView after signing out
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SignOutView()
}
