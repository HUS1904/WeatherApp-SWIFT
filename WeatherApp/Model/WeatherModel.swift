import Foundation

struct WeatherResponse: Codable {
    let list: [WeatherForecast]
    let city: CityInfo
}

struct WeatherForecast: Codable {
    let dt: Int
    let main: MainWeather
    let weather: [WeatherDetail]
    let wind: Wind
    let clouds: Clouds
    let visibility: Int
    let dt_txt: String
}

struct MainWeather: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct WeatherDetail: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

struct Clouds: Codable {
    let all: Int
}

struct CityInfo: Codable {
    let name: String
    let coord: Coordinates
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}
