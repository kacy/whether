import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?

    override init() {
        super.init()

        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
    }

}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error)")
    }
}

