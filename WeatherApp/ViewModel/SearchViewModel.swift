import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var savedCities: [WeatherResponse] = []
    @Published var searchResults: [CitySearchResult] = []

    private let weatherService = WeatherService()

    func searchCity(cityName: String) {
        guard cityName.count > 2 else {
            searchResults = []
            return
        }

        Task {
            do {
                searchResults = try await weatherService.searchCity(cityName: cityName)
            } catch {
                print("❌ Error searching city '\(cityName)': \(error.localizedDescription)")
                searchResults = []
            }
        }
    }

    func addCity(_ city: CitySearchResult) {
        Task {
            do {
                let weather = try await weatherService.fetchWeather(lat: city.lat, lon: city.lon)
                DispatchQueue.main.async {
                    self.savedCities.append(weather)
                    print("✅ Weather fetched for city: \(city.name)")
                }
            } catch {
                print("❌ Error adding city '\(city.name)': \(error)")
            }
        }
    }


}
