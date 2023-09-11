
import SwiftUI
import Firebase

struct Register: View {
    
        @State private var userName: String = ""
        @State private var email: String = ""
        @State private var password: String = ""
    
    
    var body: some View {
        VStack(spacing: 30) {
                TextField("John Doe", text: $userName)
                TextField("johndoe@gmail.com", text: $email)
                SecureField("••••••••", text: $password)
        }
        .padding()
        
    }
}

#Preview {
    Register()
}
