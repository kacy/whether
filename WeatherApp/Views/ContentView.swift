import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var weather = WeatherAPI(apiKey: "YOUR_KEY_HERE", locationManager: nil)
    
    var body: some View {
        CityForecastView(label: "Home", city: "Current Location", temp: 0)
            .environmentObject(weather)
            .onAppear() {
                if locationManager.currentLocation != nil {
                    weather.locationManager = locationManager
                    Task {
                        await weather.fetchAll()
                    }
                }
            }
            .onChange(of: locationManager.currentLocation) { location in
                weather.locationManager = locationManager
                if location != nil {
                    Task {
                        await weather.fetchAll()
                    }
                }
            }
            .refreshable {
                weather.locationManager = locationManager
                print("⏱️ Refreshing view")
                await weather.fetchAll()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
