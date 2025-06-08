import SwiftUI

struct CartView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.cartItems.isEmpty {
                    VStack {
                        Image(systemName: "cart")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("Your cart is empty")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.cartItems) { cartItem in
                            CartItemRow(cartItem: cartItem)
                        }
                    }
                    
                    VStack {
                        HStack {
                            Text("Total: $\(viewModel.totalAmount, specifier: "%.2f")")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding()
                        
                        Button(action: {
                            // Pay now action (visual only)
                        }) {
                            Text("Pay Now")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    .background(Color(UIColor.systemBackground))
                }
            }
            .navigationTitle("Cart")
        }
    }
}
