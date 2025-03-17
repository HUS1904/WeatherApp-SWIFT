import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject private var searchViewModel = SearchViewModel() // ✅ Add this

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainWeatherView()
            }
            .environmentObject(weatherViewModel)
            .environmentObject(searchViewModel) // ✅ Inject SearchViewModel here
        }
    }
}
