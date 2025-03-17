import Foundation

struct WeatherResponse: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [WeatherForecast]
    let city: CityInfo
}

struct CityInfo: Codable {
    let id: Int
    let name: String
    let coord: Coordinates
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}

struct WeatherForecast: Codable {
    let dt: Int
    let main: MainWeather
    let weather: [WeatherDetail]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dt_txt: String
    let rain: Rain?
}

struct MainWeather: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct WeatherDetail: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Clouds: Codable {
    let all: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Sys: Codable {
    let pod: String // ✅ "d" for day, "n" for night
}

struct Rain: Codable {
    let last3Hours: Double?

    enum CodingKeys: String, CodingKey {
        case last3Hours = "3h" // ✅ Matches API response key
    }
}
