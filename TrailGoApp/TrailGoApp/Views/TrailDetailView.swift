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
    
    @State private var isInToDoList = false
    @State private var isInCompletedList = false
    
    @State private var averageDays: Double = 0.0
    @State private var completedFeedbacks: [TrailFeedback] = []
    @State private var averageDifficulty: Double = 5.0
    @State private var averageGrade: Double = 5.0
    
    @State private var showQuestionnaire = false
    @State private var feedback: TrailFeedback?
    

    let db = Firestore.firestore()

    init(trail: Trail, languageManager: LanguageManager) {
        self.trail = trail
        self.languageManager = languageManager
        self._userId = State(initialValue: Auth.auth().currentUser?.uid)
    }
    
    func fetchCompletedFeedback() {
           guard let userId = Auth.auth().currentUser?.uid else {
               return
           }
           
        FirestoreService.shared.fetchCompletedFeedback(trailId: trail.id) { feedbacks in
            self.completedFeedbacks = feedbacks
            self.averageDays = FirestoreService.shared.calculateAverageDays(feedbacks: feedbacks)
            
            // Calculate average difficulty and grade from all feedbacks
            let totalDifficulty = feedbacks.reduce(0) { $0 + $1.difficulty }
            let totalGrade = feedbacks.reduce(0) { $0 + $1.grade }
            
            if !feedbacks.isEmpty {
                self.averageDifficulty = Double(totalDifficulty) / Double(feedbacks.count)
                self.averageGrade = Double(totalGrade) / Double(feedbacks.count)
            }
            }
       }


    func toggleTrailInCollection(collection: String) {
        guard let userId = userId else {
            showLoginAlert = true
            return
        }

        FirestoreService.shared.toggleTrailInCollection(userId: userId, trail: trail, collection: collection) { isAdded in
            if collection == "toDoTrails" {
                isInToDoList = isAdded
            } else if collection == "completedTrails" {
                isInCompletedList = isAdded
            }
        }
    }

    func checkIfTrailIsInCollection() {
        guard let userId = userId else { return }

        FirestoreService.shared.checkIfTrailIsInCollection(userId: userId, trailId: trail.id) { isInToDoList, isInCompletedList in
            self.isInToDoList = isInToDoList
            self.isInCompletedList = isInCompletedList
        }
    }
    
    func saveTrailFeedback() {
            guard let userId = userId, let feedback = feedback else {
                print("Missing user ID or feedback.")
                return
            }

            FirestoreService.shared.saveTrailFeedback(userId: userId, feedback: feedback) { success in
                if success {
                    print("Feedback submitted successfully.")
                    showQuestionnaire = false  // Close the questionnaire
                } else {
                    print("Failed to submit feedback.")
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
                                ForEach(0..<5) { index in
                                   Image(systemName: index < Int(averageDifficulty) ? "star.fill" : "star")
                                       .foregroundColor(Color(hex: "#108932"))
                               }
                            }

                            HStack {
                                Text("Ocena:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                ForEach(0..<5) { index in
                                    Image(systemName: index < Int(averageGrade) ? "star.fill" : "star")
                                        .foregroundColor(Color(hex: "#108932"))
                                }                            }
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
                                Text(String(format: "%.1f", averageDays) + " days")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text(trail.description[languageManager.selectedLanguage] ?? trail.description["en"]!)
                            .font(.body)

                        Text("Finished by: \(completedFeedbacks.count) people")
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
                            if isInCompletedList {
                                // Optionally, show feedback or remove from completed list
                                toggleTrailInCollection(collection: "completedTrails")
                            } else {
                                if Auth.auth().currentUser == nil {
                                    showLoginAlert = true
                                } else {
                                    showQuestionnaire = true
                                }
                            }
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
                        .sheet(isPresented: $showQuestionnaire) {
                            if let feedback = feedback {
                                QuestionaryView(feedback: Binding(
                                    get: { feedback },
                                    set: { self.feedback = $0 }
                                )) {
                                    saveTrailFeedback()
                                    toggleTrailInCollection(collection: "completedTrails")
                                    showQuestionnaire = false
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .onAppear {
                checkIfTrailIsInCollection()
                feedback = TrailFeedback(
                        userId: Auth.auth().currentUser?.uid ?? "",
                        trailId: trail.id,
                        startDate: Date(),
                        endDate: Date(),
                        difficulty: 3,
                        grade: 3,
                        comment: ""
                    )
                fetchCompletedFeedback()
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
