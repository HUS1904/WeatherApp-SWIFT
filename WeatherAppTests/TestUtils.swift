import Foundation
@testable import WeatherApp

extension WeatherResponse {
    static func dummy(
        id: UUID = UUID(),
        cityName: String = "TestCity",
        country: String = "TC",
        lat: Double = 12.34,
        lon: Double = 56.78,
        isFavorite: Bool = false
    ) -> WeatherResponse {
        return WeatherResponse(
            id: id,
            lat: lat,
            lon: lon,
            timezone: "UTC",
            timezoneOffset: 0,
            current: CurrentWeather(
                dt: Int(Date().timeIntervalSince1970),
                sunrise: nil,
                sunset: nil,
                temp: 22.0,
                feelsLike: 21.5,
                pressure: 1013,
                humidity: 60,
                dewPoint: 10.0,
                uvi: 5.0,
                clouds: 10,
                visibility: 10000,
                windSpeed: 3.4,
                windDeg: 90,
                weather: [
                    WeatherDetail(id: 800, main: "Clear", description: "clear sky", icon: "01d")
                ]
            ),
            minutely: nil,
            hourly: nil,
            daily: nil,
            alerts: nil,
            cityName: cityName,
            country: country,
            isFavorite: isFavorite
        )
    }
}
