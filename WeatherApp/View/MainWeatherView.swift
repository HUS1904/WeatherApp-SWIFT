import SwiftUI

struct MainWeatherView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    @State private var isSearchPresented = false

    var body: some View {
        ScrollView {
            VStack(spacing: 5) {
                HStack {
                    Button(action: { isSearchPresented = true }) {
                        Image(systemName: "rectangle.and.text.magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, Color(red: 0.89, green: 0.14, blue: 0.42))
                            .font(.system(size: 30, weight: .bold))
                    }
                    .padding(.top, 70)
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()
                }

                if let weatherResponse = weatherViewModel.currentWeather {
                    CityInfoView(weatherResponse: weatherResponse)
                        .padding(.top, -80)

                    SunTimeView(weatherResponse: weatherResponse)
                        .padding(.top, 2)

                    HourlyForecastView(weatherResponse: weatherResponse)
                        .padding(.top, 30)

                    WeeklyForecastView(weatherResponse: weatherResponse)
                        .padding(.top, 30)
                } else {
                    ProgressView("Fetching weather...")
                        .padding(.top, 15)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            weatherViewModel.fetchWeatherForCurrentLocation(forceRefresh: false)
        }
        .onChange(of: weatherViewModel.currentWeather) { newWeather in
            if let weather = newWeather {
                searchViewModel.addCurrentLocation(
                    latitude: weather.city.coord.lat,
                    longitude: weather.city.coord.lon,
                    weatherResponse: weather
                )
            }
        }
        .background(Color(red: 0.156, green: 0.156, blue: 0.156))
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $isSearchPresented) {
            SearchView()
        }
    }
}
