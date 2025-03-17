import Foundation
import SwiftUI

// ✅ Convert UNIX timestamp to readable time format (adjusted for timezone)
func formatUnixTime(_ timestamp: Int, _ timeZoneOffset: Int) -> String {
    let adjustedTime = timestamp + timeZoneOffset
    let date = Date(timeIntervalSince1970: TimeInterval(adjustedTime))

    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    formatter.timeZone = TimeZone(secondsFromGMT: timeZoneOffset)

    return formatter.string(from: date)
}

// ✅ Map OpenWeather icons to SF Symbols
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

// ✅ Convert UNIX timestamp to a **weekday name** (Mon, Tue, etc.)
func formatDay(_ timestamp: Int, _ timeZoneOffset: Int) -> String {
    let adjustedTime = timestamp + timeZoneOffset
    let date = Date(timeIntervalSince1970: TimeInterval(adjustedTime))

    let formatter = DateFormatter()
    formatter.dateFormat = "EEE" // ✅ Abbreviated day name (Mon, Tue, etc.)
    formatter.timeZone = TimeZone(secondsFromGMT: timeZoneOffset)

    return formatter.string(from: date)
}
