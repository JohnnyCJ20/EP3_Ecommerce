import SwiftUI

struct ProductCard: View {
    let product: Product
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: product.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(1, contentMode: .fit)
            }
            .frame(height: 120)
            .clipped()
            
            Text(product.title)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Text("$\(product.price, specifier: "%.2f")")
                .font(.headline)
                .fontWeight(.bold)
            
            HStack {
                Button(action: {
                    viewModel.toggleFavorite(product.id)
                }) {
                    Image(systemName: viewModel.favorites.contains(product.id) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.favorites.contains(product.id) ? .red : .gray)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.addToCart(product)
                }) {
                    Image(systemName: "cart.badge.plus")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
