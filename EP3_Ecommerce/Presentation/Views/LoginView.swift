import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 40)
                
                Button(action: {
                    isLoggedIn = true
                }) {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 40)
                
                Button("Sign up") {
                    // Sign up action
                }
                .foregroundColor(.black)
                
                Spacer()
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                MainTabView()
                    .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    LoginView()
}
