import SwiftUI

struct WeeklyForecastView: View {
    let weatherResponse: WeatherResponse

    var weeklyData: [DailyWeather] {
        let groupedData = Dictionary(grouping: weatherResponse.list) { forecast in
            formatDay(forecast.dt, weatherResponse.city.timezone)
        }

        return groupedData.map { (day, forecasts) in
            let minTemp = forecasts.map { $0.main.temp_min }.min() ?? 0
            let maxTemp = forecasts.map { $0.main.temp_max }.max() ?? 0
            let description = forecasts.first?.weather.first?.description.capitalized ?? "N/A"
            let icon = mapWeatherIcon(forecasts.first?.weather.first?.icon ?? "01d")

            return DailyWeather(day: day, icon: icon, minTemp: Int(minTemp), maxTemp: Int(maxTemp), description: description)
        }
        .sorted { $0.day < $1.day }
    }

    var globalMinTemp: Int { weeklyData.map { $0.minTemp }.min() ?? 0 }
    var globalMaxTemp: Int { weeklyData.map { $0.maxTemp }.max() ?? 1 }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) { // ✅ Even spacing
            Text("Weekly Forecast")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 16)

            VStack(spacing: 0) {
                ForEach(weeklyData, id: \.day) { weather in
                    WeeklyWeatherRow(weather: weather, globalMin: globalMinTemp, globalMax: globalMaxTemp)
                    if weather.day != weeklyData.last?.day {
                        Divider().background(Color.white.opacity(0.1))
                    }
                }
            }
            .padding(.vertical, 8) // ✅ Inner padding without reducing box width
            .background(Color(red: 56/255, green: 56/255, blue: 56/255)) // ✅ Dark gray box
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 16)
        }
        .background(Color(red: 0.156, green: 0.156, blue: 0.156))
    }
}

// ✅ **Row UI for Each Day**
struct WeeklyWeatherRow: View {
    let weather: DailyWeather
    let globalMin: Int
    let globalMax: Int

    var body: some View {
        HStack(spacing: 20) {
            Text(weather.day)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 50, alignment: .leading)

            Image(systemName: weather.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 23, height: 23) // ✅ Fixed size
                .foregroundColor(.white)

            Text("\(weather.minTemp)°")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 30, alignment: .trailing)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 6)
                        .foregroundColor(Color.white.opacity(0.2))

                    let minOffset = CGFloat(weather.minTemp - globalMin) / CGFloat(globalMax - globalMin)
                    let width = CGFloat(weather.maxTemp - weather.minTemp) / CGFloat(globalMax - globalMin)

                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: geometry.size.width * width, height: 6)
                        .foregroundColor(Color(red: 0.89, green: 0.14, blue: 0.42))
                        .offset(x: geometry.size.width * minOffset)
                }
            }
            .frame(width: 100, height: 6) // ✅ Shorter width, smaller height
            .padding(.horizontal, 4)

            Text("\(weather.maxTemp)°")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 30, alignment: .leading)
        }
        .padding(.vertical, 8) // ✅ Even spacing
    }
}

// ✅ **Weather Data Model for Weekly Forecast**
struct DailyWeather {
    let day: String
    let icon: String
    let minTemp: Int
    let maxTemp: Int
    let description: String
}
