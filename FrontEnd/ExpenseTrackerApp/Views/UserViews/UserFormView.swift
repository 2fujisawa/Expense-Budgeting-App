import SwiftUI

struct UserFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var age = ""
    @State private var email = ""
    @State private var password = "" // Password for new users only
    var user: User? // Optional user for editing
    var onSave: (User) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Details").font(.headline)) {
                    TextField("Name", text: $name)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                }
                if user == nil {
                    Section(header: Text("Password").font(.headline)) {
                        SecureField("Password", text: $password)
                    }
                }

                Section {
                    Button(action: saveUser) {
                        Text("Save")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle(user == nil ? "Add User" : "Edit User")
            .onAppear {
                if let user = user {
                    name = user.name
                    age = "\(user.age)"
                    email = user.email
                }
            }
        }
    }

    private func saveUser() {
        guard let ageInt = Int(age), !name.isEmpty, !email.isEmpty else {
            print("Validation failed: Missing fields or invalid input")
            return
        }

        let newUser = User(
            id: user?.id ?? 0, // Use existing ID for editing, or 0 for new
            name: name,
            age: ageInt,
            email: email,
            status: "Active"
        )
        onSave(newUser)
        presentationMode.wrappedValue.dismiss()
    }
}
