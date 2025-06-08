import SwiftUI

struct FavoriteCard: View {
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
            
            Text("$\(product.price, specifier: "%.2f")")
                .font(.headline)
                .fontWeight(.bold)
            
            Button(action: {
                viewModel.toggleFavorite(product.id)
            }) {
                HStack {
                    Image(systemName: "heart.slash")
                    Text("Remove")
                }
                .font(.caption)
                .foregroundColor(.red)
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
