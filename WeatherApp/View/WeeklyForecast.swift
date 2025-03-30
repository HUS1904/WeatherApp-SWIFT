import SwiftUI

struct WeeklyForecastView: View {
    let weatherResponse: WeatherResponse

    var weeklyData: [DailyWeather] {
        guard let dailyForecasts = weatherResponse.daily else { return [] }

        return dailyForecasts.enumerated().map { index, forecast in
            let day = index == 0 ? "Today" : formatDay(forecast.dt, weatherResponse.timezoneOffset)
            let icon = mapWeatherIcon(forecast.weather.first?.icon ?? "01d")
            let description = forecast.weather.first?.description.capitalized ?? "N/A"
            let minTemp = Int(forecast.temp.min)
            let maxTemp = Int(forecast.temp.max)

            return DailyWeather(day: day, icon: icon, minTemp: minTemp, maxTemp: maxTemp, description: description)
        }
    }

    var globalMinTemp: Int {
        weeklyData.map { $0.minTemp }.min() ?? 0
    }

    var globalMaxTemp: Int {
        weeklyData.map { $0.maxTemp }.max() ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
            .padding(.vertical, 8)
            .background(Color(red: 56 / 255, green: 56 / 255, blue: 56 / 255))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 16)
            .shadow(radius: 2)
        }
        .background(Color(red: 0.156, green: 0.156, blue: 0.156))
    }
}

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
                .frame(width: 23, height: 23)
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
            .frame(width: 100, height: 6)
            .padding(.horizontal, 4)

            Text("\(weather.maxTemp)°")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 30, alignment: .leading)
        }
        .padding(.vertical, 8)
    }
}

struct DailyWeather {
    let day: String
    let icon: String
    let minTemp: Int
    let maxTemp: Int
    let description: String
}
