import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var showingLoadingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Header con indicador de fuente de datos
                HStack {
                    VStack(alignment: .leading) {
                        Text("Productos")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: viewModel.isUsingAPIData ? "cloud.fill" : "internaldrive")
                                .foregroundColor(viewModel.isUsingAPIData ? .blue : .gray)
                            Text(viewModel.isUsingAPIData ? "Datos en línea" : "Datos locales")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Botón para recargar desde API
                    Button(action: {
                        Task {
                            await viewModel.loadProductsFromAPI()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.blue)
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding(.horizontal)
                
                // Barra de búsqueda
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                
                // Filtro de categorías
                CategoryFilter(
                    categories: viewModel.categories,
                    selectedCategory: $viewModel.selectedCategory
                )
                
                // Lista de productos
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Cargando productos...")
                        .scaleEffect(1.2)
                    Spacer()
                } else {
                    ProductGrid(products: viewModel.filteredProducts)
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .onAppear {
                // Cargar productos desde API al iniciar
                Task {
                    await viewModel.loadProductsFromAPI()
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar productos...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct CategoryFilter: View {
    let categories: [String]
    @Binding var selectedCategory: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    CategoryButton(
                        title: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                )
        }
    }
}

struct ProductGrid: View {
    let products: [Product]
    @EnvironmentObject var viewModel: AppViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(products) { product in
                    ProductCard(
                        product: product,
                        isFavorite: viewModel.isFavorite(product),
                        onFavoriteToggle: {
                            viewModel.toggleFavorite(product)
                        },
                        onAddToCart: {
                            viewModel.addToCart(product)
                        }
                    )
                }
            }
            .padding()
        }
    }
}
