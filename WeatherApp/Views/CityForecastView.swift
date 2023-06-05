import SwiftUI
import Charts


struct CityForecastView: View {
    @EnvironmentObject var weather: WeatherAPI
    var label: String
    var city: String
    var temp: Int
    
    init(label: String, city: String, temp: Int) {
        self.label = label
        self.city = city
        self.temp = temp
    }
    
    let iconKey = 1
    
    var body: some View {
        Header(label: self.label)
    }
}

struct CityForecastView_Previews: PreviewProvider {
    static var previews: some View {
        CityForecastView(label: "Home", city: "Current Location", temp: 0)
    }
}

func chooseIconColor(isDayTime: Bool) -> Color {
    if isDayTime {
        return Color.orange
    }
    return Color(white: 0.5)
}

func chooseIcon(iconKey: Int, isDayTime: Bool) -> String {
    if !isDayTime {
//        return "moon	phase.waxing.gibbous"
        return "moon"
    }
    
    switch iconKey {
    case 1: return "sun.max" // Sunny
    case 2: return "cloud.sun" // Mostly Sunny
    case 3: return "cloud.sun" // Partly Sunny
    case 4: return "cloud" // Intermittent Clouds
    case 5: return "sun.haze" // Hazy Sunshine
    case 6: return "cloud" // Mostly Cloudy
    case 7: return "cloud" // Cloudy
    case 8: return "cloud" // Dreary (Overcast)
    case 9: return "" // NA
    case 10: return "" // NA
    case 11: return "cloud.fog" // Fog
    case 12: return "cloud.rain" // Showers
    case 13: return "cloud.sun.rain" // Mostly Cloudy w/ Showers
    case 14: return "cloud.sun.rain" // Partly Sunny w/ Showers
    case 15: return "cloud.bolt.rain" // T-Storms
    case 16: return "cloud.bolt" // Mostly Cloudy w/ T-Storms
    case 17: return "cloud.sun.bolt" // Partly Sunny w/ T-Storms
    case 18: return "cloud.rain" // Rain
    case 19: return "snowflake" // Flurries
    case 20: return "cloud.snow" // Mostly Cloudy w/ Flurries
    case 21: return "cloud.snow" // Partly Sunny w/ Flurries
    case 22: return "cloud.snow" // Snow
    case 23: return "cloud.snow" // Mostly Cloudy w/ Snow
    case 24: return "snowflake" // Ice
    case 25: return "cloud.sleet" // Sleet
    case 26: return "cloud.snow" // Freezing Rain
    case 27: return "" // NA
    case 28: return "" // NA
    case 29: return "cloud.snow" // Rain and Snow
    case 30: return "thermometer.high" // Hot
    case 31: return "thermometer.low" // Cold
    case 32: return "wind" // Windy
    case 33: return "sun.min" // Clear
    case 34: return "sun.min" // Mostly Clear
    case 35: return "cloud" // Partly Cloudy
    case 36: return "cloud" // Intermittent Clouds
    case 37: return "moon.haze" // Hazy Moonlight
    case 38: return "cloud" // Mostly Cloudy
    case 39: return "cloud.drizzle" // Partly Cloudy w/ Showers
    case 40: return "cloud.rain" // Mostly Cloudy w/ Showers
    case 41: return "cloud.bolt" // Partly Cloudy w/ T-Storms
    case 42: return "cloud.heavyrain" // Mostly Cloudy w/ T-Storms
    case 43: return "cloud.snow" // Mostly Cloudy w/ Flurries
    case 44: return "cloud.snow" // Mostly Cloudy w/ Snow
        
    default:
        return "sun.max"
    }
}

struct Header: View {
    @EnvironmentObject var weather: WeatherAPI
    var label: String
    @State private var temp: String = "72"

    @State private var currentConditions: CurrentConditions
    @State private var dailyForecasts: DailyForecasts
    @State private var hourlyForecasts: HourlyForecasts
    
    @State private var city = "Current Location"
//    @State private var temp: String
    @State private var weatherText = ""
    @State private var realFeelTemp = ""
    @State private var weatherIcon = 1
    @State private var cloudCover = 0
    @State private var uvIndex = 0
    @State private var humidity = 0
    @State private var dewPoint = 0
    @State private var pressureValue = 0
    @State private var pressureUnit = ""
    @State private var sunrise = ""
    @State private var sunset = ""
    @State private var aqiString = ""
    @State private var windDirection = ""
    @State private var windSpeed = 0
    @State private var windGust = 0
    @State private var windUnit = ""
    @State private var hourlyChartData = [HourlyChart]()
    @State private var isDayTime = false
    
    init(label: String) {
        self.label = label
        
        let default_measurement = Measurement(value: 0.0, unit: "", phrase: "")
        let default_temp = Temperature(metric: default_measurement, imperial: default_measurement)
        
        _currentConditions = State(initialValue: CurrentConditions(
            weatherText: "", weatherIcon: 0, hasPrecipitation: false, precipitationType: "",
            isDayTime: false, temperature: default_temp, realFeelTemperature: default_temp,
            cloudCover: 0, uvIndex: 0, humidity: 0, dewPoint: default_temp, pressure: default_temp,
            wind: Wind(direction: Direction(localized: ""), speed: default_temp),
            windGust: WindGust(speed: default_temp)))

        let default_sun = Sun(epochRise: 0, epochSet: 0)
        let default_air = AirAndPollen(value: 0, category: "")
        let default_dailyForecast = DailyForecast(sun: default_sun, airAndPollen: [default_air])
        _dailyForecasts = State(initialValue: DailyForecasts(dailyForecasts: [default_dailyForecast]))
        
        let default_hourly_forecast = HourlyForecast(datetime: "", weatherText: "", weatherIcon: 1, hasPrecipitation: false, precipitationType: "", isDayTime: false, temperature: default_measurement, realFeelTemperature: default_measurement, cloudCover: 0, uvIndex: 0, humidity: 0, dewPoint: default_measurement)
        _hourlyForecasts = State(initialValue: HourlyForecasts(hourlyForecasts: [default_hourly_forecast]))
        
        _hourlyChartData = State(initialValue: [HourlyChart(hour: "3pm", temp: 33)])
    }
    


    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(self.label)
                            .font(.system(size: 24))
                        HStack {
                            Text(city)
                            AnyView(Image(systemName: "location.fill"))
                                .font(.system(size: 12))
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        HStack {
                            AnyView(Image(systemName: chooseIcon(iconKey: weatherIcon, isDayTime: isDayTime))
                                .font(.system(size: 32.0))
//                                .foregroundColor(.orange))
                                .foregroundColor(chooseIconColor(isDayTime: isDayTime)))
                            Text(String(temp) + "°")
                                .foregroundColor(chooseIconColor(isDayTime: isDayTime))
//                                .foregroundColor(.orange)
                                .font(.system(size: 32))
                                .bold()
                        }
                    }
                }
                VStack {
                    Text(weatherText)
                        .foregroundColor(.orange)
                        .font(.system(size: 24))
                        .bold()
                }.padding(12)
//                VStack {
//                    Text("Feels Like: \(realFeelTemp)" + "°")
//                }
                HStack {
                    HStack {
                        Text("FEELS LIKE").foregroundColor(.gray).bold().font(.system(size: 14))
                        Spacer()
                        Text("\(realFeelTemp)" + "°").bold().font(.system(size: 14))
                    }.padding(.trailing, 10)
                    HStack {
                        Text("SUNRISE").foregroundColor(.gray).bold().font(.system(size: 14))
                        Spacer()
                        Text("\(sunrise)").bold().font(.system(size: 14))
                    }.padding(.leading, 10)
                }.padding(.top, 20)
                HStack {
                    HStack {
                        Text("PRECIPITATION").foregroundColor(.gray).bold().font(.system(size: 14))
                        Spacer()
                        Text("0" + "%").bold().font(.system(size: 14)) //TODO
                    }.padding(.trailing, 10)
                    HStack {
                        Text("SUNSET").foregroundColor(.gray).bold().font(.system(size: 14))
                        Spacer()
                        Text("\(sunset)").bold().font(.system(size: 14))
                    }.padding(.leading, 10)
                }
                HStack {
                    HStack {
                        Text("RAIN").foregroundColor(.gray).bold().font(.system(size: 14))
                        Spacer()
                        Text("0.00 IN").bold().font(.system(size: 14)) //TODO
                    }.padding(.trailing, 10)
                    HStack {
                        Text("WIND").foregroundColor(.gray).bold().font(.system(size: 14))
                        Spacer()
                        Text("\(windSpeed) - \(windGust) \(windUnit) \(windDirection)").bold().font(.system(size: 14)) //todo
                    }.padding(.leading, 10)
                }
                HStack {
                    HStack {
                        Text("DEW POINT").foregroundColor(.gray).bold().font(.system(size: 14))
                        Spacer()
                        Text("\(dewPoint)" + "°").bold().font(.system(size: 14)) //todo
                    }.padding(.trailing, 10)
                    HStack {
                        Text("UV INDEX").foregroundColor(.gray).bold().font(.system(size: 14))
                        Spacer()
                        Text("\(uvIndex)").bold().font(.system(size: 14))
                    }.padding(.leading, 10)
                }
                HStack {
                    HStack {
                        Text("HUMIDITY").foregroundColor(.gray).bold().font(.system(size: 14))
                        Spacer()
                        Text("\(humidity)" + "%").bold().font(.system(size: 14))
                    }.padding(.trailing, 10)
                    HStack {
                        Text("CLOUD COVER").foregroundColor(.gray).bold().font(.system(size: 14))
                        Spacer()
                        Text("\(cloudCover)" + "%").bold().font(.system(size: 14))
                    }.padding(.leading, 10)
                }
                HStack {
                    HStack {
                        Text("PRESSURE").foregroundColor(.gray).bold().font(.system(size: 14))
                        Spacer()
                        Text("\(String(pressureValue)) \(pressureUnit)").bold().font(.system(size: 14))
                    }.padding(.trailing, 10)
                    HStack {
                        Text("AQI").foregroundColor(.gray).bold().font(.system(size: 14))
                        Spacer()
                        Text("\(aqiString)").bold().font(.system(size: 14))
                    }.padding(.leading, 10)
                }
            }
            .padding()
            HourlyChartView(hourlyCharts: hourlyChartData)
                .padding(10)
            VStack {
                HourlyCells(hourlyForecasts: hourlyForecasts)
//                HourlyCell(hourlyForecasts: hourlyForecasts)
            }
            .onAppear {
                Task {
                    await weather.fetchAll()
                    
                    guard let w = weather.currentWeather else {
                        print("Failed at Current Weather")
                        return
                    }
                    
                    city = w.locationResult?.city ?? "Current Location"
                    guard let currentConditions = w.currentConditions else { return }
                    
                    temp = String(Int(currentConditions.temperature.imperial.value))

                    weatherText = currentConditions.weatherText
                    weatherIcon = currentConditions.weatherIcon
                    realFeelTemp = String(Int(currentConditions.realFeelTemperature.imperial.value))
                    if let phrase = currentConditions.realFeelTemperature.imperial.phrase {
                        weatherText = weatherText + " and " + phrase
                    }
                    humidity = currentConditions.humidity
                    dewPoint = Int(currentConditions.dewPoint.imperial.value)
                    let pressureValueResult = currentConditions.pressure.metric.value
                    let pressureUnitResult = currentConditions.pressure.metric.unit
                    pressureValue = Int(pressureValueResult)
                    pressureUnit = String(pressureUnitResult).uppercased()
                    
                    isDayTime = w.currentConditions?.isDayTime ?? false
                    
                    let sunriseEpoch = String(w.dailyForecasts?.dailyForecasts[0].sun.epochRise ?? 0)
                    let sunsetEpoch = String(w.dailyForecasts?.dailyForecasts[0].sun.epochSet ?? 0)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mm a"
                    let sunriseEpochDate = Date(timeIntervalSince1970: Double(sunriseEpoch)!)
                    let sunsetEpochDate = Date(timeIntervalSince1970: Double(sunsetEpoch)!)
                    sunrise = dateFormatter.string(from: sunriseEpochDate)
                    sunset = dateFormatter.string(from: sunsetEpochDate)
                    windSpeed = Int(currentConditions.wind.speed.imperial.value)
                    windGust = Int(currentConditions.windGust.speed.imperial.value)
                    windUnit = currentConditions.wind.speed.imperial.unit.uppercased()
                    if windUnit == "MI/H" { windUnit = "MPH" }
                    windDirection = currentConditions.wind.direction.localized
                    uvIndex = currentConditions.uvIndex
                    cloudCover = currentConditions.cloudCover
                    let aqi = w.dailyForecasts?.dailyForecasts[0].airAndPollen[0].value ?? 0
                    let aqiDescription = w.dailyForecasts?.dailyForecasts[0].airAndPollen[0].category ?? ""
                    if aqiDescription == "" {
                        aqiString = "\(aqi)"
                    } else {
                        aqiString = "\(aqi) (\(aqiDescription))"
                    }
                    
                    hourlyForecasts = w.hourlyForecast!
                    
                    hourlyChartData = [HourlyChart]()
                    for hour in hourlyForecasts.hourlyForecasts {
                        let hc = HourlyChart(hour: hour.datetime, temp: Int(hour.temperature.value))
                        hourlyChartData.append(hc)
                    }
                }
            }
        }
    }
}
