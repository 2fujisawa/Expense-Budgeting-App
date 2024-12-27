import SwiftUI

struct CategoryView: View {
    @State private var categories: [Category] = []
    @State private var showingAddCategory = false
    @State private var isLoading = true

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all) // Background color

            VStack {
                // Title
                Text("Categories")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()

                if isLoading {
                    ProgressView("Loading categories...")
                        .foregroundColor(.gray)
                } else if categories.isEmpty {
                    Text("No categories available.")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(categories, id: \.id) { category in
                            CategoryCardView(category: category)
                        }
                        .onDelete(perform: deleteCategory) // Swipe-to-delete
                    }
                    .listStyle(InsetGroupedListStyle())
                }

                Spacer()

                // Add Category Button
                Button(action: {
                    showingAddCategory = true
                }) {
                    Text("Add Category")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView(categories: $categories)
        }
        .onAppear {
            loadCategories()
        }
    }

    private func loadCategories() {
        isLoading = true
        CategoryService.shared.fetchCategories { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetchedCategories):
                    categories = fetchedCategories
                case .failure(let error):
                    print("Error fetching categories: \(error.localizedDescription)")
                }
            }
        }
    }

    private func deleteCategory(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let categoryID = categories[index].id

        CategoryService.shared.deleteCategory(categoryID: categoryID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    categories.remove(atOffsets: offsets) // Remove from list
                case .failure(let error):
                    print("Error deleting category: \(error.localizedDescription)")
                }
            }
        }
    }
}
