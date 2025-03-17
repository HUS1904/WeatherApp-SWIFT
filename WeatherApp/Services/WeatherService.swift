import Foundation

class WeatherService {
    private let apiKey = APIKey.openWeatherAPIKey
    private let baseURL = "https://api.openweathermap.org/data/2.5/forecast"

    // ✅ Fetch weather by city name (Used for search)
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        let urlString = "\(baseURL)?q=\(city)&appid=\(apiKey)&units=metric"
        return try await fetchWeatherData(from: urlString)
    }

    // ✅ Fetch weather by coordinates (Used at app launch)
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        let urlString = "\(baseURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        return try await fetchWeatherData(from: urlString)
    }

    // ✅ Helper function for API calls
    private func fetchWeatherData(from urlString: String) async throws -> WeatherResponse {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.requestFailed
        }

        do {
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return weatherResponse
        } catch {
            throw APIError.decodingError
        }
    }
}
