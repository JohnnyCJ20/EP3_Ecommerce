import Foundation
import Combine

@MainActor
class AppViewModel: ObservableObject {
    // Estados existentes
    @Published var isLoggedIn = false
    @Published var currentUser: String = ""
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var favorites: [Product] = []
    @Published var cartItems: [CartItem] = []
    @Published var searchText = ""
    @Published var selectedCategory = "Todos"
    
    // Nuevos estados para servicios web
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var categories: [String] = ["Todos"]
    @Published var isUsingAPIData = false
    
    private let apiService = APIService.shared
    private let coreDataManager = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchBinding()
        loadPersistedData()
    }
    
    // MARK: - API Methods
    func loadProductsFromAPI() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let apiProducts = try await apiService.fetchProducts()
            products = apiProducts
            filteredProducts = apiProducts
            isUsingAPIData = true
            
            // También cargar categorías
            await loadCategoriesFromAPI()
            
        } catch {
            errorMessage = error.localizedDescription
            // Fallback a datos locales
            loadMockData()
        }
        
        isLoading = false
    }
    
    func loadCategoriesFromAPI() async {
        do {
            let apiCategories = try await apiService.fetchCategories()
            categories = ["Todos"] + apiCategories.map { $0.capitalized }
        } catch {
            print("Error al cargar categorías: \(error.localizedDescription)")
        }
    }
    
    func loadProductsByCategory(_ category: String) async {
        guard category != "Todos" && isUsingAPIData else {
            filterProducts()
            return
        }
        
        isLoading = true
        
        do {
            let categoryProducts = try await apiService.fetchProductsByCategory(category.lowercased())
            products = categoryProducts
            filteredProducts = categoryProducts
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Persistence Methods
    func loadPersistedData() {
        // Cargar favoritos desde Core Data
        favorites = coreDataManager.fetchFavorites()
        
        // Cargar items del carrito
        cartItems = coreDataManager.fetchCartItems()
        
        // Cargar preferencia de usuario
        if let savedUser = coreDataManager.getUserPreference(key: "currentUser") {
            currentUser = savedUser
            isLoggedIn = !savedUser.isEmpty
        }
        
        // Si no hay productos cargados, usar datos mock
        if products.isEmpty {
            loadMockData()
        }
    }
    
    func saveUserSession() {
        coreDataManager.saveUserPreference(key: "currentUser", value: currentUser)
    }
    
    // MARK: - Favorites with Persistence
    func toggleFavorite(_ product: Product) {
        if coreDataManager.isFavorite(productId: product.id) {
            // Remover de favoritos
            coreDataManager.removeFavorite(productId: product.id)
            favorites.removeAll { $0.id == product.id }
        } else {
            // Agregar a favoritos
            coreDataManager.saveFavorite(product)
            if !favorites.contains(where: { $0.id == product.id }) {
                favorites.append(product)
            }
        }
    }
    
    func isFavorite(_ product: Product) -> Bool {
        return coreDataManager.isFavorite(productId: product.id)
    }
    
    // MARK: - Cart with Persistence
    func addToCart(_ product: Product, quantity: Int = 1) {
        if let existingIndex = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[existingIndex].quantity += quantity
            coreDataManager.saveCartItem(cartItems[existingIndex])
        } else {
            let newItem = CartItem(product: product, quantity: quantity)
            cartItems.append(newItem)
            coreDataManager.saveCartItem(newItem)
        }
    }
    
    func removeFromCart(_ product: Product) {
        cartItems.removeAll { $0.product.id == product.id }
        coreDataManager.removeCartItem(productId: product.id)
    }
    
    func updateCartItemQuantity(_ product: Product, quantity: Int) {
        if quantity <= 0 {
            removeFromCart(product)
            return
        }
        
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity = quantity
            coreDataManager.saveCartItem(cartItems[index])
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
        coreDataManager.clearCart()
    }
    
    // MARK: - Existing Methods (mantener los métodos que ya tienes)
    func login(username: String, password: String) -> Bool {
        // Tu lógica de login existente
        if !username.isEmpty && !password.isEmpty {
            currentUser = username
            isLoggedIn = true
            saveUserSession() // Persistir sesión
            return true
        }
        return false
    }
    
    func logout() {
        isLoggedIn = false
        currentUser = ""
        coreDataManager.saveUserPreference(key: "currentUser", value: "")
    }
    
    func loadMockData() {
        products = MockData.sampleProducts
        filteredProducts = products
        isUsingAPIData = false
    }
    
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.filterProducts()
            }
            .store(in: &cancellables)
        
        $selectedCategory
            .sink { [weak self] category in
                Task {
                    await self?.loadProductsByCategory(category)
                }
            }
            .store(in: &cancellables)
    }
    
    private func filterProducts() {
        filteredProducts = products.filter { product in
            let matchesSearch = searchText.isEmpty || 
                               product.name.localizedCaseInsensitiveContains(searchText) ||
                               product.description.localizedCaseInsensitiveContains(searchText)
            
            let matchesCategory = selectedCategory == "Todos" || 
                                 product.category.localizedCaseInsensitiveContains(selectedCategory)
            
            return matchesSearch && matchesCategory
        }
    }
    
    // MARK: - Computed Properties
    var cartTotal: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    var cartItemCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
}
