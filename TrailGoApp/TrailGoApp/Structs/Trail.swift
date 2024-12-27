import Foundation
import FirebaseFirestore

struct Trail: Identifiable, Hashable, Codable {
    var id: String
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

    init(id: String, name: [String: String], imageName: String, startingCity: String, endingCity: String, startCoordinate: Coordinates, endCoordinate: Coordinates, colorHex: String, distance: Int, elevation: Int, description: [String: String], isHike: Bool, isBike: Bool, photos: [String]) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.startingCity = startingCity
        self.endingCity = endingCity
        self.startCoordinate = startCoordinate
        self.endCoordinate = endCoordinate
        self.colorHex = colorHex
        self.distance = distance
        self.elevation = elevation
        self.description = description
        self.isHike = isHike
        self.isBike = isBike
        self.photos = photos
    }

    // Decoding the Firestore document into the Trail model
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageName
        case startingCity
        case endingCity
        case startCoordinate
        case endCoordinate
        case colorHex
        case distance
        case elevation
        case description
        case isHike
        case isBike
        case photos
    }

    // Custom decoding for GeoPoint
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode the basic fields
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode([String: String].self, forKey: .name)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.startingCity = try container.decode(String.self, forKey: .startingCity)
        self.endingCity = try container.decode(String.self, forKey: .endingCity)
        self.colorHex = try container.decode(String.self, forKey: .colorHex)
        self.distance = try container.decode(Int.self, forKey: .distance)
        self.elevation = try container.decode(Int.self, forKey: .elevation)
        self.description = try container.decode([String: String].self, forKey: .description)
        self.isHike = try container.decode(Bool.self, forKey: .isHike)
        self.isBike = try container.decode(Bool.self, forKey: .isBike)
        self.photos = try container.decode([String].self, forKey: .photos)

        // Handle GeoPoint to Coordinates conversion
        if let startGeoPoint = try? container.decodeIfPresent(GeoPoint.self, forKey: .startCoordinate) {
            self.startCoordinate = Coordinates(latitude: startGeoPoint.latitude, longitude: startGeoPoint.longitude)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .startCoordinate, in: container, debugDescription: "GeoPoint is missing or not in the correct format.")
        }

        if let endGeoPoint = try? container.decodeIfPresent(GeoPoint.self, forKey: .endCoordinate) {
            self.endCoordinate = Coordinates(latitude: endGeoPoint.latitude, longitude: endGeoPoint.longitude)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .endCoordinate, in: container, debugDescription: "GeoPoint is missing or not in the correct format.")
        }
    }
}
