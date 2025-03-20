import Foundation

class WeatherService {
    private let apiKey = APIKey.openWeatherAPIKey
    private let baseURL = "https://api.openweathermap.org/data/2.5/forecast"

    // ✅ Fetch weather by coordinates (Used after fetching coordinates from search)
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        let urlString = "\(baseURL)?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        return try await fetchWeatherData(from: urlString)
    }

    // ✅ Search cities (returns city details including coordinates)
    func searchCity(cityName: String) async throws -> [CitySearchResult] {
        let encodedCity = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cityName
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(encodedCity)&limit=5&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.requestFailed
        }

        do {
            return try JSONDecoder().decode([CitySearchResult].self, from: data)
        } catch {
            // Replace "decodingFailed" with the already existing "decodingError":
            throw APIError.decodingError

        }
    }

    // ✅ Reusable fetch logic
    private func fetchWeatherData(from urlString: String) async throws -> WeatherResponse {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.requestFailed
        }

        // Temporary debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("🟢 JSON Response: \(jsonString)")
        }

        do {
            return try JSONDecoder().decode(WeatherResponse.self, from: data)
        } catch {
            print("❌ Decoding error: \(error)")
            throw APIError.decodingError
        }
    }

}

// ✅ Model to decode city search results from Geo API
struct CitySearchResult: Codable, Identifiable {
    let id = UUID()
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {
        case name, lat, lon, country, state
    }
}
