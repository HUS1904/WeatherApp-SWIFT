import Foundation
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weatherResponse: WeatherResponse? {
        didSet {
            print("Updated currentWeather: \(String(describing: weatherResponse?.cityName))")
        }
    }

    private var weatherService = WeatherService()
    private var locationService = LocationService()
    
    init(weatherService: WeatherService = WeatherService(), locationService: LocationService = LocationService()) {
        self.weatherService = weatherService
        self.locationService = locationService
        fetchWeatherForCurrentLocation()
    }

    func fetchWeatherForCurrentLocation(forceRefresh: Bool = false) {
        locationService.onLocationUpdate = { [weak self] location in
            Task {
                do {
                    print("Fetching weather for: \(location.latitude), \(location.longitude)")
                    if var weatherResponse = try await self?.weatherService.fetchWeather(lat: location.latitude, lon: location.longitude) {
                        weatherResponse.id = UUID()
                        self?.weatherResponse = weatherResponse
                    }
                } catch {
                    print("Error fetching weather: \(error.localizedDescription)")
                }
            }
        }
        locationService.requestLocation()
    }

    func setWeatherForCity(weatherResponse: WeatherResponse) {
        self.weatherResponse = weatherResponse
    }
    
    func setWeatherForCoordinates(lat: Double, lon: Double) async {
        do {
            var weather = try await weatherService.fetchWeather(lat: lat, lon: lon)
            weather.id = UUID()
            self.weatherResponse = weather
        } catch {
            print("Failed to fetch weather: \(error.localizedDescription)")
        }
    }

}
