import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var trailManager = TrailManager()
    @State private var showToDo: Bool = true
    @State private var showLogoutAlert: Bool = false
    @State private var totalDays: Int = 0
    
    private let firestoreService = FirestoreService.shared
    
    private var totalDistance: Int {
        trailManager.completedTrails.reduce(0) { $0 + $1.distance }
    }

    private var totalElevation: Int {
        trailManager.completedTrails.reduce(0) { $0 + $1.elevation }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Logout Menu
                HStack {
                    Spacer()
                    Menu {
                        Button(action: {
                            showLogoutAlert.toggle()
                        }) {
                            Text("Logout")
                                .foregroundColor(.red)
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title)
                            .foregroundColor(Color(hex: "#108932"))
                    }
                }
                .padding(.trailing, 10)

                // Profile Picture and Name
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 90, height: 85)
                    .foregroundColor(Color(hex: "#108932"))

                Text("\(trailManager.userFirstName) \(trailManager.userLastName)")
                    .font(.title2)
                    .fontWeight(.semibold)
                Divider()

                VStack(spacing: 20) {
                    // Trail Statistics
                    HStack {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(hex: "#108932"))
                            Text("To do: \(trailManager.toDoTrails.count)")
                                .font(.subheadline)
                        }
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(Color(hex: "#108932"))
                            Text("Completed: \(trailManager.completedTrails.count)")
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)

                    // Total Metrics
                    VStack(spacing: 20) {
                        Text("Total: \(totalDistance)km")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        HStack() {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(Color(hex: "#108932"))
                                Text("Total: \(totalElevation)m")
                                    .font(.subheadline)
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(Color(hex: "#108932"))
                                Text("Total: \(totalDays) days")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding(.horizontal)
                    Divider()
                }

                //"To Do" and "Completed" lists
                HStack {
                    Button(action: {
                        showToDo = true
                    }) {
                        Text("To Do")
                            .fontWeight(.semibold)
                            .padding()
                            .background(showToDo ? Color(hex: "#108932") : Color.gray.opacity(0.2))
                            .foregroundColor(showToDo ? .white : .black)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        showToDo = false
                    }) {
                        Text("Completed")
                            .fontWeight(.semibold)
                            .padding()
                            .background(!showToDo ? Color(hex: "#108932") : Color.gray.opacity(0.2))
                            .foregroundColor(!showToDo ? .white : .black)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)

                // List of Trails
                if showToDo {
                    List(trailManager.toDoTrails) { trail in
                        NavigationLink(destination: TrailDetailView(trail: trail, languageManager: languageManager)) {
                            HStack {
                                Image(trail.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                Text(trail.name[languageManager.selectedLanguage] ?? trail.name["en"]!)
                                    .font(.headline)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    List(trailManager.completedTrails) { trail in
                        NavigationLink(destination: TrailDetailView(trail: trail, languageManager: languageManager)) {
                            HStack {
                                Image(trail.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                Text(trail.name[languageManager.selectedLanguage] ?? trail.name["en"]!)
                                    .font(.headline)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }

                Spacer()
            }
            .onAppear {
                if let userId = Auth.auth().currentUser?.uid {
                    firestoreService.calculateTotalDaysForUser(userId: userId) { days in
                        self.totalDays = days
                    }
                    trailManager.fetchData(userId: userId)
                }
            }
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to log out?"),
                    primaryButton: .destructive(Text("Logout")) {
                        logOut()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    private func logOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false // Update login state to false
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true))
            .environmentObject(LanguageManager())
    }
}
