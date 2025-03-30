import SwiftUI

struct AirHumidityWidgetView: View {
    let weatherResponse: WeatherResponse

    var airHumidity: Int {
        Int(weatherResponse.current.humidity)
    }

    var temperature: Double {
        weatherResponse.current.temp
    }

    var dewPoint: Double {
        weatherResponse.current.dewPoint
    }

    var body: some View {
        WeatherWidgetBox(iconName: "humidity", title: "AIR HUMIDITY") {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .top, spacing: 0) {
                    Text("\(airHumidity)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)

                    Text("%")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color(red: 0.89, green: 0.14, blue: 0.42))
                }

                Text(String(format: "The dew point is %.1f° right now", dewPoint))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 5)
            }
        }
    }
}
