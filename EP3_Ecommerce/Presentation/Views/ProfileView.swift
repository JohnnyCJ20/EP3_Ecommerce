import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.gray)
                
                Text("User Profile")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    ProfileRow(title: "Name", value: "John Doe")
                    ProfileRow(title: "Email", value: "john.doe@example.com")
                    ProfileRow(title: "Phone", value: "+1 234 567 8900")
                }
                .padding()
                
                Button("Logout") {
                    // Logout action
                }
                .foregroundColor(.red)
                .padding()
                
                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}
