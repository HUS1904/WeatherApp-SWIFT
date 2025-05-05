import SwiftUI

struct CityCardView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    let weatherResponse: WeatherResponse
    var onDelete: (() -> Void)? = nil
    var onSelect: (() -> Void)? = nil

    var body: some View {
        Button(action: {
            onSelect?()
        }) {
            HStack(alignment: .top) {
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

                VStack(alignment: .trailing, spacing: 6) {
                    HStack(spacing: 16) {
                        Button(action: {
                            onDelete?()
                        }) {
                            Image(systemName: "trash.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.pink)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Button(action: {
                            searchViewModel.toggleFavorite(for: weatherResponse)
                        }) {
                            Image(systemName: weatherResponse.isFavorite ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(weatherResponse.isFavorite ? .yellow : .gray)
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
