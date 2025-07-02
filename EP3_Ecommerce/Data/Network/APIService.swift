import Foundation

// Estructura para la respuesta de la API
struct APIResponse: Codable {
    let products: [ProductAPI]
    let total: Int
    let skip: Int
    let limit: Int
}

struct ProductAPI: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String?
    let category: String
    let thumbnail: String
    let images: [String]
}

// Servicio para consumir APIs
class APIService {
    static let shared = APIService()
    private let baseURL = "https://sugary-wool-penguin.glitch.me/products"
    
    private init() {}
    
    // Obtener productos desde la API
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: "\(baseURL)/products") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        
        // Convertir ProductAPI a Product
        return apiResponse.products.map { apiProduct in
            Product(
                id: apiProduct.id,
                name: apiProduct.title,
                description: apiProduct.description,
                price: apiProduct.price,
                imageURL: apiProduct.thumbnail,
                category: apiProduct.category,
                rating: Rating(
                    score: apiProduct.rating,
                    count: Int.random(in: 10...500) // La API no provee count
                ),
                isAvailable: apiProduct.stock > 0
            )
        }
    }
    
    // Buscar productos por categoría
    func fetchProductsByCategory(_ category: String) async throws -> [Product] {
        guard let url = URL(string: "\(baseURL)/products/category/\(category)") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        
        return apiResponse.products.map { apiProduct in
            Product(
                id: apiProduct.id,
                name: apiProduct.title,
                description: apiProduct.description,
                price: apiProduct.price,
                imageURL: apiProduct.thumbnail,
                category: apiProduct.category,
                rating: Rating(
                    score: apiProduct.rating,
                    count: Int.random(in: 10...500)
                ),
                isAvailable: apiProduct.stock > 0
            )
        }
    }
    
    // Obtener categorías disponibles
    func fetchCategories() async throws -> [String] {
        guard let url = URL(string: "\(baseURL)/products/categories") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode([String].self, from: data)
    }
}

// Errores de la API
enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Respuesta inválida del servidor"
        case .noData:
            return "No se recibieron datos"
        }
    }
}
