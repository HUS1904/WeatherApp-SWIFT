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
                print("Error searching city '\(cityName)': \(error.localizedDescription)")
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
        
        print("Checking for duplicate: \(city.name), \(city.country) -> Already saved? \(isAlreadySaved)")

        guard !isAlreadySaved else {
            print("City already saved: \(city.name), \(city.country)")
            return
        }

        var weather = try await weatherService.fetchWeather(lat: city.lat, lon: city.lon)
        weather.cityName = city.name
        weather.country = city.country
        weather.id = UUID()
        weather.isFavorite = false
        savedCities.append(weather)
        print("Added new city: \(weather.cityName), \(weather.country)")
    }


    func addCurrentLocation(latitude: Double, longitude: Double, weatherResponse: WeatherResponse) {
        let isAlreadySaved = savedCities.contains { saved in
            abs(saved.lat - latitude) < 0.01 && abs(saved.lon - longitude) < 0.01
        }

        guard !isAlreadySaved else {
            print("Current location already saved: \(weatherResponse.cityName)")
            return
        }

        var current = weatherResponse
        current.isFavorite = false
        savedCities.insert(current, at: 0)
        print("✅ Current location added: \(current.cityName)")
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
            let encoder = JSONEncoder()
            let data = try encoder.encode(favoritesOnly)
            let url = getCitiesFileURL()
            try data.write(to: url)
            print("✅ Favorites saved to file")
        } catch {
            print("❌ Error saving cities to file: \(error)")
        }
    }

    func loadCities() {
        let url = getCitiesFileURL()
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("⚠️ No saved cities file found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let cachedFavorites = try decoder.decode([WeatherResponse].self, from: data)
            savedCities = cachedFavorites // ✅ Not append
            print("✅ Cities loaded from file")
        } catch {
            print("❌ Error loading cities from file: \(error)")
        }
    }

    func getCitiesFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("cities.json")
    }
}
