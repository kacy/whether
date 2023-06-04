import Foundation

struct CurrentConditions: Codable {
    let weatherText: String
    let weatherIcon: Int
    let hasPrecipitation: Bool?
    let precipitationType: String?
    let isDayTime: Bool?
    let temperature: Temperature
    let realFeelTemperature: Temperature
    let cloudCover: Int
    let uvIndex: Int
    let humidity: Int
    let dewPoint: Temperature
    let pressure: Temperature
    let wind: Wind
    let windGust: WindGust
    
    enum CodingKeys: String, CodingKey {
        case weatherText = "WeatherText",
             weatherIcon = "WeatherIcon",
             hasPrecipitation = "HasPrecipitation",
             precipitationType = "PrecipitationType",
             isDayTime = "IsDayTime",
             temperature = "Temperature",
             realFeelTemperature = "RealFeelTemperature",
             cloudCover = "CloudCover",
             uvIndex = "UVIndex",
             humidity = "RelativeHumidity",
             dewPoint = "DewPoint",
             pressure = "Pressure",
             wind = "Wind",
             windGust = "WindGust"
    }
}

struct Temperature: Codable {
    let metric: Measurement
    let imperial: Measurement
    
    enum CodingKeys: String, CodingKey {
        case metric = "Metric",
             imperial = "Imperial"
    }
}

struct Measurement: Codable {
    let value: Float
    let unit: String
    let phrase: String?
    
    enum CodingKeys: String, CodingKey {
        case value = "Value",
             unit = "Unit",
             phrase = "Phrase"
    }
}

struct WindGust: Codable {
    let speed: Temperature
    
    enum CodingKeys: String, CodingKey {
        case speed = "Speed"
    }
}

struct Wind: Codable {
    let direction: Direction
    let speed: Temperature
    
    enum CodingKeys: String, CodingKey {
        case direction = "Direction",
             speed = "Speed"
    }
}

struct Direction: Codable {
    let localized: String
    
    enum CodingKeys: String, CodingKey {
        case localized = "Localized"
    }
}
