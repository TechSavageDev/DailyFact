//
//  ForgotPasswordSheet.swift
//  DailyFacts
//
//  Created by Genadi C on 24/08/2023.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordSheet: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var email: String
//    @State var email: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State var bounceDistance: CGFloat = 200
    @State var isRotate: Double = 0.0 // Rotation Effect
    @State var yOffsetTopCircle: CGFloat = 0 // For moving effect on Y scale
    @State var xOffsetTopCircle: CGFloat = 0 // For moving effect on X scale
    @State var yOffsetBottomCircle: CGFloat = 0 // For moving effect on Y scale
    @State var xOffsetBottomCircle: CGFloat = 0 // For moving effect on X scale
    
    var body: some View {
        let color = Gradient(colors: [.red, .yellow, .green, .blue, .purple, .cyan, .indigo, .mint, .pink, .teal, .orange, .red])
        let gradient = AngularGradient(gradient: color, center: .center) // Constant for Cirlce gradient
        
        
        ZStack{
            
            Color("Background")
                .ignoresSafeArea()
            
            
            // Group of Circles
            Group {
                
                // Bottom Left rect
                Rectangle()
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(isRotate))
                    .cornerRadius(50)
                    .offset(x: -200 + xOffsetTopCircle, y: 400 - yOffsetTopCircle)
                    .blur(radius: 40)
                    .background(Circle()
                        .fill(gradient)
                        .opacity(0.5)
                        .rotationEffect(.degrees(isRotate))
                        .offset(x: -200 + xOffsetTopCircle, y: 400 - yOffsetTopCircle)
                        .blur(radius: 50)
                    )
                
                // Top Right Rect
                Rectangle()
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(isRotate))
                    .cornerRadius(50)
                    .offset(x: 200 - xOffsetTopCircle, y: -400 + yOffsetTopCircle)
                    .blur(radius: 40)
                    .background(Circle()
                        .fill(gradient)
                        .opacity(0.5)
                        .rotationEffect(.degrees(isRotate))
                        .offset(x: 200 - xOffsetTopCircle, y: -400 + yOffsetTopCircle)
                        .blur(radius: 50)
                    )
                
                // Top Left Rect
                Rectangle()
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(isRotate))
                    .cornerRadius(50)
                    .offset(x: -200 + xOffsetTopCircle, y: -400 + yOffsetTopCircle)
                    .blur(radius: 40)
                    .background(Circle()
                        .fill(gradient)
                        .opacity(0.5)
                        .rotationEffect(.degrees(isRotate))
                        .offset(x: -200 + xOffsetTopCircle, y: -400 + yOffsetTopCircle)
                        .blur(radius: 50)
                    )
                
                // Bottom Right Rect
                Rectangle()
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(isRotate))
                    .cornerRadius(50)
                    .offset(x: 200 - xOffsetTopCircle, y: 400 - yOffsetTopCircle)
                    .blur(radius: 40)
                    .background(Circle()
                        .fill(gradient)
                        .opacity(0.5)
                        .rotationEffect(.degrees(isRotate))
                        .offset(x: 200 - xOffsetTopCircle, y: 400 - yOffsetTopCircle)
                        .blur(radius: 50)
                    )
            }
            .foregroundColor(colorScheme == .light ? .black.opacity(0.2) : .gray.opacity(0.7))
            // Bounce Effect
            .onAppear{
                withAnimation(.easeInOut(duration: 14).repeatForever(autoreverses: true)){
                    xOffsetTopCircle = bounceDistance + 150
                    yOffsetTopCircle = bounceDistance + 600
                }
            }
            // Rotate Effect
            .onAppear{
                withAnimation(.linear(duration: 7).repeatForever(autoreverses: false)){
                    isRotate = 360.0
                }
            }
            // Group of Circles END
            
            VStack{
                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("LText"))
                Spacer()
                
                VStack{
                    Text("Email")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.semibold)
                        .font(.title)
                    HStack{
                        Image(systemName: "envelope")
                        TextField("Email", text: $email)
                            .fontWeight(.regular)
                            .font(.title2)
                    }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                }
                .padding()
                .foregroundColor(Color("LText"))
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color("GlassArea")))
                
                
                Spacer()
                
                
                Button{
                    forgotPass()
                }label: {
                    Label("Reset Password", systemImage: "arrow.triangle.2.circlepath")
                        .padding()
                        .foregroundColor(Color("LText"))
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .background(Color("GlassArea"))
                        .cornerRadius(10)
                }
            }
            .padding()
            .alert(isPresented: $showAlert){
                Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("Got it")))
            }
        }
    }
    
    private func forgotPass() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = error.localizedDescription
            } else {
                alertMessage = "Password reset email sent successfully. Check your inbox for instructions."
            }
            email = ""
            showAlert = true
        }
    }
}

//#Preview {
//    ForgotPasswordSheet()
//}
