import SwiftUI
struct HourlyCells: View {
    var hourlyForecasts: HourlyForecasts
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Temp    Feels Like    Cloud Coverage    Humidity    UV Index")
                .font(.system(size: 12))
            
            ForEach(hourlyForecasts.hourlyForecasts) { hour in
                HourlyCell(hourlyForecast: hour)
            }
        }
    }
    
    init(hourlyForecasts: HourlyForecasts) {
        self.hourlyForecasts = hourlyForecasts
    }
}

struct HourlyCell: View {
    var hourlyForecast: HourlyForecast
    var formattedHour: String
    
    var body: some View {
        HStack {
            AnyView(Image(systemName: chooseIcon(iconKey: self.hourlyForecast.weatherIcon, isDayTime: self.hourlyForecast.isDayTime ?? false))
                .font(.system(size: 32.0))
                .foregroundColor(chooseIconColor(isDayTime: self.hourlyForecast.isDayTime ?? false))
//                .foregroundColor(.orange)
            )
            
            // Hour String
            Text("\(self.formattedHour)")
            
            Spacer()
            HStack {
                // Temperature
                Text("\(String(Int(self.hourlyForecast.temperature.value)))°\(self.hourlyForecast.temperature.unit)")
                    .bold()
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                
                // Feels Like
                Text("\(String(Int(self.hourlyForecast.realFeelTemperature.value)))°\(self.hourlyForecast.temperature.unit)")
                    .foregroundColor(Color.gray)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                    .bold()
                
                // Cloud Coverage
                Text("\(self.hourlyForecast.cloudCover)%")
                    .foregroundColor(Color.gray)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                    .bold()
                
                // Humidity
                Text("\(self.hourlyForecast.humidity)%")
                    .foregroundColor(Color.gray)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                    .bold()
                
                // UV Index
                Text("\(self.hourlyForecast.uvIndex)")
                    .foregroundColor(Color.gray)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                    .bold()
            }

            
        }
        .padding(10)
        Divider()
//        .frame(height: 60)
    }
    
    init(hourlyForecast: HourlyForecast) {
        self.hourlyForecast = hourlyForecast
        self.formattedHour = ""
        
        self.formattedHour = formatHour(dateString: self.hourlyForecast.datetime)
    }
    
    func formatHour(dateString: String) -> String {
        let newFormatter = ISO8601DateFormatter()
        let date = newFormatter.date(from: dateString) ?? Date()

        let dateFormatter = DateFormatter()
        
        // e.g. 4pm
        dateFormatter.dateFormat = "ha"
        
        return dateFormatter.string(from: date).lowercased()
    }
}
