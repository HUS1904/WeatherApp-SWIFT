import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject var weatherViewModel = WeatherViewModel()
    @StateObject var searchViewModel = SearchViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainWeatherView()
                    .environmentObject(weatherViewModel) // ✅ Provide WeatherViewModel
                    .environmentObject(searchViewModel)  // ✅ Provide SearchViewModel
            }
        }
    }
}
