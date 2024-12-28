import Firebase
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()  // Singleton instance
    private let db = Firestore.firestore()
    
    private init() {}

    // Fetch all trails from Firestore
    func fetchTrailsFromFirestore(completion: @escaping ([Trail]) -> Void) {
        db.collection("trails").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
                return
            }
            
            var trails: [Trail] = []
            for document in querySnapshot!.documents {
                let data = document.data()
                let trail = Trail(
                    id: document.documentID,
                    name: data["name"] as? [String: String] ?? [:],
                    imageName: data["imageName"] as? String ?? "",
                    startingCity: data["startingCity"] as? String ?? "",
                    endingCity: data["endingCity"] as? String ?? "",
                    startCoordinate: Trail.Coordinates(
                        latitude: (data["startCoordinate"] as? GeoPoint)?.latitude ?? 0.0,
                        longitude: (data["startCoordinate"] as? GeoPoint)?.longitude ?? 0.0
                    ),
                    endCoordinate: Trail.Coordinates(
                        latitude: (data["endCoordinate"] as? GeoPoint)?.latitude ?? 0.0,
                        longitude: (data["endCoordinate"] as? GeoPoint)?.longitude ?? 0.0
                    ),
                    colorHex: data["colorHex"] as? String ?? "",
                    distance: data["distance"] as? Int ?? 0,
                    elevation: data["elevation"] as? Int ?? 0,
                    description: data["description"] as? [String: String] ?? [:],
                    isHike: data["isHike"] as? Bool ?? false,
                    isBike: data["isBike"] as? Bool ?? false,
                    photos: data["photos"] as? [String] ?? []
                )
                
                trails.append(trail)
            }
            completion(trails)
        }
    }
    
    // Fetch To Do Trail IDs
    func fetchToDoTrailIds(userId: String, completion: @escaping ([String]) -> Void) {
        db.collection("users").document(userId).collection("toDoTrails").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching To Do Trail IDs: \(error)")
                completion([])
                return
            }
            
            let ids = snapshot?.documents.map { $0.documentID } ?? []
            completion(ids)
        }
    }
    
    // Fetch Completed Trail IDs
    func fetchCompletedTrailIds(userId: String, completion: @escaping ([String]) -> Void) {
        db.collection("users").document(userId).collection("completedTrails").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching Completed Trail IDs: \(error)")
                completion([])
                return
            }
            
            let ids = snapshot?.documents.map { $0.documentID } ?? []
            completion(ids)
        }
    }
    // Fetch user info (first name and last name) from Firestore
        func fetchUserInfo(userId: String, completion: @escaping (String, String) -> Void) {
            db.collection("users").document(userId).getDocument { document, error in
                if let document = document, document.exists {
                    let firstName = document.data()?["name"] as? String ?? ""
                    let lastName = document.data()?["surname"] as? String ?? ""
                    completion(firstName, lastName)
                } else {
                    print("User document does not exist or error occurred: \(String(describing: error))")
                    completion("", "")
                }
            }
        }
    
    func fetchCompletedFeedback(trailId: String, completion: @escaping ([TrailFeedback]) -> Void) {
        db.collection("trailFeedback")  // Assuming all feedback is stored here, not under each user.
            .whereField("trailId", isEqualTo: trailId)  // Filter by trailId
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching all completed feedback: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No completed feedback found.")
                    completion([])
                    return
                }
                
                let feedbacks = documents.compactMap { document -> TrailFeedback? in
                    try? document.data(as: TrailFeedback.self)
                }
                
                completion(feedbacks)
            }
    }


       // Calculate average days from completed feedback
       func calculateAverageDays(feedbacks: [TrailFeedback]) -> Double {
           let totalDays = feedbacks.reduce(0.0) { sum, feedback in
               let days = Calendar.current.dateComponents([.day], from: feedback.startDate, to: feedback.endDate).day ?? 0
               return sum + Double(days)
           }
           
           return feedbacks.count > 0 ? totalDays / Double(feedbacks.count) : 0.0
       }
    
    // Add or remove trail from collection (toDoTrails or completedTrails)
        func toggleTrailInCollection(userId: String?, trail: Trail, collection: String, completion: @escaping (Bool) -> Void) {
            guard let userId = userId else {
                print("User not logged in.")
                completion(false)
                return
            }

            let userRef = db.collection("users").document(userId)

            userRef.collection(collection).document(trail.id).getDocument { document, error in
                if let document = document, document.exists {
                    // Trail exists, so remove it
                    userRef.collection(collection).document(trail.id).delete { error in
                        if let error = error {
                            print("Error removing trail from \(collection): \(error)")
                        } else {
                            print("Trail successfully removed from \(collection).")
                            completion(false)  // Trail was removed
                        }
                    }
                } else {
                    // Trail doesn't exist, so add it
                    let trailData: [String: Any] = [
                        "name": trail.name["en"] ?? "",
                        "distance": trail.distance,
                        "elevation": trail.elevation,
                        "startingCity": trail.startingCity,
                        "endingCity": trail.endingCity,
                        "description": trail.description["en"] ?? "",
                        "isHike": trail.isHike,
                        "isBike": trail.isBike,
                        "imageName": trail.imageName
                    ]
                    userRef.collection(collection).document(trail.id).setData(trailData) { error in
                        if let error = error {
                            print("Error adding trail to \(collection): \(error)")
                        } else {
                            print("Trail successfully added to \(collection).")
                            completion(true)  // Trail was added
                        }
                    }
                }
            }
        }

        // Save trail feedback
        func saveTrailFeedback(userId: String?, feedback: TrailFeedback, completion: @escaping (Bool) -> Void) {
            guard let userId = userId else {
                print("User not logged in.")
                completion(false)
                return
            }

            let feedbackData: [String: Any] = [
                "userId": userId,
                "trailId": feedback.trailId,
                "startDate": feedback.startDate,
                "endDate": feedback.endDate,
                "difficulty": feedback.difficulty,
                "grade": feedback.grade,
                "comment": feedback.comment
            ]

            db.collection("trailFeedback").addDocument(data: feedbackData) { error in
                if let error = error {
                    print("Error saving feedback: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Feedback successfully saved.")
                    completion(true)
                }
            }
        }

        // Check if trail is in the user's collection (toDoTrails or completedTrails)
        func checkIfTrailIsInCollection(userId: String?, trailId: String, completion: @escaping (Bool, Bool) -> Void) {
            guard let userId = userId else {
                completion(false, false)
                return
            }

            let userRef = db.collection("users").document(userId)

            var isInToDoList = false
            var isInCompletedList = false

            userRef.collection("toDoTrails").document(trailId).getDocument { document, error in
                if let document = document, document.exists {
                    isInToDoList = true
                }

                userRef.collection("completedTrails").document(trailId).getDocument { document, error in
                    if let document = document, document.exists {
                        isInCompletedList = true
                    }

                    // Return the results
                    completion(isInToDoList, isInCompletedList)
                }
            }
        }
    // Add this function to your FirestoreService class
    func calculateTotalDaysForUser(userId: String, completion: @escaping (Int) -> Void) {
        let feedbackRef = db.collection("trailFeedback")
            .whereField("userId", isEqualTo: userId)

        feedbackRef.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching feedback: \(error.localizedDescription)")
                completion(0)  // Return 0 if there is an error
                return
            }

            var totalDays = 0
            guard let documents = querySnapshot?.documents else {
                print("No feedback found.")
                completion(0)  // Return 0 if no documents are found
                return
            }

            // Calculate the total days from feedback
            for document in documents {
                let data = document.data()

                if let startDateTimestamp = data["startDate"] as? Timestamp,
                   let endDateTimestamp = data["endDate"] as? Timestamp {
                    let startDate = startDateTimestamp.dateValue()
                    let endDate = endDateTimestamp.dateValue()

                    let calendar = Calendar.current
                    let days = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0
                    totalDays += days
                }
            }
            completion(totalDays)
        }
    }

}
