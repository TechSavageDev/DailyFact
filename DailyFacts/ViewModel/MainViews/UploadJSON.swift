import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

struct UploadJSON: View {
    
    @State private var isShowingPicker = false
    @State private var selectedURL: URL?
    @State private var showAlert = false
    @State private var documentCount = 0
    @State private var isUploading = false
    @State private var progress: Double = 0.0
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                
                VStack{
                    
                    Text("Bulk upload")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        
                    Text("Choose your JSON file to upload")
                        .font(.title3)
                        
                }
                
                Spacer()
                
                if isUploading {
                    ProgressBar(value: $progress)
                        .frame(height: 10)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 40)
                } else {
                    
                    Button {
                        isShowingPicker = true
                    } label: {
                        Image(systemName: "square.and.arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color("LText"))
                    }
                    .sheet(isPresented: $isShowingPicker, onDismiss: {
                        if let selectedURL = selectedURL {
                            uploadDataToFirestore(from: selectedURL)
                        }
                    }) {
                        DocumentPickerView(selectedURL: $selectedURL)
                    }
                }
                Spacer()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("🎉 Success"), message: Text("\(documentCount) documents uploaded\n😉"), dismissButton: .default(Text("Done")))
        }
    }

//     Upload JSON file to Firestore Database
    private func uploadDataToFirestore(from fileURL: URL) {
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [[String: Any]]
            
            let db = Firestore.firestore()
            let collectionRef = db.collection("facts")
            
            isUploading = true // Start uploading
            progress = 0.0 // Reset progress
            
            for (index, json) in jsonArray.enumerated() {
                collectionRef.addDocument(data: json) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        documentCount += 1
                        print("Document added \(documentCount)")
                        
                        // Update progress based on the number of documents uploaded
                        progress = Double(index + 1) / Double(jsonArray.count)
                        
                        if documentCount == jsonArray.count {
                            showAlert = true // All documents uploaded, show alert
                            isUploading = false // Stop uploading
                        }
                    }
                }
            }
        } catch {
            print("Error decoding JSON data: \(error)")
        }
    }
}

#Preview {
    UploadJSON()
}
