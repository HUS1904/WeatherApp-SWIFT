import Foundation

struct WeatherResponse: Codable, Equatable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: CurrentWeather
    let minutely: [MinutelyForecast]?
    let hourly: [HourlyForecast]?
    let daily: [DailyForecast]?
    let alerts: [WeatherAlert]?

    // Manually added
    var cityName: String = ""
    var country: String = ""

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, minutely, hourly, daily, alerts
    }

    static func == (lhs: WeatherResponse, rhs: WeatherResponse) -> Bool {
        return lhs.lat == rhs.lat &&
               lhs.lon == rhs.lon &&
               lhs.cityName == rhs.cityName &&
               lhs.country == rhs.country
    }
}

struct CurrentWeather: Codable, Equatable {
    let dt: Int
    let sunrise: Int?
    let sunset: Int?
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [WeatherDetail]

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

struct MinutelyForecast: Codable, Equatable {
    let dt: Int
    let precipitation: Double
}

struct HourlyForecast: Codable, Equatable {
    let dt: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [WeatherDetail]
    let pop: Double?

    enum CodingKeys: String, CodingKey {
        case dt, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, pop
    }
}

struct DailyForecast: Codable, Equatable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let summary: String? // ✅ New field added here
    let temp: Temperature
    let feelsLike: FeelsLike
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [WeatherDetail]
    let clouds: Int
    let pop: Double
    let uvi: Double
    let rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case summary // ✅ Included in CodingKeys
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi, rain
    }
}


struct Temperature: Codable, Equatable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct FeelsLike: Codable, Equatable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct WeatherDetail: Codable, Equatable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct WeatherAlert: Codable, Equatable {
    let senderName: String
    let event: String
    let start: Int
    let end: Int
    let description: String
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case event, start, end, description, tags
    }
}
