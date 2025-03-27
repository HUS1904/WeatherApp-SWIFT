import SwiftUI

struct FeelsLikeWidget: View {
    let weatherResponse: WeatherResponse

    var feelsLikeTemp: Int {
        Int(weatherResponse.current.feelsLike)
    }

    var body: some View {
        WeatherWidgetBox(iconName: "thermometer.sun.fill", title: "FEELS LIKE") {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .top, spacing: 1) {
                    Text("\(feelsLikeTemp)")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)

                    Text("°")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color(red: 0.89, green: 0.14, blue: 0.42))
                }

                Text("Wind makes it feel cooler")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil) // Allow unlimited lines
                    .fixedSize(horizontal: false, vertical: true) // Expand vertically if needed
                    .padding(.top, 5)
            }
        }
    }
}
