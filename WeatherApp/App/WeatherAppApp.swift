import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject private var searchViewModel = SearchViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainWeatherView()
            }
            .environmentObject(weatherViewModel)
            .environmentObject(searchViewModel)
        }
    }
}
