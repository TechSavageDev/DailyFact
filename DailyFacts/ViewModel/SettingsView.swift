//
//  SettingsView.swift
//  DailyFacts
//
//  Created by Genadi C on 19/08/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SettingsView: View {
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var gender: String = ""
    @State private var age: Date
    @State private var password: String = ""
    @State private var selectedImage: UIImage?
    
    @State private var userData: UserData?
    
    
    private var db = Firestore.firestore()
    private var user = Auth.auth().currentUser
    private var storage = Storage.storage().reference()
    
    var body: some View {
        VStack{
            Text("Settings")
                .font(.title)
                .fontWeight(.semibold)
            
            Spacer()
            
            VStack(spacing: 20) {
                
                TextField("Full Name", text: $fullName)
                    .padding()
                    .frame(height: 60)
                    .background(.red)
                    .cornerRadius(10)
                
                TextField("Gender", text: $gender)
                    .padding()
                    .frame(height: 60)
                    .background(.red)
                    .cornerRadius(10)
                
                TextField("Email", text: $email)
                    .padding()
                    .frame(height: 60)
                    .background(.red)
                    .cornerRadius(10)
                
                SecureField("Password", text: $password)
                    .padding()
                    .frame(height: 60)
                    .background(.red)
                    .cornerRadius(10)
                
            }
            .padding()
            
            Spacer()
        }
        
        func fetchUserData() {
            guard let uid = user?.uid else {
                return
            }
            
            db.collection("users").document(uid).getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching user data: \(error)")
                    return
                }
                
                if let data = snapshot?.data() {
                    do {
                        userData = try Firestore.Decoder().decode(UserData.self, from: data)
                        fullName = userData?.fullName ?? ""
                        email = userData?.email ?? ""
                        gender = userData?.gender ?? ""
                    } catch {
                        print("Error decoding user data: \(error)")
                    }
                }
            }
        }
        
        func uploadImageAndUpdateUserData() {
            guard let uid = user?.uid, let selectedImage = selectedImage, let imageData = selectedImage.jpegData(compressionQuality: 0.5) else {
                return
            }
            
            // Upload image to Firebase Storage
            let imageRef = storage.child("user_images/\(uid).jpg")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            imageRef.putData(imageData, metadata: metadata) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error)")
                } else {
                    // Image uploaded successfully, update user data
                    let updatedUserData = UserData(
                        fullName: fullName,
                        email: email,
                        gender: gender,
                        age: age
                    )
                    
                    do {
                        try db.collection("users").document(uid).setData(from: updatedUserData, merge: true)
                    } catch {
                        print("Error updating user data: \(error)")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
