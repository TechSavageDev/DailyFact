//
//  testView.swift
//  DailyFacts
//
//  Created by Genadi C on 01/09/2023.
//
//
//  UserProfileView.swift
//  DailyFacts
//
//  Created by Genadi C on 15/08/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct testView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var userEmail: String = "UserEmail" // Default value
    @State private var userName: String = "Username"
    
    @State var isBounce: CGFloat = 200
    @State var isRotate: Double = 0.0
    @State var yOffsetbottomCircle: CGFloat = 0
    @State var xOffsetTopCircle: CGFloat = 0
    @State var yOffsetTopCircle: CGFloat = 0
    @State var xOffsetBottomopCircle: CGFloat = 0
    
    @State private var isDragging = false
    
    @State private var isMenuOpen = false
    
    @State private var favoriteFacts: [FactModel] = []
    var body: some View {
        let color = Gradient(colors: [.red, .yellow, .green, .blue, .purple, .cyan, .indigo, .mint, .pink, .teal, .orange, .red])
        let gradient = AngularGradient(gradient: color, center: .center) // Constant for Cirlce gradient
        
        NavigationView {
            ZStack {
                
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
                        xOffsetTopCircle = isBounce + 150
                        yOffsetTopCircle = isBounce + 600
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
                    // Header VStack
                    HStack {
                        Text("Hello, \(userName)!")
                            .frame(maxWidth: .infinity, alignment:.leading)
                            .font(.title2)
                            .fontWeight(.light)
                    }
                    .padding()
                    // Header VStack END
                    
                    Spacer()
                    
                    ScrollView {
                        ForEach(0..<10) { fact in
                            HStack {
                                VStack{
                                    Text("This is test fact with some fact in it")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.title2)
                                        .foregroundColor(colorScheme == .light ? Color("LText") : .white)
                                    VStack(alignment: .trailing) {
                                        Text("fact category")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(colorScheme == .light ? Color("LText").opacity(0.8) : .white)
                                        Text("fact source")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(colorScheme == .light ? Color("LText").opacity(0.5) : .white)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .padding()
                                .background(Color("GlassArea"))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                
                               
                            }
                            .gesture(
                                DragGesture()
                                    .onChanged{ _ in
                                            isDragging = true
                                    }
                                    .onEnded{ _ in
                                        isDragging = false
                                    }
                            )
                        }
                        .onAppear{
                            // show favourites fact
                        }
                    }
                    .scrollIndicators(.hidden)
                    
                    Text("Ver: 1.0")
                        .font(.footnote)
                        .padding(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
            }
        }
    }
}


#Preview {
    testView()
}
