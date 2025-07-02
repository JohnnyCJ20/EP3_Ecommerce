import SwiftUI

struct FavoriteListView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.favorites.isEmpty {
                    EmptyFavoritesView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.favorites) { product in
                                FavoriteCard(
                                    product: product,
                                    onRemoveFromFavorites: {
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
            .navigationTitle("Favoritos")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("No tienes favoritos")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Marca productos como favoritos para verlos aquí")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
