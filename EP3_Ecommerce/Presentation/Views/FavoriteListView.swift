import SwiftUI

struct FavoriteListView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.favoriteProducts.isEmpty {
                    VStack {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No favorites yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 100)
                } else {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.favoriteProducts) { product in
                            FavoriteCard(product: product)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
