import SwiftUI

struct UserListView: View {
    @State private var users: [User] = []
    @State private var isLoading = true
    @State private var showingAddUser = false
    @State private var editingUser: User?
    @State private var showActionSheet = false
    @State private var selectedUserForAction: User?

    var body: some View {
        NavigationView {
            ZStack {
                Color.green.edgesIgnoringSafeArea(.all)

                VStack {
                    if isLoading {
                        ProgressView("Loading users...")
                            .foregroundColor(.white)
                    } else if users.isEmpty {
                        Text("No users available")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top, 50)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(users, id: \.id) { user in
                                    HStack {
                                        // Pencil Button for Actions (Top Left)
                                        Button(action: {
                                            selectedUserForAction = user
                                            showActionSheet = true
                                        }) {
                                            Image(systemName: "pencil")
                                                .foregroundColor(.green)
                                                .padding(10)
                                                .background(Circle().fill(Color.white))
                                        }

                                        // User Card (Navigates to UserDetailsTabView)
                                        NavigationLink(
                                            destination: UserDetailsTabView(userID: user.id, userName: user.name)
                                        ) {
                                            UserCardView(user: user)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Add User button
                    Button(action: { showingAddUser = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(Color.green.opacity(0.8)))
                    }
                }
            }
            // Add new user
            .sheet(isPresented: $showingAddUser) {
                UserFormView { newUser in
                    addUser(newUser)
                }
            }
            // Edit user details
            .sheet(item: $editingUser) { user in
                UserFormView(user: user) { updatedUser in
                    updateUser(updatedUser)
                }
            }
            // Action Sheet for Update/Delete
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Manage User"),
                    message: Text("What would you like to do?"),
                    buttons: [
                        .default(Text("Edit")) {
                            if let user = selectedUserForAction {
                                editingUser = user
                            }
                        },
                        .destructive(Text("Delete")) {
                            if let user = selectedUserForAction {
                                deleteUser(user)
                            }
                        },
                        .cancel()
                    ]
                )
            }
            .onAppear(perform: loadUsers)
        }
    }

    // Load all users from the backend
    private func loadUsers() {
        isLoading = true
        UserService.shared.fetchUsers { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetchedUsers):
                    users = fetchedUsers
                case .failure(let error):
                    print("Error loading users: \(error.localizedDescription)")
                }
            }
        }
    }

    // Add a new user
    private func addUser(_ user: User) {
        UserService.shared.addUser(user: user) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    loadUsers() // Refresh the user list
                case .failure(let error):
                    print("Error adding user: \(error.localizedDescription)")
                }
            }
        }
    }

    // Update an existing user
    private func updateUser(_ user: User) {
        UserService.shared.updateUser(user: user) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    loadUsers() // Refresh the user list
                case .failure(let error):
                    print("Error updating user: \(error.localizedDescription)")
                }
            }
        }
    }

    // Delete a user
    private func deleteUser(_ user: User) {
        UserService.shared.deleteUser(userID: user.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    users.removeAll { $0.id == user.id } // Remove the user from the local array
                case .failure(let error):
                    print("Error deleting user: \(error.localizedDescription)")
                }
            }
        }
    }
}
