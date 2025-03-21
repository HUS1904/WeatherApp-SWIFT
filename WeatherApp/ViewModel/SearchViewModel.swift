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
        let normalizedCityName = city.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedCountry = city.country.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        let isAlreadySaved = savedCities.contains { savedCity in
            return savedCity.city.name.lowercased() == normalizedCityName &&
                   savedCity.city.country.lowercased() == normalizedCountry &&
                   abs(savedCity.city.coord.lat - city.lat) < 0.0001 &&
                   abs(savedCity.city.coord.lon - city.lon) < 0.0001
        }

        guard !isAlreadySaved else {
            print("⚠️ City is already in the list: \(city.name), \(city.country)")
            return
        }

        print("✅ City is new, adding: \(city.name), \(city.country)")

        Task {
            do {
                let weather = try await weatherService.fetchWeather(lat: city.lat, lon: city.lon)

                let correctedWeather = WeatherResponse(
                    cod: weather.cod,
                    message: weather.message,
                    cnt: weather.cnt,
                    list: weather.list,
                    city: CityInfo(
                        id: weather.city.id ?? Int("\(city.lat)\(city.lon)".hashValue),
                        name: city.name,
                        coord: Coordinates(lat: city.lat, lon: city.lon),
                        country: city.country,
                        population: weather.city.population,
                        timezone: weather.city.timezone,
                        sunrise: weather.city.sunrise,
                        sunset: weather.city.sunset
                    )
                )

                DispatchQueue.main.async {
                    self.savedCities.append(correctedWeather)
                    print("✅ Weather fetched and saved: \(correctedWeather.city.name), \(correctedWeather.city.country)")
                }
            } catch {
                print("❌ Error fetching weather for '\(city.name)': \(error)")
            }
        }
    }

    func addCurrentLocation(latitude: Double, longitude: Double, weatherResponse: WeatherResponse) {
        let isAlreadySaved = savedCities.contains { savedCity in
            abs(savedCity.city.coord.lat - latitude) < 0.01 &&
            abs(savedCity.city.coord.lon - longitude) < 0.01
        }

        guard !isAlreadySaved else {
            print("⚠️ Current location already saved: \(weatherResponse.city.name)")
            return
        }

        DispatchQueue.main.async {
            self.savedCities.insert(weatherResponse, at: 0)
            print("✅ Current location added: \(weatherResponse.city.name)")
        }
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

    func removeCity(_ weatherResponse: WeatherResponse) {
        print("🗑 Deleting: \(weatherResponse.city.name)")
        print("Before: \(savedCities.map { $0.city.name })")
        savedCities.removeAll {
            $0.city.name == weatherResponse.city.name &&
            $0.city.country == weatherResponse.city.country &&
            abs($0.city.coord.lat - weatherResponse.city.coord.lat) < 0.0001 &&
            abs($0.city.coord.lon - weatherResponse.city.coord.lon) < 0.0001
        }
        print("After: \(savedCities.map { $0.city.name })")

    }
}
