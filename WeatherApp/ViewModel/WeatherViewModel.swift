import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var currentWeather: WeatherResponse?

    private let weatherService = WeatherService()
    private let locationService = LocationService()

    func fetchWeatherForCurrentLocation() {
        locationService.onLocationUpdate = { [weak self] location in
            Task {
                do {
                    print("📍 Fetching weather for: \(location.latitude), \(location.longitude)")
                    let weather = try await self?.weatherService.fetchWeather(lat: location.latitude, lon: location.longitude)
                    self?.currentWeather = weather
                    print("✅ Weather fetched: \(String(describing: weather))")
                } catch {
                    print("❌ Error fetching weather: \(error.localizedDescription)")
                }
            }
        }
        locationService.requestLocation()
    }

    func setWeatherForCity(weatherData: WeatherResponse) { // ✅ Ensure this method exists
        self.currentWeather = weatherData
    }
}
