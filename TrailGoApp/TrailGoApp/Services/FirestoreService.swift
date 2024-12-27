import Firebase
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()  // Singleton instance
    
    private init() {}
    
    // Fetch trails from Firestore
    func fetchTrailsFromFirestore(completion: @escaping ([Trail]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("trails").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
                return
            }
            
            var trails: [Trail] = []
            for document in querySnapshot!.documents {
                let data = document.data()
                // Create Trail from Firestore document
                let trail = Trail(
                    id: document.documentID, // Use Firestore's document ID as the trail's id
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
}
