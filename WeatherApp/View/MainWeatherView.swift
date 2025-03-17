import SwiftUI

struct MainWeatherView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel

    var body: some View {
        VStack {
            if let weather = weatherViewModel.currentWeather {
                CityInfoView(
                    cityName: weather.city.name,
                    country: weather.city.country,
                    description: weather.list.first?.weather.first?.description ?? "N/A"
                )
            } else {
                ProgressView("Fetching weather...")
            }

            Spacer()

            NavigationLink(destination: SearchView()) {
                Text("🔍 Search for a City")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            weatherViewModel.fetchWeatherForCurrentLocation()
        }
    }
}

#Preview {
    MainWeatherView()
        .environmentObject(mockWeatherViewModel()) // ✅ Provide mock data
}

// ✅ Fix: Ensure mock function is marked as `@MainActor`
@MainActor
func mockWeatherViewModel() -> WeatherViewModel {
    let viewModel = WeatherViewModel()
    viewModel.currentWeather = WeatherResponse(
        list: [
            WeatherForecast(
                dt: 1640000000,
                main: MainWeather(temp: 22.5, feels_like: 21.0, temp_min: 20.0, temp_max: 25.0, pressure: 1012, humidity: 60),
                weather: [WeatherDetail(main: "Cloudy", description: "Partly cloudy", icon: "02d")],
                wind: Wind(speed: 3.0, deg: 180, gust: 5.0),
                clouds: Clouds(all: 20),
                visibility: 10000,
                dt_txt: "2025-03-17 12:00:00"
            )
        ],
        city: CityInfo(
            name: "Copenhagen",
            coord: Coordinates(lat: 55.6761, lon: 12.5683),
            country: "Denmark",
            sunrise: 1640000000,
            sunset: 1640030000
        )
    )
    return viewModel
}
