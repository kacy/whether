import Foundation

struct HourlyForecasts: Codable, Identifiable {
    let id = UUID()
    let hourlyForecasts: [HourlyForecast]
    
    enum CodingKeys: String, CodingKey {
        case hourlyForecasts = "DailyForecasts" //TODO
    }
}

struct HourlyForecast: Codable, Identifiable {
    let id = UUID()
    let datetime: String
    let weatherText: String
    let weatherIcon: Int
    let hasPrecipitation: Bool?
    let precipitationType: String?
    let isDayTime: Bool?
    let temperature: Measurement
    let realFeelTemperature: Measurement
    let cloudCover: Int
    let uvIndex: Int
    let humidity: Int
    let dewPoint: Measurement
//    let pressure: Measurement
//    let wind: Wind
//    let windGust: WindGust
    
    enum CodingKeys: String, CodingKey {
        case datetime = "DateTime",
             weatherText = "IconPhrase",
             weatherIcon = "WeatherIcon",
             hasPrecipitation = "HasPrecipitation",
             precipitationType = "PrecipitationType",
             isDayTime = "IsDaylight",
             temperature = "Temperature",
             realFeelTemperature = "RealFeelTemperature",
             cloudCover = "CloudCover",
             uvIndex = "UVIndex",
             humidity = "RelativeHumidity",
             dewPoint = "DewPoint"//,
//             pressure = "Pressure",
//             wind = "Wind",
//             windGust = "WindGust"
    }
}
