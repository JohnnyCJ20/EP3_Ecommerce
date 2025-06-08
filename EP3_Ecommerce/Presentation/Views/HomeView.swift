import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.products) { product in
                        ProductCard(product: product)
                    }
                }
                .padding()
            }
            .navigationTitle("Products")
        }
    }
}
