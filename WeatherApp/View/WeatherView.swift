import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city = "Copenhagen"

    var body: some View {
        VStack {
            TextField("Enter city", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Get Forecast") {
                viewModel.fetchWeather(for: city)
            }
            .padding()

            if viewModel.isLoading {
                ProgressView()
            } else if !viewModel.weatherList.isEmpty {
                Text(viewModel.cityName)
                    .font(.title)

                List(viewModel.weatherList, id: \.dt) { forecast in
                    HStack {
                        Text(forecast.dt_txt)
                        Spacer()
                        Text("\(forecast.main.temp, specifier: "%.1f")°C")
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
#Preview {
    WeatherView()
}
