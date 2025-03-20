import SwiftUI

struct HourlyForecastView: View {
    let weatherResponse: WeatherResponse

    init(weatherResponse: WeatherResponse) {
        self.weatherResponse = weatherResponse
    }

    var hourlyData: [HourlyWeather] {
        let processedData = weatherResponse.list.map { forecast in
            let time = formatUnixTime(forecast.dt, weatherResponse.city.timezone ?? 0)
            let icon = mapWeatherIcon(forecast.weather.first?.icon ?? "01d")
            let description = forecast.weather.first?.description.capitalized ?? "N/A"
            let temp = "\(Int(forecast.main.temp))°"

            return HourlyWeather(time: time, icon: icon, description: description, temp: temp)
        }

        return processedData
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) { // ✅ Even spacing
            Text("Hourly Forecast")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(hourlyData.indices, id: \.self) { index in
                        HourlyWeatherView(weather: hourlyData[index], isFirst: index == 0)
                    }
                }
                .padding(.horizontal, 16)
            }

            Spacer()
        }
        .background(Color(red: 0.156, green: 0.156, blue: 0.156))
    }
}

struct HourlyWeatherView: View {
    let weather: HourlyWeather
    let isFirst: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text(weather.time)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)

            Image(systemName: weather.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 23, height: 23) // ✅ Fixed size
                .foregroundColor(.white)

            Text(weather.description)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            Text(weather.temp)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .padding()
        .frame(width: 75, height: 140)
        .background(isFirst ? Color(red: 0.89, green: 0.14, blue: 0.42) : Color(red: 56/255, green: 56/255, blue: 56/255))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct HourlyWeather {
    let time: String
    let icon: String
    let description: String
    let temp: String
}
