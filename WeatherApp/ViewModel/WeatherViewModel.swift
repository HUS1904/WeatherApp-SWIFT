import Foundation
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var currentWeather: WeatherResponse? {
        didSet {
            print("✅ Updated currentWeather: \(String(describing: currentWeather?.city.name))") // ✅ Debugging
        }
    }

    private let weatherService = WeatherService()
    private let locationService = LocationService()

    func fetchWeatherForCurrentLocation(forceRefresh: Bool = false) {
        locationService.onLocationUpdate = { [weak self] location in
            Task {
                do {
                    print("📍 Fetching weather for: \(location.latitude), \(location.longitude)")
                    let weatherResponse = try await self?.weatherService.fetchWeather(lat: location.latitude, lon: location.longitude)
                    self?.currentWeather = weatherResponse
                    print("✅ Weather fetched")
                } catch {
                    print("❌ Error fetching weather: \(error.localizedDescription)")
                }
            }
        }
        locationService.requestLocation()  // ✅ Triggers permission request & fetches location
    }

    func setWeatherForCity(weatherResponse: WeatherResponse) {
        self.currentWeather = weatherResponse
    }
}
