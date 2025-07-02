import SwiftUI

struct CartItemRow: View {
    let cartItem: CartItem
    let onQuantityChange: (Int) -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Imagen del producto
            AsyncImage(url: URL(string: cartItem.product.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 80, height: 80)
            .clipped()
            .cornerRadius(8)
            
            // Información del producto
            VStack(alignment: .leading, spacing: 4) {
                Text(cartItem.product.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text("$\(cartItem.product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                
                // Controles de cantidad
                HStack {
                    Button(action: {
                        onQuantityChange(max(1, cartItem.quantity - 1))
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                            .font(.title2)
                    }
                    
                    Text("\(cartItem.quantity)")
                        .font(.headline)
                        .frame(minWidth: 30)
                    
                    Button(action: {
                        onQuantityChange(cartItem.quantity + 1)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                    }
                }
            }
            
            Spacer()
            
            // Subtotal y botón eliminar
            VStack(alignment: .trailing, spacing: 8) {
                Text("$\(Double(cartItem.quantity) * cartItem.product.price, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Button(action: onRemove) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
