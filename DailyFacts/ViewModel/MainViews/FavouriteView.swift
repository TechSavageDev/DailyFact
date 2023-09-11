import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FavouriteView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var userEmail: String = "UserEmail" // Default value
    @State private var userName: String = "Username"
    
    @State var isBounce: CGFloat = 200
    @State var isRotate: Double = 0.0
    @State var yOffsetbottomCircle: CGFloat = 0
    @State var xOffsetTopCircle: CGFloat = 0
    @State var yOffsetTopCircle: CGFloat = 0
    @State var xOffsetBottomopCircle: CGFloat = 0
    
    @State private var isMenuOpen = false
    @State private var swipedFactIndex: Int?
    
    @State private var favoriteFacts: [FactModel] = []
    
    var body: some View {
        let color = Gradient(colors: [.red, .yellow, .green, .blue, .purple, .cyan, .indigo, .mint, .pink, .teal, .orange, .red])
        let gradient = AngularGradient(gradient: color, center: .center) // Constant for Cirlce gradient
        
        // To make view navigate to other screens add NavigationView { ... }
        // And write the rest of the code in curly braces
        // Example if you want that gear navigates to other View than you need to add a NavigationView
        
        
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
            // Rotation Effect
            .onAppear{
                withAnimation(.linear(duration: 7).repeatForever(autoreverses: false)){
                    isRotate = 360.0
                }
            }
            // Group of Circles END
            
            VStack{
                // Header VStack
                HStack(alignment: .top) {
                    Text("Hello, \(userName)!")
                        .frame(maxWidth: .infinity, alignment:.leading)
                        .font(.title2)
                        .fontWeight(.light)
                    
                    NavigationLink(destination: EmptyView()) {
                            Image(systemName: "gear")
                                .font(.title2)
                                .padding(.trailing)
                                .foregroundColor(Color("LText"))
                    }
                }
                .padding()
                .onAppear(perform: fetchUserData)
                // Header VStack END
                
                ScrollView {
                    ForEach(favoriteFacts.indices, id: \.self) { index in
                        let fact = favoriteFacts[index]
                        ZStack {
                            VStack{
                                HStack{
                                    Text(fact.fact)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.title2)
                                        .foregroundColor(colorScheme == .light ? Color("LText") : .white)
                                    
                                    Button{
                                        deleteFavoriteFact(fact)
                                    }label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(Color("LText"))
                                    }
                                }
                                
                                VStack(alignment: .trailing) {
                                    Text(fact.category)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(colorScheme == .light ? Color("LText").opacity(0.8) : .white)
                                    Text(fact.source)
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
                    }
                    .onAppear{
                        fetchFromUsers()
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
    }
//      Fetching users Email Address from Firebase
    private func fetchUserEmail() {
        if let currentUser = Auth.auth().currentUser {
            self.userEmail = currentUser.email ?? "Email not available"
        } else {
            print("User not authenticated")
        }
    }
    
    //    Fetching suer data to display a name
    private func fetchUserData() {
        if let currentUser = Auth.auth().currentUser {
            let db = Firestore.firestore()
            
            // Replace "users" with the actual collection name where user data is stored
            let userDocRef = db.collection("users").document(currentUser.uid)
            
            userDocRef.getDocument { document, error in
                if let error = error {
                    print("Error fetching user data: \(error)")
                    return
                }
                
                if let document = document, document.exists {
                    if let userData = document.data(),
                       let fullName = userData["fName"] as? String {
                        self.userName = fullName
                    }
                } else {
                    print("User document does not exist")
                }
            }
        } else {
            print("User not authenticated")
        }
    }
    
//      Fetching favourite facts form users collection
    private func fetchFromUsers() {
        if let currentUser = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let userFactRef = db.collection("users").document(currentUser.uid).collection("favorites")
            
            userFactRef.getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user's favorite facts: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No favorite facts found")
                    return
                }
                
                var fetchedFacts: [FactModel] = []
                
                for document in documents {
                    if let data = document.data() as? [String: Any],
                       let fact = data["fact"] as? String,
                       let category = data["category"] as? String,
                       let source = data["source"] as? String {
                        
                        let favoriteFact = FactModel(fact: fact, category: category, source: source)
                        fetchedFacts.append(favoriteFact)
                    }
                }
                
                self.favoriteFacts = fetchedFacts
            }
        } else {
            print("User not authenticated")
        }
    }
    
//      Delete facts from users favourite collection
    private func deleteFavoriteFact(_ fact: FactModel) {
        if let currentUser = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let userFactRef = db.collection("users").document(currentUser.uid).collection("favorites")
            
            // Find the document to delete based on the fact data
            userFactRef.whereField("fact", isEqualTo: fact.fact)
                .whereField("category", isEqualTo: fact.category)
                .whereField("source", isEqualTo: fact.source)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error deleting favorite fact: \(error)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("Favorite fact not found")
                        return
                    }
                    
                    if let documentToDelete = documents.first {
                        userFactRef.document(documentToDelete.documentID).delete { error in
                            if let error = error {
                                print("Error deleting favorite fact document: \(error)")
                            } else {
                                // Fact deleted successfully
                                // You may want to refresh the list of favorite facts after deletion
                                fetchFromUsers()
                            }
                        }
                    } else {
                        print("Favorite fact document not found")
                    }
                }
        } else {
            print("User not authenticated")
        }
    }
}


#Preview {
    FavouriteView()
}
