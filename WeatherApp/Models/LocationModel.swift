import Foundation

struct Location {
    var latitude: Float64
    var longitude: Float64
}

struct LocationResult: Codable {
    var locationKey: String?
    var city: String?
    var state: String?
    var country: String?
}
