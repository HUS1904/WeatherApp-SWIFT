import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weatherList: [WeatherForecast] = []
    @Published var cityName: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let weatherService = WeatherService()

    func fetchWeather(for city: String) {
        isLoading = true
        Task {
            do {
                let weatherResponse = try await weatherService.fetchWeather(for: city)
                self.weatherList = weatherResponse.list
                self.cityName = weatherResponse.city.name
                self.errorMessage = nil
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
