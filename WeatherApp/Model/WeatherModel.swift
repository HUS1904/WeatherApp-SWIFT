import Foundation

struct WeatherResponse: Codable, Equatable, Identifiable {
    var id: UUID = UUID()  // Provide fallback value
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: CurrentWeather
    let minutely: [MinutelyForecast]?
    let hourly: [HourlyForecast]?
    let daily: [DailyForecast]?
    let alerts: [WeatherAlert]?
    var cityName: String = ""
    var country: String = ""
    var isFavorite: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, minutely, hourly, daily, alerts, cityName, country, isFavorite
    }

    // ✅ Custom init to provide fallback ID if missing
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        lat = try container.decode(Double.self, forKey: .lat)
        lon = try container.decode(Double.self, forKey: .lon)
        timezone = try container.decode(String.self, forKey: .timezone)
        timezoneOffset = try container.decode(Int.self, forKey: .timezoneOffset)
        current = try container.decode(CurrentWeather.self, forKey: .current)
        minutely = try container.decodeIfPresent([MinutelyForecast].self, forKey: .minutely)
        hourly = try container.decodeIfPresent([HourlyForecast].self, forKey: .hourly)
        daily = try container.decodeIfPresent([DailyForecast].self, forKey: .daily)
        alerts = try container.decodeIfPresent([WeatherAlert].self, forKey: .alerts)
        cityName = try container.decodeIfPresent(String.self, forKey: .cityName) ?? ""
        country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }

    // Required for Encodable conformance
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
        try container.encode(timezone, forKey: .timezone)
        try container.encode(timezoneOffset, forKey: .timezoneOffset)
        try container.encode(current, forKey: .current)
        try container.encodeIfPresent(minutely, forKey: .minutely)
        try container.encodeIfPresent(hourly, forKey: .hourly)
        try container.encodeIfPresent(daily, forKey: .daily)
        try container.encodeIfPresent(alerts, forKey: .alerts)
        try container.encode(cityName, forKey: .cityName)
        try container.encode(country, forKey: .country)
        try container.encode(isFavorite, forKey: .isFavorite)
    }

    static func == (lhs: WeatherResponse, rhs: WeatherResponse) -> Bool {
        lhs.id == rhs.id
    }
    
    init(
        id: UUID = UUID(),
        lat: Double,
        lon: Double,
        timezone: String,
        timezoneOffset: Int,
        current: CurrentWeather,
        minutely: [MinutelyForecast]? = nil,
        hourly: [HourlyForecast]? = nil,
        daily: [DailyForecast]? = nil,
        alerts: [WeatherAlert]? = nil,
        cityName: String = "",
        country: String = "",
        isFavorite: Bool = false
    ) {
        self.id = id
        self.lat = lat
        self.lon = lon
        self.timezone = timezone
        self.timezoneOffset = timezoneOffset
        self.current = current
        self.minutely = minutely
        self.hourly = hourly
        self.daily = daily
        self.alerts = alerts
        self.cityName = cityName
        self.country = country
        self.isFavorite = isFavorite
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
    let summary: String?
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
        case summary
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
