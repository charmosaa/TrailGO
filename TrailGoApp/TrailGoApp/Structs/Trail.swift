import Foundation

struct Trail: Identifiable, Hashable, Codable {
    var id: String // This will be populated by Firestore's document ID
    let name: [String: String]
    let imageName: String
    let startingCity: String
    let endingCity: String
    let startCoordinate: Coordinates
    let endCoordinate: Coordinates
    let colorHex: String
    let distance: Int
    let elevation: Int
    let description: [String: String]
    let isHike: Bool
    let isBike: Bool
    let photos: [String]
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
