import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TrailDetailView: View {
    let trail: Trail
    @ObservedObject var languageManager: LanguageManager

    // Reference to Firestore database
    let db = Firestore.firestore()

    // Check if the user is logged in
    @State private var userId: String?
    @State private var showLoginAlert = false

    // State variables to track collection membership
    @State private var isInToDoList = false
    @State private var isInCompletedList = false

    init(trail: Trail, languageManager: LanguageManager) {
        self.trail = trail
        self.languageManager = languageManager
        self._userId = State(initialValue: Auth.auth().currentUser?.uid)
    }

    // Function to add or remove the trail from the user's collection (ToDo or Completed)
    func toggleTrailInCollection(collection: String) {
        guard let userId = userId else {
            // If user is not logged in, show alert
            showLoginAlert = true
            return
        }

        let userRef = db.collection("users").document(userId)

        // Check if the trail is already in the collection
        userRef.collection(collection).document(trail.id).getDocument { document, error in
            if let document = document, document.exists {
                // If the trail is already in the collection, remove it
                userRef.collection(collection).document(trail.id).delete { error in
                    if let error = error {
                        print("Error removing trail from \(collection): \(error)")
                    } else {
                        print("Trail successfully removed from \(collection).")
                        // Update the UI state to reflect the change
                        if collection == "toDoTrails" {
                            isInToDoList = false
                        } else if collection == "completedTrails" {
                            isInCompletedList = false
                        }
                    }
                }
            } else {
                // If the trail is not in the collection, add it
                let trailData: [String: Any] = [
                    "name": trail.name[languageManager.selectedLanguage] ?? trail.name["en"]!,
                    "distance": trail.distance,
                    "elevation": trail.elevation,
                    "startingCity": trail.startingCity,
                    "endingCity": trail.endingCity,
                    "description": trail.description[languageManager.selectedLanguage] ?? trail.description["en"]!,
                    "isHike": trail.isHike,
                    "isBike": trail.isBike,
                    "imageName": trail.imageName
                ]
                userRef.collection(collection).document(trail.id).setData(trailData) { error in
                    if let error = error {
                        print("Error adding trail to \(collection): \(error)")
                    } else {
                        print("Trail successfully added to \(collection).")
                        // Update the UI state to reflect the change
                        if collection == "toDoTrails" {
                            isInToDoList = true
                        } else if collection == "completedTrails" {
                            isInCompletedList = true
                        }
                    }
                }
            }
        }
    }

    // Function to check if the trail is already in the collections
    func checkIfTrailIsInCollection() {
        guard let userId = userId else { return }

        let userRef = db.collection("users").document(userId)

        // Check for ToDo Trails
        userRef.collection("toDoTrails").document(trail.id).getDocument { document, error in
            if let document = document, document.exists {
                isInToDoList = true
            }
        }

        // Check for Completed Trails
        userRef.collection("completedTrails").document(trail.id).getDocument { document, error in
            if let document = document, document.exists {
                isInCompletedList = true
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Trail Title and Language Toggle
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(trail.name[languageManager.selectedLanguage] ?? trail.name["en"]!)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("Trudność:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            ForEach(0..<5) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(hex: "#108932"))
                            }
                        }
                        
                        HStack {
                            Text("Ocena:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            ForEach(0..<5) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(hex: "#108932"))
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)

                ZStack {
                    NavigationLink(destination: GalleryView(photos: trail.photos)) {
                        Image(trail.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove navigation link styling

                    HStack {
                        Spacer()
                        NavigationLink(destination: GalleryView(photos: trail.photos)) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove navigation link styling
                    }
                }
                .cornerRadius(10)
                .padding(.horizontal)

                Rectangle()
                    .fill(Color(hex: trail.colorHex))
                    .frame(height: 15)
                    .cornerRadius(3)
                
                VStack {
                    // Route Info
                    HStack(spacing: 16) {
                        HStack {
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(Color(hex: "#108932"))
                                Text(trail.startingCity)
                                    .font(.subheadline)
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.gray)
                                Text(trail.endingCity)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    Text("\(trail.distance)km")
                        .font(.title)
                        .fontWeight(.bold)

                    HStack {
                        HStack {
                            Image(systemName: "arrow.up.right")
                                .foregroundColor(Color(hex: "#108932"))
                            Text("\(trail.elevation) m")
                                .font(.subheadline)
                        }
                        Spacer()
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(Color(hex: "#108932"))
                            Text("20 dni 5h") // You can replace this with dynamic data later
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                }
                Divider()
                
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text(trail.description[languageManager.selectedLanguage] ?? trail.description["en"]!)
                        .font(.body)

                    Text("Ukończony przez: 1234 osoby")
                        .font(.subheadline)
                        .fontWeight(.bold)

                    Text(
                        trail.isHike && trail.isBike ? "Typ: Piesza, Rowerowa" :
                            (trail.isHike ? "Typ: Piesza" :
                                (trail.isBike ? "Typ: Rowerowa" : "Typ: Nieznany")))
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                .padding(.horizontal)

                // Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        toggleTrailInCollection(collection: "toDoTrails")
                    }) {
                        HStack {
                            Image(systemName: "star")
                            Text("W planach")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isInToDoList ? Color(hex: "#108932") : Color.white)
                        .foregroundColor(isInToDoList ? .white : Color(hex: "#108932"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#108932"), lineWidth: 2)
                        )
                    }

                    Button(action: {
                        toggleTrailInCollection(collection: "completedTrails")
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Ukończony")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isInCompletedList ? Color(hex: "#108932") : Color.white)
                        .foregroundColor(isInCompletedList ? .white : Color(hex: "#108932"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#108932"), lineWidth: 2)
                        )
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .onAppear {
            // Check if trail is in collections when the view appears
            checkIfTrailIsInCollection()
        }
        .alert(isPresented: $showLoginAlert) {
            Alert(
                title: Text("Logowanie wymagane"),
                message: Text("Aby dodać ten szlak do listy, musisz być zalogowany."),
                primaryButton: .default(Text("Zaloguj się"), action: {
                    // Navigate to login view or trigger login process
                }),
                secondaryButton: .cancel()
            )
        }
    }
}
