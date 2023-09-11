//
//  RegisterView.swift
//  DailyFacts
//
//  Created by Genadi C on 15/07/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RegisterView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var currentViewShowing: String
    @AppStorage("uid") var userID: String = ""
    
    @State private var fName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmedPassword: String = ""
    
    @State private var showAlert: Bool = false
    
    @State private var isRotate: Double = 0.0 // Rotation Effect
    @State private var yOffsetTopCircle: CGFloat = 0 // For moving effect on Y scale
    @State private var xOffsetTopCircle: CGFloat = 0 // For moving effect on X scale
    @State private var yOffsetBottomCircle: CGFloat = 0 // For moving effect on Y scale
    @State private var xOffsetBottomCircle: CGFloat = 0 // For moving effect on X scale
    
    let bounceDistance: CGFloat = 350 // Bouncing Value
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        
        // Side Circles
        let color = Gradient(colors: [.red, .yellow, .green, .blue, .purple, .cyan, .indigo, .mint, .pink, .teal, .orange, .red])
        let gradient = AngularGradient(gradient: color, center: .center) // Constant for Cirlce gradient
        
        
        ZStack {
            
            Color("Background")
                .ignoresSafeArea()
            
            // Group of Circles
            Group {
                
                // Top Rectangle
                Rectangle()
                    .foregroundColor(Color("TopAdd"))
                    .frame(width: 300, height: 300)
                    .cornerRadius(500)
                    .offset(x: 300 - xOffsetTopCircle, y: -300 + yOffsetTopCircle)
                    .blur(radius: 10)
                    .background(Circle()
                        .fill(gradient)
                        .rotationEffect(Angle(degrees: isRotate))
                        .offset(x: 300 - xOffsetTopCircle, y: -300 + yOffsetTopCircle)
                        .blur(radius: 20)
                    )
                
                // Bottom Rectangle
                Rectangle()
                    .foregroundColor(Color("BottomAdd"))
                    .frame(width: 300, height: 300)
                    .cornerRadius(500)
                    .offset(x: -300 + xOffsetBottomCircle, y: 300 - yOffsetBottomCircle)
                    .blur(radius: 10)
                    .background(Circle()
                        .fill(gradient)
                        .rotationEffect(Angle(degrees: isRotate))
                        .offset(x: -300 + xOffsetBottomCircle, y: 300 - yOffsetBottomCircle)
                        .blur(radius: 20)
                    )
                    .onAppear{
                        withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)){
                            isRotate = 360
                        }
                    }
            }
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 15).repeatForever(autoreverses: true)) {
                    yOffsetTopCircle = bounceDistance
                    xOffsetTopCircle = bounceDistance
                    yOffsetBottomCircle = bounceDistance
                    xOffsetBottomCircle = bounceDistance
                }
            }
            // Group of Circles END
            
            
            VStack {
                
                Text("Create New Account!")
                    .frame(maxWidth: .infinity ,alignment: .leading)
                    .font(.largeTitle)
                    .foregroundColor(colorScheme == .light ? Color("LText") : .white)
                    .bold()
                
                Spacer()
                
                VStack(spacing: 30) {
                    
                    // FullName VStack
                    VStack {
                        Text("Full name")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                        
                        HStack{
                            Image(systemName: "person")
                                .fontWeight(.regular)
                            TextField("Enter your full name", text: $fName)
                                .fontWeight(.regular)
                        }
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                    }
                    // FullName VStack END
                    
                    // Email VStack
                    VStack {
                        Text("Email")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                        
                        HStack{
                            Image(systemName: "envelope")
                                .fontWeight(.regular)
                            TextField("Register new Email", text: $email)
                                .fontWeight(.regular)
                            if(email.count != 0){
                                Image(systemName: email.isValidEmail() ? "checkmark.seal" : "xmark")
                                    .foregroundColor(email.isValidEmail() ? .green : .red)
                            }
                        }
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                    }
                    // Email VStack END
                    
                    // Password VStack
                    VStack {
                        Text("Password")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                        
                        HStack{
                            Image(systemName: "eye")
                                .fontWeight(.regular)
                            SecureField("Create Password", text: $password)
                            if(password.count != 0){
                                Image(systemName: isValidPassword(password) ? "checkmark.seal" : "xmark")
                                    .foregroundColor(isValidPassword(password) ? .green : .red)
                            }
                        }
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                    }
                    // Password VStack END
                    
                    VStack {
                        Text("Confirm Password")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                        
                        HStack{
                            Image(systemName: "eye")
                                .fontWeight(.regular)
                            SecureField("Re-type Password", text: $confirmedPassword)
                            if(password.count != 0){
                                Image(systemName: isValidConfirmedPassword() ? "checkmark.seal" : "xmark")
                                    .foregroundColor(isValidConfirmedPassword() ? .green : .red)
                            }
                        }
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                    }
                    
                    HStack(spacing: 30){
                        
                        Text("Already have account?")
                        Spacer()
                        
                        Button{
                            withAnimation{
                                self.currentViewShowing = "login"
                            }
                        }label: {
                            Text("Sign In")
                                .font(.callout)
                                .foregroundStyle(colorScheme == .light ? Color("LText") : .white)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 500)
                .background(Color("GlassArea"))
                .cornerRadius(20)
                
                Spacer()
                
                // MARK: Register Button
                Button{
                    if isValidPassword(password) && isValidConfirmedPassword() {
                        signIn()
                    }else{
                        showAlert = true
                    }
                    
                }label: {
                    Label("Register Account", systemImage: "person.crop.circle.fill.badge.plus")
                        .padding()
                        .foregroundColor(colorScheme == .light ? Color("LText") : .white)
                        .font(.title2)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .background(Color("GlassArea"))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("Passwords Don't Match"), message: Text("Please make sure the passwords match."), dismissButton: .default(Text("Got it")))
        }
    }
    
    private func isValidConfirmedPassword()-> Bool {
        return confirmedPassword == password
    }
    
    // Authentication Function
    private func signIn(){
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                print(error)
                return
            }
            
            if let authResult = authResult {
                print(authResult.user.uid)
                userID = authResult.user.uid
            }
            self.storeUserData()
            
        }
    }
    
    private func storeUserData(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userData = ["fName": self.fName, "email": self.email, "uid": uid]
        
        Firestore.firestore().collection("users").document(uid).setData(userData) { err in
            
            if let err = err{
                print(err)
                return
            }
            
            print("Success")
        }
    }
    
}

#Preview {
    ContentView()
}
