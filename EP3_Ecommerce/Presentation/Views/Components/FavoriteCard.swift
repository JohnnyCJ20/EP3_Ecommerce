import SwiftUI

struct FavoriteCard: View {
    let product: Product
    let onRemoveFromFavorites: () -> Void
    let onAddToCart: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Imagen del producto
            AsyncImage(url: URL(string: product.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 100, height: 100)
            .clipped()
            .cornerRadius(12)
            
            // Información del producto
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(product.category.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                
                HStack {
                    // Rating
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", product.rating.score))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                // Botones de acción
                HStack(spacing: 8) {
                    Button(action: onAddToCart) {
                        HStack {
                            Image(systemName: "cart.badge.plus")
                            Text("Agregar")
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .cornerRadius(6)
                    }
                    
                    Button(action: onRemoveFromFavorites) {
                        Image(systemName: "heart.slash")
                            .foregroundColor(.red)
                            .font(.title2)
                            .padding(6)
                            .background(
                                Circle()
                                    .stroke(Color.red, lineWidth: 1)
                            )
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

