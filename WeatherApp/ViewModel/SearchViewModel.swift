import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var savedCities: [WeatherResponse] = []
    @Published var searchResults: [CitySearchResult] = []

    private let weatherService = WeatherService()
    private let savedCitiesKey = "savedCitiesKey"
    
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

    func addCity(_ city: CitySearchResult) {
        let normalizedCityName = city.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedCountry = city.country.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        let isAlreadySaved = savedCities.contains { saved in
            return saved.cityName.lowercased() == normalizedCityName &&
                   saved.country.lowercased() == normalizedCountry &&
                   abs(saved.lat - city.lat) < 0.0001 &&
                   abs(saved.lon - city.lon) < 0.0001
        }

        guard !isAlreadySaved else {
            print("City already saved: \(city.name), \(city.country)")
            return
        }

        Task {
            do {
                var weather = try await weatherService.fetchWeather(lat: city.lat, lon: city.lon)
                weather.cityName = city.name
                weather.country = city.country
                weather.id = UUID() // ✅ Assign a new UUID
                savedCities.append(weather)
                saveCities()
                print("Added new city: \(weather.cityName), \(weather.country)")
            } catch {
                print("Error fetching weather for city '\(city.name)': \(error)")
            }
        }
    }

    func addCurrentLocation(latitude: Double, longitude: Double, weatherResponse: WeatherResponse) {
        let isAlreadySaved = savedCities.contains { saved in
            abs(saved.lat - latitude) < 0.01 && abs(saved.lon - longitude) < 0.01
        }

        guard !isAlreadySaved else {
            print("Current location already saved: \(weatherResponse.cityName)")
            return
        }

        savedCities.insert(weatherResponse, at: 0)
        print("Current location added: \(weatherResponse.cityName)")
    }

    func removeCity(_ weather: WeatherResponse) {
        print("Removing: \(weather.cityName)")
        savedCities.removeAll { $0.id == weather.id }
        saveCities()
    }

    func clearSearchResults() {
        searchResults.removeAll()
    }

    func clearSearch() {
        searchResults.removeAll()
    }

    func addCityAndClearSearch(_ city: CitySearchResult) {
        addCity(city)
        clearSearch()
    }
    
    func saveCities() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(savedCities)
            let url = getCitiesFileURL()
            try data.write(to: url)
            print("Cities saved to file")
        } catch {
            print("Error saving cities to file: \(error)")
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
            savedCities = try decoder.decode([WeatherResponse].self, from: data)
            print("✅ Cities loaded from file")
        } catch {
            print("❌ Error loading cities from file: \(error)")
        }
    }
    
    private func getCitiesFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("cities.json")
    }
}
