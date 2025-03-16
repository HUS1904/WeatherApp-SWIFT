import Foundation

class WeatherService {
    private let apiKey = APIKey.openWeatherAPIKey
    private let baseURL = "https://api.openweathermap.org/data/2.5/forecast"

    func fetchWeather(for city: String) async throws -> WeatherResponse {
        let urlString = "\(baseURL)?q=\(city)&appid=\(apiKey)&units=metric"
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
