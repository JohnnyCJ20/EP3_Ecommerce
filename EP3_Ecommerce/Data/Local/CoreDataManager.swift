import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShoppingApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error al guardar: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Favorites Management
    func saveFavorite(_ product: Product) {
        let favorite = FavoriteProduct(context: context)
        favorite.id = Int32(product.id)
        favorite.name = product.name
        favorite.productDescription = product.description
        favorite.price = product.price
        favorite.imageURL = product.imageURL
        favorite.category = product.category
        favorite.rating = product.rating.score
        favorite.dateAdded = Date()
        
        saveContext()
    }
    
    func removeFavorite(productId: Int) {
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", productId)
        
        do {
            let favorites = try context.fetch(request)
            for favorite in favorites {
                context.delete(favorite)
            }
            saveContext()
        } catch {
            print("Error al eliminar favorito: \(error.localizedDescription)")
        }
    }
    
    func fetchFavorites() -> [Product] {
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteProduct.dateAdded, ascending: false)]
        
        do {
            let favorites = try context.fetch(request)
            return favorites.map { favorite in
                Product(
                    id: Int(favorite.id),
                    name: favorite.name ?? "",
                    description: favorite.productDescription ?? "",
                    price: favorite.price,
                    imageURL: favorite.imageURL ?? "",
                    category: favorite.category ?? "",
                    rating: Rating(score: favorite.rating, count: 0),
                    isAvailable: true
                )
            }
        } catch {
            print("Error al obtener favoritos: \(error.localizedDescription)")
            return []
        }
    }
    
    func isFavorite(productId: Int) -> Bool {
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", productId)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
    
    // MARK: - Cart Management
    func saveCartItem(_ cartItem: CartItem) {
        // Verificar si el item ya existe en el carrito
        let request: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "productId == %d", cartItem.product.id)
        
        do {
            let existingItems = try context.fetch(request)
            
            if let existingItem = existingItems.first {
                // Actualizar cantidad
                existingItem.quantity = Int32(cartItem.quantity)
            } else {
                // Crear nuevo item
                let newCartItem = CartItemEntity(context: context)
                newCartItem.productId = Int32(cartItem.product.id)
                newCartItem.productName = cartItem.product.name
                newCartItem.productPrice = cartItem.product.price
                newCartItem.productImageURL = cartItem.product.imageURL
                newCartItem.quantity = Int32(cartItem.quantity)
                newCartItem.dateAdded = Date()
            }
            
            saveContext()
        } catch {
            print("Error al guardar item del carrito: \(error.localizedDescription)")
        }
    }
    
    func removeCartItem(productId: Int) {
        let request: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "productId == %d", productId)
        
        do {
            let items = try context.fetch(request)
            for item in items {
                context.delete(item)
            }
            saveContext()
        } catch {
            print("Error al eliminar item del carrito: \(error.localizedDescription)")
        }
    }
    
    func fetchCartItems() -> [CartItem] {
        let request: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CartItemEntity.dateAdded, ascending: false)]
        
        do {
            let cartItems = try context.fetch(request)
            return cartItems.map { item in
                let product = Product(
                    id: Int(item.productId),
                    name: item.productName ?? "",
                    description: "",
                    price: item.productPrice,
                    imageURL: item.productImageURL ?? "",
                    category: "",
                    rating: Rating(score: 0, count: 0),
                    isAvailable: true
                )
                return CartItem(product: product, quantity: Int(item.quantity))
            }
        } catch {
            print("Error al obtener items del carrito: \(error.localizedDescription)")
            return []
        }
    }
    
    func clearCart() {
        let request: NSFetchRequest<NSFetchRequestResult> = CartItemEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Error al limpiar carrito: \(error.localizedDescription)")
        }
    }
    
    // MARK: - User Preferences
    func saveUserPreference(key: String, value: String) {
        let request: NSFetchRequest<UserPreference> = UserPreference.fetchRequest()
        request.predicate = NSPredicate(format: "key == %@", key)
        
        do {
            let preferences = try context.fetch(request)
            
            if let preference = preferences.first {
                preference.value = value
            } else {
                let newPreference = UserPreference(context: context)
                newPreference.key = key
                newPreference.value = value
            }
            
            saveContext()
        } catch {
            print("Error al guardar preferencia: \(error.localizedDescription)")
        }
    }
    
    func getUserPreference(key: String) -> String? {
        let request: NSFetchRequest<UserPreference> = UserPreference.fetchRequest()
        request.predicate = NSPredicate(format: "key == %@", key)
        
        do {
            let preferences = try context.fetch(request)
            return preferences.first?.value
        } catch {
            print("Error al obtener preferencia: \(error.localizedDescription)")
            return nil
        }
    }
}

