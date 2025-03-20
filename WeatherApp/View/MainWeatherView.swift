import SwiftUI

struct MainWeatherView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @State private var isSearchPresented = false // ✅ Controls the search screen presentation

    var body: some View {
        ScrollView {
            VStack(spacing: 5) { // ✅ Reduced spacing to minimize gaps
                // ✅ Search button
                HStack {
                    Button(action: { isSearchPresented = true }) {
                        Image(systemName: "rectangle.and.text.magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .symbolRenderingMode(.palette) // ✅ Enables multi-color rendering
                            .foregroundStyle(.white, Color(red: 0.89, green: 0.14, blue: 0.42)) // ✅ White main color, accent applied
                            .font(.system(size: 30, weight: .bold, design: .default)) // ✅ Makes the icon bold/black
                    }
                    .padding(.top, 70) // ✅ Reduced top padding
                    .padding(.leading, 16) // ✅ Adjust horizontal positioning
                    .frame(maxWidth: .infinity, alignment: .leading) // ✅ Ensures left alignment

                    Spacer()
                }

                // ✅ Weather components without excessive padding
                if let weatherResponse = weatherViewModel.currentWeather {
                    CityInfoView(weatherResponse: weatherResponse)
                        .padding(.top, -80) 

                    SunTimeView(weatherResponse: weatherResponse)
                        .padding(.top, 2) // ✅ Slightly reduced

                    HourlyForecastView(weatherResponse: weatherResponse)
                        .padding(.top, 5) // ✅ Slightly reduced

                    WeeklyForecastView(weatherResponse: weatherResponse)
                        .padding(.top, 5) // ✅ Slightly reduced
                } else {
                    ProgressView("Fetching weather...")
                        .padding(.top, 15) // ✅ Slightly reduced
                }
            }
            .frame(maxWidth: .infinity) // ✅ Keeps everything aligned properly
        }
        .onAppear {
            if weatherViewModel.currentWeather == nil {
                weatherViewModel.fetchWeatherForCurrentLocation(forceRefresh: false)
            }
        }
        .background(Color(red: 0.156, green: 0.156, blue: 0.156))
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $isSearchPresented) { // ✅ Opens SearchView
            SearchView()
        }
    }
}
