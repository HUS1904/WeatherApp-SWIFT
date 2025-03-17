import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var savedCities: [WeatherResponse] = []

    func searchCity(cityName: String) {
        if savedCities.contains(where: { $0.city.name.lowercased() == cityName.lowercased() }) {
                print("⚠️ City already exists in saved list: \(cityName)")
                return
        }
        
        Task {
            do {
                let weatherData = try await WeatherService().fetchWeather(for: cityName)
                DispatchQueue.main.async {
                    self.savedCities.append(weatherData)
                }
                print("✅ Weather fetched")
            } catch {
                print("❌ Error searching city: \(error.localizedDescription)")
            }
        }
    }
}
