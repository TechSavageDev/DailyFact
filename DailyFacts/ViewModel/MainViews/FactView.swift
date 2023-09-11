//
//  FactView.swift
//  DailyFacts
//
//  Created by Genadi C on 11/08/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct FactView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    //     Animation effect variables
    @State var clockRotate: Double = 0.0
    @State var bounceDistance: CGFloat = 200 // Bouncing Value
    @State var isRotate: Double = 0.0 // Rotation Effect
    @State var yOffsetTopCircle: CGFloat = 0 // For moving effect on Y scale
    @State var xOffsetTopCircle: CGFloat = 0 // For moving effect on X scale
    @State var yOffsetBottomCircle: CGFloat = 0 // For moving effect on Y scale
    @State var xOffsetBottomCircle: CGFloat = 0 // For moving effect on X scale
    
    //     Property variables
    @State private var showFactIDs: Set<String> = []
    @State private var itemFact: String = ""
    @State private var itemCategory: String = ""
    @State private var itemSource: String = ""
    @State private var itemID: String = ""
    
    //     Fetched user variables
    @State private var userName: String = ""
    @State private var fName: String = ""
    @State private var currentUserUID: String = ""
    @State private var userUID: String = ""
    
    //     Variables for Comment Seciton
    @State private var comments: [String] = []
    @State private var userComment: String = ""
    @State private var isShowingCommentsSheet = false
    
    //    Alert variables
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    @State private var title: String = ""
    
    //     Variables for like section
    @State private var isFactLiked: Bool = false
    
    var body: some View {
        
        
        //         Main stack
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
            
            //             Main Vstack
            VStack {
                VStack{
                    //                     Category & Source Vstack
                    VStack(alignment: .leading){
                        if itemCategory != "" {
                            Text(itemCategory)
                                .font(.title)
                                .fontWeight(.bold)
                        }else{
                            Text(" ")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        if itemSource != "" {
                            Text(itemSource)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        else{
                            Text(" ")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                    .foregroundColor(colorScheme == .light ? Color("LText") : .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    //                     Category & Source VStack END
                    
                    //                     Fact Group
                    VStack(alignment: .trailing) {
                        ScrollView{
                            if itemFact != "" {
                                VStack {
                                    withAnimation{
                                        Text(itemFact)
                                    }
                                }
                                .onAppear{
                                    withAnimation{
                                        fetchCurrentUserUID()
                                    }
                                }
                            }else{
                                VStack{
                                    Text("Loading...")
                                    Image(systemName: "hourglass")
                                        .rotationEffect(Angle.degrees(clockRotate))
                                        .onAppear{
                                            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: false)){
                                                clockRotate = 180
                                            }
                                        }
                                }
                                .font(.largeTitle)
                            }
                        }
                        .padding(.top, 50)
                        .padding(.horizontal)
                        .font(.title2)
                        .fontWeight(.regular)
                        .foregroundColor(colorScheme == .light ? Color("LText") : .white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 400)
                        .background(Color("GlassArea"))
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .padding()
                        .transition(.opacity)
                        .onAppear{
                            fetchItemData()
                            isFactLiked = false
                        }
                        
                        HStack(spacing: 10){
                            Button{
                                if isFactAvailable {
                                    isFactLiked = true
                                    addFactToFavorites()
                                } else {
                                    // Fact is not available, so you can choose to show an alert or handle it in any other way.s
                                    showAlert(header: "Opps!", message: "There is no fact to like.")
                                }
                            } label: {
                                Image(systemName: isFactLiked ? "heart.fill" : "heart")
                                    .foregroundColor(isFactLiked ? .red : colorScheme == .light ? Color("LText") : .white)
                            }
                            
                            
                            
                            Button{
                                fetchComments()
                                isShowingCommentsSheet.toggle()
                            } label: {
                                Image(systemName: "message")
                                    .foregroundColor(Color("LText"))
                            }
                            .sheet(isPresented: $isShowingCommentsSheet){
                                
                                VStack {
                                    
                                    HStack{
                                        Text("Comments")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .padding()
                                        
                                        Spacer()
                                        
                                        Button{
                                            isShowingCommentsSheet.toggle()
                                        }label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.title)
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                    }
                                    
                                    ScrollView {
                                        ForEach(comments, id: \.self) { comment in
                                            VStack(alignment: .leading){
                                                HStack{
                                                    Image(systemName: "person.circle")
                                                    
                                                    if let userName = comment.extractUserName() {
                                                        Text(userName)
                                                            .font(.headline)
                                                    }
                                                }
                                                
                                                if let commentText = comment.extractComment(){
                                                    Text(commentText)
                                                        .font(.title3)
                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    HStack{
                                        TextField("Write a comment", text: $userComment, axis: .vertical)
                                            .textFieldStyle(.plain)
                                            .font(.title2)
                                        
                                        
                                        Button {
                                            submitComment()
                                            isShowingCommentsSheet = false
                                        }label: {
                                            Image(systemName: "paperplane")
                                                .foregroundColor(Color("LText"))
                                                .font(.title2)
                                        }
                                        .padding(.trailing, 15)
                                    }
                                    .padding()
                                }
                            }
                            
                            Button{
                                shareFact()
                            } label: {
                                Image(systemName: "paperplane")
                                    .foregroundColor(colorScheme == .light ? Color("LText") : .white)
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.bottom)
                        .font(.title)
                        
                    }
                    //                     Fact Group END
                }
                
                //                 Fetch Button
                Button{
                    withAnimation{
                        fetchItemData()
                        isFactLiked = false
                        print(itemID)
                    }
                }label: {
                    Text("Update Fact")
                        .foregroundColor(colorScheme == .light ? Color("LText") : .white)
                        .padding()
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(width: 200, height: 80)
                        .background(Color("GlassArea"))
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }
                //                 Fetch Button END
                Spacer()
            }
            //             Main VStack END
        }
        .alert(isPresented: $showAlert){
            Alert(
                title: Text(title),
                message: Text(alertMessage),
                dismissButton: .default(Text("Got it"))
            )
        }
        //         Main stack END
    }
    
    //         Data Fetch funciton
    private func fetchItemData(){
        let db = Firestore.firestore() // Connection to firestore
        let collecitonRef = db.collection("facts") // Refference to Collection
        
        collecitonRef.getDocuments { (snap, error) in
            if let error = error{ // Checking on error
                print("Error Fetching Data \(error)")
                return
            }
            
            guard let documents = snap?.documents else { // Attempts to extract document from the snap object
                print("No documents found") // If documnets is nil than print
                return
            }
            
            let availableDocuments = documents.filter{ document in
                guard let itemID = document.data()["id"] as? String else{
                    return false
                }
                return !showFactIDs.contains(itemID)
            }
            
            if let randomDocument = availableDocuments.randomElement(),
               let itemFact = randomDocument.data()["fact"] as? String,
               let itemCategory = randomDocument.data()["category"] as? String,
               let itemSource = randomDocument.data()["source"] as? String,
               let itemID = randomDocument.data()["id"] as? String{
                
                self.itemFact = itemFact
                self.itemCategory = itemCategory
                self.itemSource = itemSource
                self.itemID = itemID
                
            } else {
                showFactIDs.removeAll()
                self.itemFact = "Fact not found"
                self.itemCategory = "Category not found"
                self.itemSource = "Source not found"
                self.itemID = "ID not found"
            }
        }
    }
    
    private func isFactInFavorites() {
        let db = Firestore.firestore()
        let userFactRef = db.collection("users").document(currentUserUID).collection("favorites")
        
        userFactRef.whereField("id", isEqualTo: itemID).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking for existing fact: \(error)")
                return
            }
            
            if let documents = snapshot?.documents, !documents.isEmpty {
                // Fact is in favorites
                isFactLiked = true
            } else {
                // Fact is not in favorites
                isFactLiked = false
            }
        }
    }

    
    private func isFactAlreadyInFavorites(_ factID: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let userFactRef = db.collection("users").document(currentUserUID).collection("favorites")
        
        userFactRef.whereField("id", isEqualTo: factID).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking for existing fact: \(error)")
                completion(false)
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(false) // Fact is not in favorites
                return
            }
            
            completion(true) // Fact is already in favorites
        }
    }
    
    //         Add to Favourite function
    private func addFactToFavorites() {
        isFactAlreadyInFavorites(itemID) { alreadyInFavorites in
            if alreadyInFavorites {
                // Fact is already in favorites, show the alert
                showAlert(header: "Oopps!",message: "Can't add this fact to favourite\nReason: Already in favourites")
                
            } else {
                // Fact is not in favorites, add it
                let db = Firestore.firestore()
                let userFactRef = db.collection("users").document(currentUserUID).collection("favorites")
                
                let factData: [String: Any] = [
                    "fact": itemFact,
                    "category": itemCategory,
                    "source": itemSource,
                    "id": itemID
                ]
                
                userFactRef.addDocument(data: factData) { error in
                    if let error = error {
                        print("Error adding fact to favorites: \(error)")
                    } else {
                        print("Fact added to favorites successfully")
                    }
                }
            }
        }
    }
    
    //         Fetch User Email function
    private func fetchCurrentUserUID() {
        if let currentUser = Auth.auth().currentUser {
            self.currentUserUID = currentUser.uid
            fetchUserData() // Fetch user's full name
            fetchItemData() // Call fetchItemData here to get the fact after UID is available
        } else {
            print("User not authenticated")
        }
    }
    
    //         Fetching user data to display name
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
                        self.userName = fullName // Store the user's full name
                        self.fName = fullName // Also store the user's full name in fName
                    }
                } else {
                    print("User document does not exist")
                }
            }
        } else {
            print("User not authenticated")
        }
    }
    
    //         Comment Sheet
    private func fetchComments() {
        let db = Firestore.firestore()
        let commentsRef = db.collection("comments")
        
        commentsRef.whereField("factID", isEqualTo: itemID).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching comments: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No comments found")
                return
            }
            
            comments = documents.compactMap { document in
                if let comment = document.data()["comment"] as? String,
                   let userName = document.data()["fName"] as? String {
                    return "\(userName)|\(comment)" // Combine username and comment with a separator
                }
                return nil
            }
        }
    }
    
    //         Submit Comments func
    private func submitComment() {
        guard !userComment.isEmpty || userName.isEmpty else { return } // Change userUID to userName
        
        let db = Firestore.firestore()
        let commentsRef = db.collection("comments")
        
        // fetchUserData() is called to get the user's name
        fetchUserData()
        
        let commentData: [String: Any] = [
            "factID": itemID,
            "comment": userComment,
            "userUID": currentUserUID,
            "fName": userName
        ]
        
        commentsRef.addDocument(data: commentData) { error in
            if let error = error {
                print("Error adding comment: \(error)")
            } else {
                showAlert(header: "Yayy!",message: "Comment Added succesfully")
                print("Comment added successfully")
                userComment = "" // Clear the text field after submission
            }
        }
    }
    
    //         Share Fact
    func shareFact() {
        let factToShare = "\(itemFact)"
        
        let shareController = UIActivityViewController(activityItems: [factToShare], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(shareController, animated: true, completion: nil)
        }
    }
    
    //         Alert function
    private func showAlert(header: String, message: String){
        showAlert = true
        title = header
        alertMessage = message
    }
    
    //         If Fact Field is not empty
    private var isFactAvailable: Bool {
        return !itemFact.isEmpty && itemCategory != "Fact not found" && itemSource != "Source not found" && itemID != "ID not found"
    }

}
// Function that extracts username from fetchComments() func
extension String {
    func extractUserName() -> String? {
        let components = self.components(separatedBy: "|")
        return components.first
    }
    
    func extractComment() -> String? {
        let components = self.components(separatedBy: "|")
        return components.last
    }
}


#Preview {
    FactView()
}
