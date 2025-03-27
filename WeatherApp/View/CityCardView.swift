import SwiftUI

struct CityCardView: View {
    let weatherResponse: WeatherResponse
    var onDelete: (() -> Void)? = nil
    var onSelect: (() -> Void)? = nil

    var body: some View {
        Button(action: {
            print("📍 Tapped city: \(weatherResponse.cityName)")
            onSelect?()
        }) {
            HStack(alignment: .top) {
                // Left side: City info
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(weatherResponse.cityName), \(weatherResponse.country)")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("Time: \(formatUnixTime(Int(Date().timeIntervalSince1970), weatherResponse.timezoneOffset))")
                        .font(.caption)
                        .foregroundColor(.white)

                    Text("\(weatherResponse.current.temp, specifier: "%.0f")°  \(weatherResponse.current.weather.first?.description.capitalized ?? "N/A")")
                        .font(.caption)
                        .foregroundColor(.white)
                }

                Spacer()

                // Right side: Buttons + humidity & rain
                VStack(alignment: .trailing, spacing: 6) {
                    HStack(spacing: 16) {
                        Button(action: {
                            print("🗑 Trash tapped for \(weatherResponse.cityName)")
                            onDelete?()
                        }) {
                            Image(systemName: "trash.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(red: 0.89, green: 0.14, blue: 0.42))
                        }
                        .buttonStyle(PlainButtonStyle())

                        Button(action: {
                            print("⭐️ Star tapped for \(weatherResponse.cityName)")
                        }) {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.yellow)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    Text("Humidity: \(weatherResponse.current.humidity)%")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(.top, 6)

                    if let rain = weatherResponse.hourly?.first?.pop {
                        Text("Rain: \(rain * 100, specifier: "%.1f")%")
                            .font(.caption2)
                            .foregroundColor(.white)
                    } else {
                        Text("Rain: 0.0 mm")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
            .background(Color(red: 56/255, green: 56/255, blue: 56/255))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
