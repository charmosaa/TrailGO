import Combine
import Foundation
import FirebaseFirestore

class TrailManager: ObservableObject {
    @Published var trails: [Trail] = []
    @Published var toDoTrailIds: [String] = []
    @Published var completedTrailIds: [String] = []
    @Published var userFirstName: String = "" // User's first name
    @Published var userLastName: String = ""  // User's last name
    
    var toDoTrails: [Trail] {
        trails.filter { toDoTrailIds.contains($0.id) }
    }
    
    var completedTrails: [Trail] {
        trails.filter { completedTrailIds.contains($0.id) }
    }
    
    // Fetch all data for the user
    func fetchData(userId: String) {
        // Fetch all trails
        FirestoreService.shared.fetchTrailsFromFirestore { [weak self] fetchedTrails in
            DispatchQueue.main.async {
                self?.trails = fetchedTrails
            }
        }
        
        // Fetch To Do Trail IDs
        FirestoreService.shared.fetchToDoTrailIds(userId: userId) { [weak self] ids in
            DispatchQueue.main.async {
                self?.toDoTrailIds = ids
            }
        }
        
        // Fetch Completed Trail IDs
        FirestoreService.shared.fetchCompletedTrailIds(userId: userId) { [weak self] ids in
            DispatchQueue.main.async {
                self?.completedTrailIds = ids
            }
        }
        
        // Fetch User Info (First and Last Name)
        FirestoreService.shared.fetchUserInfo(userId: userId) { [weak self] firstName, lastName in
            DispatchQueue.main.async {
                self?.userFirstName = firstName
                self?.userLastName = lastName
            }
        }
    }
}
