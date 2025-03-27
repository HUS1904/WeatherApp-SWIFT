import SwiftUI

struct RainWidget: View {
    let weatherResponse: WeatherResponse

    var rainLast24Hours: Double {
        weatherResponse.daily?[0].rain ?? 0.0
    }

    var rainNext24Hours: Double {
        weatherResponse.daily?[1].rain ?? 0.0
    }

    var body: some View {
        WeatherWidgetBox(iconName: "drop.fill", title: "RAIN") {
            VStack(alignment: .leading, spacing: 5) {
                Text(String(format: "%.1f mm", rainLast24Hours))
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)

                Text("In the last 24 hours")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)

                
                Text(String(format: "%.1f mm of rain is expected\nin the next 24 hours", rainNext24Hours))
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil) // Allow unlimited lines
                    .fixedSize(horizontal: false, vertical: true) // Expand vertically if needed
                    .padding(.top, 5)
            }
        }
    }
}
