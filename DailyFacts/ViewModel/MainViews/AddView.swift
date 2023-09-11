//
//  AddView.swift
//  DailyFacts
//
//  Created by Genadi C on 11/08/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


struct AddView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var fact: String = ""
    @State private var category: String = ""
    @State private var source: String = ""
    
    @State private var savedFacts: [FactModel] = [] // Variable that behaves like
    
    @State var bounceDistance: CGFloat = 200 // Bouncing Value
    @State var isRotate: Double = 0.0 // Rotation Effect
    @State var yOffsetTopCircle: CGFloat = 0 // For moving effect on Y scale
    @State var xOffsetTopCircle: CGFloat = 0 // For moving effect on X scale
    @State var yOffsetBottomCircle: CGFloat = 0 // For moving effect on Y scale
    @State var xOffsetBottomCircle: CGFloat = 0 // For moving effect on X scale
    
    // Alert variables
    @State private var showAlert : Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        
        // Main stack
        ZStack{
            Color("Background") // Main background
                .ignoresSafeArea()
            
            // Side Circles
            let color = Gradient(colors: [.red, .yellow, .green, .blue, .purple, .cyan, .indigo, .mint, .pink, .teal, .orange, .red])
            let gradient = AngularGradient(gradient: color, center: .center) // Constant for Cirlce gradient
            
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
            
            // Main Vstack
            VStack(spacing: 0){
                
                // Category VStack
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Category")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 20)
                        .padding(.bottom, -15)
                    
                    TextField("Category", text: $category)
                        .font(.title2)
                        .frame(height: 50)
                        .padding()
                        .background(Color("GlassArea"))
                        .background(.ultraThinMaterial)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(20)
                        .padding()
                }
                .foregroundColor(colorScheme == .light ? Color("LText") : .white)
                // Category VStack END
                
                // Fact VStack
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Fact")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 20)
                        .padding(.bottom, -15)
                    
                    TextField("Describe fact", text: $fact, axis: .vertical)
                        .padding()
                        .font(.title2)
                        .frame(height: 300, alignment: .top)
                        .background(Color("GlassArea"))
                        .background(.ultraThinMaterial)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(20)
                        .padding()
                }
                .foregroundColor(colorScheme == .light ? Color("LText") : .white)
                // Fact VStack END
                
                // Source VStack
                VStack(alignment: .leading, spacing: 0){
                    
                    Text("Source")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 20)
                        .padding(.bottom, -15)
                    
                    TextField("Enter Source Name", text: $source)
                        .font(.title2)
                        .frame(height: 50)
                        .padding()
                        .background(Color("GlassArea"))
                        .background(.ultraThinMaterial)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(20)
                        .padding()
                }
                .foregroundColor(colorScheme == .light ? Color("LText") : .white)
                // Source VStack
                
                // Save button
                Button{
                    saveData() // Function that saves Data into the firestore database
                }label: {
                    Text("Add Fact")
                        .foregroundColor(colorScheme == .dark ? .white : Color("LText"))
                        .padding()
                        .font(.title2)
                        .frame(width: 200, height: 70)
                        .background(Color("GlassArea"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .alert(isPresented: $showAlert){
                    Alert(
                        title: Text("Attention"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("Got it"))
                    )
                }
                // Save button END
                
            }
        }
    }
    
    func loadBadWordsFromFile() -> [String]? {
        if let path = Bundle.main.path(forResource: "isValidWord", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: path, encoding: .utf8)
                return contents.components(separatedBy: .newlines)
            } catch {
                print("Error reading bad words file: \(error)")
            }
        }
        return nil
    }
    
    
    // MARK: Save function
    private func saveData(){
        
        if category.isEmpty || fact.isEmpty {
            showAlert(message: "Your input is important. Fill all the required fields to complete the process.")
            return
        }
//        Bad Word Filtering
        if let badWord = loadBadWordsFromFile() {
            for word in badWord{
                if fact.lowercased().contains(word){
                    showAlert(message: "Please avoid using inappropriate language.")
                    return
                }
            }
        }
        
        let newFact = FactModel(fact: fact, category: category, source: source)
        savedFacts.append(newFact)
        
        do{
            let db = Firestore.firestore()
            try db.collection("facts").addDocument(from: newFact)
        }catch let error{
            print("There was a problem to save a data \(error)")
        }
        
        fact = ""
        category = ""
        source = ""
    }
    
    
    private func showAlert(message: String) {
        showAlert = true
        alertMessage = message
    }
}

#Preview{
    AddView()
}

