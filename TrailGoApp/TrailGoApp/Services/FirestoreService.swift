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
}
