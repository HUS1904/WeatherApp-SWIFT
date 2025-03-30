import Foundation
import SwiftUI

func formatUnixTime(_ timestamp: Int, _ timeZoneOffset: Int) -> String {
    let adjustedTime = timestamp
    let date = Date(timeIntervalSince1970: TimeInterval(adjustedTime))

    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    formatter.timeZone = TimeZone(secondsFromGMT: timeZoneOffset)

    return formatter.string(from: date)
}

func mapWeatherIcon(_ iconCode: String) -> String {
    switch iconCode {
    case "01d": return "sun.max.fill"
    case "01n": return "moon.fill"
    case "02d", "02n": return "cloud.sun.fill"
    case "03d", "03n": return "cloud.fill"
    case "04d", "04n": return "smoke.fill"
    case "09d", "09n": return "cloud.drizzle.fill"
    case "10d", "10n": return "cloud.rain.fill"
    case "11d", "11n": return "cloud.bolt.fill"
    case "13d", "13n": return "snow"
    case "50d", "50n": return "cloud.fog.fill"
    default: return "questionmark.diamond.fill"
    }
}

func backgroundImage(for description: String, currentTime: Int, sunriseTime: Int, sunsetTime: Int) -> String {
    let description = description.lowercased()

    if description.contains("rain") {
        return "nbackrain"
    } else if description.contains("storm") || description.contains("thunder") {
        return "nbackstorm"
    } else if description.contains("snow") {
        return "nbacksnow"
    } else if description.contains("fog") || description.contains("mist") {
        return "nbackfog"
    } else if description.contains("clear") {
        if currentTime >= sunriseTime && currentTime < sunsetTime {
            return "nbacksun"
        } else {
            return "nbackmoon"
        }
    } else if description.contains("sun") {
        return "nbacksun"
    } else if description.contains("cloud") {
        return "nbackcloud"
    } else if description.contains("moon") || description.contains("night") {
        return "nbackmoon"
    } else {
        return "nbackcloud"
    }
}

func formatDay(_ timestamp: Int, _ timeZoneOffset: Int) -> String {
    let adjustedTime = timestamp + timeZoneOffset
    let date = Date(timeIntervalSince1970: TimeInterval(adjustedTime))

    let formatter = DateFormatter()
    formatter.dateFormat = "EEE"
    formatter.timeZone = TimeZone(secondsFromGMT: timeZoneOffset)

    return formatter.string(from: date)
}
