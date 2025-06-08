import SwiftUI

struct CartItemRow: View {
    let cartItem: CartItem
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: cartItem.product.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 60, height: 60)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(cartItem.product.title)
                    .font(.caption)
                    .lineLimit(2)
                
                Text("$\(cartItem.product.price, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            VStack {
                HStack {
                    Button(action: {
                        viewModel.updateQuantity(cartItem, quantity: cartItem.quantity - 1)
                    }) {
                        Image(systemName: "minus")
                            .foregroundColor(.blue)
                    }
                    
                    Text("\(cartItem.quantity)")
                        .font(.headline)
                        .frame(minWidth: 30)
                    
                    Button(action: {
                        viewModel.updateQuantity(cartItem, quantity: cartItem.quantity + 1)
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
                
                Button(action: {
                    viewModel.removeFromCart(cartItem)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .padding(.top, 5)
            }
        }
        .padding(.vertical, 5)
    }
}
