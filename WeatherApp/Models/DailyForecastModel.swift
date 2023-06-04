import Foundation

struct DailyForecasts: Codable {
    let dailyForecasts: [DailyForecast]
    
    enum CodingKeys: String, CodingKey {
        case dailyForecasts = "DailyForecasts"
    }
}

struct DailyForecast: Codable {
    let sun: Sun
    let airAndPollen: [AirAndPollen]
    
    enum CodingKeys: String, CodingKey {
        case sun = "Sun"
        case airAndPollen = "AirAndPollen"
    }
}

struct Sun: Codable {
    let epochRise: Int
    let epochSet: Int
    
    enum CodingKeys: String, CodingKey {
        case epochRise = "EpochRise"
        case epochSet = "EpochSet"
    }
}

struct AirAndPollen: Codable {
    let value: Int
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case value = "Value",
             category = "Category"
    }
}
