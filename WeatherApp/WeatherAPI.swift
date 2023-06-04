import Foundation

class WeatherAPI: ObservableObject {
    var apiKey: String = ""
    let BASE_URI = "https://dataservice.accuweather.com"

    @Published var currentWeather: Weather?
    var latitude: Double = 35.0
    var longitude: Double = -75.0
    var locationManager: LocationManager?

    
    struct Weather: Codable {
        let locationResult: LocationResult?
        let currentConditions: CurrentConditions?
        let dailyForecasts: DailyForecasts?
        let hourlyForecast: HourlyForecasts?
    }

    struct GeopositionSearch: Codable {
        let key: String
        let country: Country
        let city: String
        let state_abr: State
        enum CodingKeys: String, CodingKey {
            case key = "Key",
                 country = "Country",
                 city = "LocalizedName",
                 state_abr = "AdministrativeArea"
        }
    }

    struct Country: Codable {
        let localizedName: String
        enum CodingKeys: String, CodingKey {
            case localizedName = "LocalizedName"
        }
    }
    
    struct State: Codable {
        let id: String
        let localizedName: String
        enum CodingKeys: String, CodingKey {
            case id = "ID",
                 localizedName = "LocalizedName"
        }
    }
    
    init(apiKey: String, locationManager: LocationManager?) {
        self.apiKey = apiKey
        self.locationManager = locationManager
    }
    
    func fetchAll() async {
        guard let locationManager = locationManager else {
            print("locationManager not set")
            return
            
        }

        self.latitude = locationManager.currentLocation?.coordinate.latitude ?? 0
        self.longitude = locationManager.currentLocation?.coordinate.longitude ?? 0
        guard let locationResult = await self.fetchLocation() else { return }
        
        let currentConditions = await self.fetchCurrentConditions()!
        let dailyForecasts = await self.fetchDailyForecast(locationKey: locationResult.locationKey!)
        let hourlyForecast = await self.fetchHourlyForecast(locationKey: locationResult.locationKey!)
        DispatchQueue.main.async {
            self.currentWeather = Weather.init(
                locationResult: locationResult,
                currentConditions: currentConditions,
                dailyForecasts: dailyForecasts,
                hourlyForecast: hourlyForecast
            )
        }
    }
    
    func fetchLocation() async -> LocationResult? {
        if self.latitude == 0.0 || self.longitude == 0.0 {
            print("❌ coordinates not set")
        }
        let path = "/locations/v1/cities/geoposition/search?apikey=\(self.apiKey)&q=\(self.latitude)%2C\(self.longitude)"
        let url = URL(string: BASE_URI + path)!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONDecoder().decode(WeatherAPI.GeopositionSearch.self, from: data)
            print("📍 Location Key: \(json.key)")
            print("📍 City: \(json.city)")
            print("📍 State: \(json.state_abr.id)")
            print("📍 Country: \(json.country.localizedName)")
            return LocationResult(locationKey: json.key, city: json.city, state: json.state_abr.localizedName, country: json.country.localizedName)
        } catch {
            print(error)
        }
        return nil
    }

    func fetchCurrentConditions() async -> CurrentConditions? {
        let path = "/currentconditions/v1/329821?apikey=\(self.apiKey)&details=true"
        let url = URL(string: BASE_URI + path)!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONDecoder().decode([CurrentConditions].self, from: data).first!
            print("☀️ Current Conditions: Has Precipitation: \(json.hasPrecipitation ?? false)")
            print("☀️ Current Conditions: Is Day Time: \(json.isDayTime ?? false)")
            print("☀️ Current Conditions: Precipitation Type: \(json.precipitationType ?? "")")
            print("☀️ Current Conditions: Weather Icon: \(json.weatherIcon)")
            print("☀️ Current Conditions: Weather Text: \(json.weatherText)")
            print("☀️ Current Conditions: Temperature Value: \(json.temperature.imperial.value)")
            print("☀️ Current Conditions: Temperature Unit: \(json.temperature.imperial.unit)")
            print("☀️ Current Conditions: Real Feel Temperature Value: \(json.realFeelTemperature.imperial.value)")
            print("☀️ Current Conditions: Real Feel Temperature Unit: \(json.realFeelTemperature.imperial.unit)")
            print("☀️ Current Conditions: Real Feel Temperature Phrase: \(json.realFeelTemperature.imperial.phrase ?? "")")
            print("☀️ Current Conditions: Cloud Cover: \(json.realFeelTemperature.imperial.phrase ?? "")")
            print("☀️ Current Conditions: Dew Point: \(json.dewPoint.imperial.value)")
            print("☀️ Current Conditions: Pressure: \(json.pressure.imperial.value)")
            let metricResult = Measurement(value: json.temperature.metric.value, unit: json.temperature.metric.unit, phrase: nil)
            let imperialResult = Measurement(value: json.temperature.imperial.value, unit: json.temperature.imperial.unit, phrase: nil)
            let temperatureResult = Temperature(metric: metricResult, imperial: imperialResult)
            let realFeelMetricResult = Measurement(value: json.realFeelTemperature.metric.value, unit: json.realFeelTemperature.metric.unit, phrase: json.realFeelTemperature.metric.phrase)
            let realFeelImperialResult = Measurement(value: json.realFeelTemperature.imperial.value, unit: json.realFeelTemperature.imperial.unit, phrase: json.realFeelTemperature.imperial.phrase)
            let realFeelTemperatureResult = Temperature(metric: realFeelMetricResult, imperial: realFeelImperialResult)
            let dewPointMetricResult = Measurement(value: json.dewPoint.metric.value, unit: String(json.dewPoint.metric.value), phrase: nil)
            let dewPointImperialResult = Measurement(value: json.dewPoint.imperial.value, unit: String(json.dewPoint.imperial.value), phrase: nil)
            let dewPointResult = Temperature(metric: dewPointMetricResult, imperial: dewPointImperialResult)
            let pressureMetricResult = Measurement(value: json.pressure.metric.value, unit: String(json.pressure.metric.unit), phrase: nil)
            let pressureImperialResult = Measurement(value: json.pressure.imperial.value, unit: String(json.pressure.imperial.unit), phrase: nil)
            let pressureResult = Temperature(metric: pressureMetricResult, imperial: pressureImperialResult)
            return CurrentConditions(weatherText: json.weatherText,
                                     weatherIcon: json.weatherIcon,
                                     hasPrecipitation: json.hasPrecipitation,
                                     precipitationType: json.precipitationType,
                                     isDayTime: json.isDayTime,
                                     temperature: temperatureResult,
                                     realFeelTemperature: realFeelTemperatureResult,
                                     cloudCover: json.cloudCover,
                                     uvIndex: json.uvIndex,
                                     humidity: json.humidity,
                                     dewPoint: dewPointResult,
                                     pressure: pressureResult,
                                     wind: json.wind,
                                     windGust: json.windGust
            )
        } catch {
            print(error)
        }
        return nil
    }
    
    func fetchDailyForecast(locationKey: String) async -> DailyForecasts? {
        let path = "/forecasts/v1/daily/1day/\(locationKey)?apikey=\(self.apiKey)&details=true"
        let url = URL(string: BASE_URI + path)!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONDecoder().decode(DailyForecasts.self, from: data)
            print("🔮 Forecast: Sunrise: \(json.dailyForecasts[0].sun.epochRise)")
            print("🔮 Forecast: Sunset: \(json.dailyForecasts[0].sun.epochSet)")
            print("🔮 Forecast: AQI: \(json.dailyForecasts[0].airAndPollen[0].value)")
            return DailyForecasts(dailyForecasts: json.dailyForecasts)
        } catch {
            print(error)
        }
        return nil
    }
    
    func fetchHourlyForecast(locationKey: String) async -> HourlyForecasts? {
        let path = "/forecasts/v1/hourly/12hour/\(locationKey)?apikey=\(self.apiKey)&details=true"
        let url = URL(string: BASE_URI + path)!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONDecoder().decode([HourlyForecast].self, from: data)
            print("🔮 Hourly Forecast: DateTime: \(json[0].datetime)")
            print("🔮 Hourly Forecast: Weather Text: \(json[0].weatherText)")
            print("🔮 Hourly Forecast: Weather Icon: \(json[0].weatherIcon)")
            print("🔮 Hourly Forecast: Has Precipitation: \(json[0].hasPrecipitation ?? false)")
            print("🔮 Hourly Forecast: Precipitation Type: \(json[0].precipitationType ?? "")")
            print("🔮 Hourly Forecast: Is Day Time: \(json[0].isDayTime ?? false)")
            print("🔮 Hourly Forecast: Temperature: \(json[0].temperature.value) \(json[0].temperature.unit)")
            print("🔮 Hourly Forecast: Feels Like: \(json[0].realFeelTemperature.value) \(json[0].temperature.unit)")
            print("🔮 Hourly Forecast: Cloud Cover: \(json[0].cloudCover)")
            print("🔮 Hourly Forecast: UV Index: \(json[0].uvIndex)")
            print("🔮 Hourly Forecast: Humidity: \(json[0].humidity)")
            print("🔮 Hourly Forecast: Dewpoint: \(json[0].dewPoint)")
            return HourlyForecasts(hourlyForecasts: json)
//            print("🔮 Forecast: Sunset: \(json.dailyForecasts[0].sun.epochSet)")
//            print("🔮 Forecast: AQI: \(json.dailyForecasts[0].airAndPollen[0].value)")
//            return HourlyForecast(dailyForecasts: json.)
        } catch {
            print(error)
        }
        return nil
    }

    
}
