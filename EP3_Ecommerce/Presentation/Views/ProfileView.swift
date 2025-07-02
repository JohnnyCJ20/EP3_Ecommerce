import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Header del perfil
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text(viewModel.currentUser)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Usuario activo")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 20)
                
                // Estadísticas
                HStack(spacing: 30) {
                    StatisticView(
                        title: "Favoritos",
                        value: "\(viewModel.favorites.count)",
                        icon: "heart.fill",
                        color: .red
                    )
                    
                    StatisticView(
                        title: "En Carrito",
                        value: "\(viewModel.cartItemCount)",
                        icon: "cart.fill",
                        color: .blue
                    )
                    
                    StatisticView(
                        title: "Total",
                        value: "$\(viewModel.cartTotal, specifier: "%.0f")",
                        icon: "dollarsign.circle.fill",
                        color: .green
                    )
                }
                .padding(.vertical, 20)
                
                // Configuraciones
                VStack(spacing: 0) {
                    ProfileRow(
                        title: "Fuente de Datos",
                        value: viewModel.isUsingAPIData ? "API Online" : "Local",
                        icon: viewModel.isUsingAPIData ? "cloud.fill" : "internaldrive",
                        action: {
                            Task {
                                if viewModel.isUsingAPIData {
                                    viewModel.loadMockData()
                                } else {
                                    await viewModel.loadProductsFromAPI()
                                }
                            }
                        }
                    )
                    
                    Divider()
                    
                    ProfileRow(
                        title: "Limpiar Favoritos",
                        value: "",
                        icon: "heart.slash",
                        action: {
                            // Limpiar todos los favoritos
                            for favorite in viewModel.favorites {
                                viewModel.toggleFavorite(favorite)
                            }
                        }
                    )
                    
                    Divider()
                    
                    ProfileRow(
                        title: "Limpiar Carrito",
                        value: "",
                        icon: "cart.badge.minus",
                        action: {
                            viewModel.clearCart()
                        }
                    )
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding()
                
                Spacer()
                
                // Botón de logout
                Button(action: {
                    showingLogoutAlert = true
                }) {
                    Text("Cerrar Sesión")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.gray.opacity(0.1))
            .alert("Cerrar Sesión", isPresented: $showingLogoutAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Cerrar Sesión", role: .destructive) {
                    viewModel.logout()
                }
            } message: {
                Text("¿Estás seguro de que deseas cerrar sesión?")
            }
        }
    }
}

struct StatisticView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
