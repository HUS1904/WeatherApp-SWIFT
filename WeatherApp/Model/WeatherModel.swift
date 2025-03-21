import Foundation

struct WeatherResponse: Codable, Equatable {
    let cod: String
    let message: Int?
    let cnt: Int?
    let list: [WeatherForecast]
    let city: CityInfo

    // ✅ Implement Equatable manually
    static func == (lhs: WeatherResponse, rhs: WeatherResponse) -> Bool {
        return lhs.city.name == rhs.city.name &&
               lhs.city.coord.lat == rhs.city.coord.lat &&
               lhs.city.coord.lon == rhs.city.coord.lon
    }
}

struct CityInfo: Codable, Equatable {
    let id: Int?
    let name: String
    let coord: Coordinates
    let country: String
    let population: Int?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
}

struct Coordinates: Codable, Equatable {
    let lat: Double
    let lon: Double
}

struct WeatherForecast: Codable, Equatable {
    let dt: Int
    let main: MainWeather
    let weather: [WeatherDetail]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int?
    let pop: Double?
    let sys: Sys
    let dt_txt: String
    let rain: Rain?
}

struct MainWeather: Codable, Equatable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct WeatherDetail: Codable, Equatable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Clouds: Codable, Equatable {
    let all: Int
}

struct Wind: Codable, Equatable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Sys: Codable, Equatable {
    let pod: String
}

struct Rain: Codable, Equatable {
    let last3Hours: Double?

    enum CodingKeys: String, CodingKey {
        case last3Hours = "3h"
    }
}
