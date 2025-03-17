import SwiftUI

struct MainWeatherView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel

    var body: some View {
        ScrollView { // ✅ Scrollable content
            VStack(spacing: 20) { // ✅ Adjust the spacing here
                if let weatherResponse = weatherViewModel.currentWeather {
                    CityInfoView(weatherResponse: weatherResponse)
                        .padding(.top, 10) // ✅ Adjust top spacing

                    SunTimeView(weatherResponse: weatherResponse)
                        .padding(.top, 5) // ✅ Adjust space between CityInfo and SunTime

                    HourlyForecastView(weatherResponse: weatherResponse)
                        .padding(.top, 10) // ✅ Adjust space between SunTime and Hourly

                    WeeklyForecastView(weatherResponse: weatherResponse)
                        .padding(.top, 10) // ✅ Adjust space between Hourly and Weekly
                } else {
                    ProgressView("Fetching weather...")
                        .padding(.top, 20)
                }

                NavigationLink(destination: SearchView()) {
                    Text("🔍 Search for a City")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20) // ✅ Adjust space before the button
                .padding(.bottom, 30) // ✅ Ensure spacing at the bottom for scrollability
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 0) // ✅ Optional padding on the sides for alignment
        }
        .onAppear {
            if weatherViewModel.currentWeather == nil {
                weatherViewModel.fetchWeatherForCurrentLocation(forceRefresh: false)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.156, green: 0.156, blue: 0.156))
        .edgesIgnoringSafeArea(.all)
    }
}
