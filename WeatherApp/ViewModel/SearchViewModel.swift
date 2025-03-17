import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var savedCities: [WeatherResponse] = []
    private let weatherService = WeatherService()

    func searchCity(cityName: String) {
        Task {
            do {
                let weather = try await weatherService.fetchWeather(for: cityName)
                savedCities.append(weather)
            } catch {
                print("Error searching city: \(error.localizedDescription)")
            }
        }
    }
}
