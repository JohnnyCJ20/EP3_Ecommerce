import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var favorites: Set<Int> = []
    @Published var cartItems: [CartItem] = []
    
    let products: [Product] = MockData.products
    
    func toggleFavorite(_ productId: Int) {
        if favorites.contains(productId) {
            favorites.remove(productId)
        } else {
            favorites.insert(productId)
        }
    }
    
    func addToCart(_ product: Product) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(CartItem(product: product))
        }
    }
    
    func removeFromCart(_ cartItem: CartItem) {
        cartItems.removeAll { $0.id == cartItem.id }
    }
    
    func updateQuantity(_ cartItem: CartItem, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == cartItem.id }) {
            if quantity > 0 {
                cartItems[index].quantity = quantity
            } else {
                removeFromCart(cartItem)
            }
        }
    }
    
    var totalAmount: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    var favoriteProducts: [Product] {
        products.filter { favorites.contains($0.id) }
    }
}
