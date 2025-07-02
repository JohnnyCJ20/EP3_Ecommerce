import SwiftUI

struct CartView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var showingCheckoutAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.cartItems.isEmpty {
                    EmptyCartView()
                } else {
                    VStack {
                        // Lista de productos en el carrito
                        List {
                            ForEach(viewModel.cartItems, id: \.product.id) { cartItem in
                                CartItemRow(
                                    cartItem: cartItem,
                                    onQuantityChange: { newQuantity in
                                        viewModel.updateCartItemQuantity(cartItem.product, quantity: newQuantity)
                                    },
                                    onRemove: {
                                        viewModel.removeFromCart(cartItem.product)
                                    }
                                )
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(PlainListStyle())
                        
                        // Resumen del total
                        VStack(spacing: 16) {
                            Divider()
                            
                            HStack {
                                Text("Total de items:")
                                    .font(.subheadline)
                                Spacer()
                                Text("\(viewModel.cartItemCount)")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Text("Total:")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                                Text("$\(viewModel.cartTotal, specifier: "%.2f")")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            
                                                        // Botones de acción
                            HStack(spacing: 12) {
                                Button("Limpiar Carrito") {
                                    viewModel.clearCart()
                                }
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.red, lineWidth: 1)
                                )
                                
                                Button("Procesar Compra") {
                                    showingCheckoutAlert = true
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.blue)
                                )
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                    }
                }
            }
            .navigationTitle("Carrito")
            .navigationBarTitleDisplayMode(.large)
            .alert("Compra Procesada", isPresented: $showingCheckoutAlert) {
                Button("OK") {
                    viewModel.clearCart()
                }
            } message: {
                Text("¡Gracias por tu compra! Tu pedido ha sido procesado exitosamente.")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            let cartItem = viewModel.cartItems[index]
            viewModel.removeFromCart(cartItem.product)
        }
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("Tu carrito está vacío")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Agrega algunos productos para comenzar")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
