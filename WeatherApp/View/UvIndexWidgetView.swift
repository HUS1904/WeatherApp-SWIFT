import SwiftUI

struct UvIndexWidgetView: View {
    let weatherResponse: WeatherResponse

    var uvIndex: Double {
        weatherResponse.current.uvi
    }

    var uvLevel: String {
        switch uvIndex {
        case ..<0:
            return "Unknown"
        case 0...2:
            return "Low"
        case 3...5:
            return "Moderate"
        case 6...7:
            return "High"
        case 8...10:
            return "Very High"
        default:
            return "Extreme"
        }
    }

    var uvColor: Color {
        switch uvLevel {
        case "Low": return Color.green
        case "Moderate": return Color.yellow
        case "High": return Color.orange
        case "Very High": return Color.red
        case "Extreme": return Color.purple
        default: return .gray
        }
    }

    var body: some View {
        WeatherWidgetBox(iconName: "sun.max.fill", title: "UV INDEX") {
            VStack(alignment: .leading, spacing: 6) {
                Text(uvIndex >= 0 ? String(format: "%.1f", uvIndex) : "--")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)

                Text(uvLevel)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(uvColor)

                // 👇 Adjust this value to control the max bar length
                let maxBarWidth: CGFloat = 140

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: maxBarWidth, height: 10)

                    Capsule()
                        .fill(uvColor)
                        .frame(width: CGFloat((uvIndex > 0 ? min(uvIndex, 11.0) / 11.0 : 0.0)) * maxBarWidth, height: 10)
                        .animation(.easeInOut, value: uvIndex)
                }
                .padding(.top, 4)
            }
        }
    }
}
