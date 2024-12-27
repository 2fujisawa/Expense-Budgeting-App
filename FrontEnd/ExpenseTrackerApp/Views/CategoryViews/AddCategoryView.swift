import SwiftUI

struct AddCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var isSaving = false
    @Binding var categories: [Category] // Update the parent view's categories list

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Category Details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Add Category")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            
            Button(action: saveCategory) {
                Text("Save Category")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(isSaving ? Color.gray : Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(isSaving || name.isEmpty)
        }
    }

    private func saveCategory() {
        guard !name.isEmpty else { return }
        isSaving = true
        
        let newCategory = Category(categoryID: 0, name: name, description: description)
        
        CategoryService.shared.addCategory(category: newCategory) { result in
            DispatchQueue.main.async {
                isSaving = false
                switch result {
                case .success(let createdCategory):
                    categories.append(createdCategory)
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    print("Error adding category: \(error.localizedDescription)")
                }
            }
        }
    }
}
