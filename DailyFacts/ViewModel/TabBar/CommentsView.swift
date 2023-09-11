import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Comment: Identifiable {
    var id = UUID()
    var username: String
    var text: String
    var timestamp: String
}

struct CommentsView: View {
    @State private var comments: [Comment] = []
    @State private var userComment: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(comments) { comment in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 24))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(comment.username)
                                .font(.headline)
                            Text(comment.text)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(comment.timestamp)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            HStack {
                TextField("Add a comment...", text: $userComment, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(.body)
                
                Button(action: {
                    if !userComment.isEmpty {
                        let newComment = Comment(username: "YourUsername", text: userComment, timestamp: "Just now")
                        comments.append(newComment)
                        userComment = ""
                    }
                }) {
                    Text("Post")
                        .font(.headline)
                        .foregroundColor(Color("LText"))
                }
                .padding(.trailing, 8)
            }
            .padding()
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView()
    }
}
