import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var savedCities: [WeatherResponse] = []
    @Published var searchResults: [CitySearchResult] = []

    private let weatherService = WeatherService()

    init() {
        loadCities()
    }

    func searchCity(cityName: String) {
        guard cityName.count > 2 else {
            searchResults = []
            return
        }

        Task {
            do {
                searchResults = try await weatherService.searchCity(cityName: cityName)
            } catch {
                searchResults = []
            }
        }
    }

    func addCity(_ city: CitySearchResult) async throws {
        let isAlreadySaved = savedCities.contains { saved in
            saved.cityName.caseInsensitiveCompare(city.name) == .orderedSame &&
            saved.country.caseInsensitiveCompare(city.country) == .orderedSame &&
            abs(saved.lat - city.lat) < 0.0001 &&
            abs(saved.lon - city.lon) < 0.0001
        }

        guard !isAlreadySaved else { return }

        var weather = try await weatherService.fetchWeather(lat: city.lat, lon: city.lon)
        weather.cityName = city.name
        weather.country = city.country
        weather.id = UUID()
        weather.isFavorite = false
        savedCities.append(weather)
    }

    func addCurrentLocation(latitude: Double, longitude: Double, weatherResponse: WeatherResponse) {
        let isAlreadySaved = savedCities.contains {
            abs($0.lat - latitude) < 0.01 && abs($0.lon - longitude) < 0.01
        }

        guard !isAlreadySaved else { return }

        var current = weatherResponse
        current.isFavorite = false
        savedCities.insert(current, at: 0)
    }

    func removeCity(_ weather: WeatherResponse) {
        savedCities.removeAll { $0.id == weather.id }
        saveCities()
    }

    func toggleFavorite(for city: WeatherResponse) {
        guard let index = savedCities.firstIndex(where: { $0.id == city.id }) else { return }
        savedCities[index].isFavorite.toggle()
        saveCities()
    }

    func addCityAndClearSearch(_ city: CitySearchResult) async throws {
        try await addCity(city)
        clearSearch()
    }

    func clearSearchResults() {
        searchResults.removeAll()
    }

    func clearSearch() {
        searchResults.removeAll()
    }

    func saveCities() {
        do {
            let favoritesOnly = savedCities.filter { $0.isFavorite }
            let data = try JSONEncoder().encode(favoritesOnly)
            try data.write(to: getCitiesFileURL())
        } catch {
            // Handle silently in production
        }
    }

    func loadCities() {
        let url = getCitiesFileURL()
        guard FileManager.default.fileExists(atPath: url.path) else { return }

        do {
            let data = try Data(contentsOf: url)
            savedCities = try JSONDecoder().decode([WeatherResponse].self, from: data)
        } catch {
            // Handle silently in production
        }
    }

    func getCitiesFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("cities.json")
    }
}
