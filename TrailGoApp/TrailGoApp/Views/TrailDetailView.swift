import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TrailDetailView: View {
    let trail: Trail
    @ObservedObject var languageManager: LanguageManager

    @State private var userId: String?
    @State private var showLoginAlert = false
    @State private var isLoggedIn: Bool = false  // Add a local state for isLoggedIn
    @State private var showLoginView = false  // To trigger navigation to LoginView
    
    // Check if the trail is in the ToDo or Completed list
    @State private var isInToDoList = false
    @State private var isInCompletedList = false

    let db = Firestore.firestore()

    init(trail: Trail, languageManager: LanguageManager) {
        self.trail = trail
        self.languageManager = languageManager
        self._userId = State(initialValue: Auth.auth().currentUser?.uid)
    }

    func toggleTrailInCollection(collection: String) {
        guard let userId = userId else {
            showLoginAlert = true // Show login alert if not logged in
            return
        }

        let userRef = db.collection("users").document(userId)

        userRef.collection(collection).document(trail.id).getDocument { document, error in
            if let document = document, document.exists {
                userRef.collection(collection).document(trail.id).delete { error in
                    if let error = error {
                        print("Error removing trail from \(collection): \(error)")
                    } else {
                        print("Trail successfully removed from \(collection).")
                        if collection == "toDoTrails" {
                            isInToDoList = false
                        } else if collection == "completedTrails" {
                            isInCompletedList = false
                        }
                    }
                }
            } else {
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

    func checkIfTrailIsInCollection() {
        guard let userId = userId else { return }

        let userRef = db.collection("users").document(userId)

        userRef.collection("toDoTrails").document(trail.id).getDocument { document, error in
            if let document = document, document.exists {
                isInToDoList = true
            }
        }

        userRef.collection("completedTrails").document(trail.id).getDocument { document, error in
            if let document = document, document.exists {
                isInCompletedList = true
            }
        }
    }

    var body: some View {
       
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
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
                        .buttonStyle(PlainButtonStyle())

                        HStack {
                            Spacer()
                            NavigationLink(destination: GalleryView(photos: trail.photos)) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Rectangle()
                        .fill(Color(hex: trail.colorHex))
                        .frame(height: 15)
                        .cornerRadius(3)

                    VStack {
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
                                Text("20 dni 5h")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Divider()

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

                    HStack(spacing: 20) {
                        Button(action: {
                            toggleTrailInCollection(collection: "toDoTrails")
                        }) {
                            HStack {
                                Image(systemName: "star.fill")
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
                                Image(systemName: "checkmark.seal.fill")
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
                checkIfTrailIsInCollection()
            }
            .alert(isPresented: $showLoginAlert) {
                Alert(
                    title: Text("Logowanie wymagane"),
                    message: Text("Aby dodać ten szlak do listy, musisz być zalogowany."),
                    primaryButton: .default(Text("Zaloguj się"), action: {
                        showLoginView = true // Navigate to login when tapping "Zaloguj się"
                    }),
                    secondaryButton: .cancel()
                )
            }
            .background(
                NavigationLink("", destination: LogInView(isLoggedIn: $isLoggedIn).environmentObject(languageManager), isActive: $showLoginView)
                    .hidden() // Hide the link
            )
        }
    
}
