import SwiftUI

struct CityInfoView: View {
    let weatherResponse: WeatherResponse
    let dayName = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]

    var imageWidth: CGFloat = 300
    var imageHeight: CGFloat = 200
    var imageOffsetX: CGFloat = 0
    var imageOffsetY: CGFloat = 50

    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.white.opacity(0.3), location: 0.0),
                    .init(color: Color.white.opacity(0.05), location: 0.5),
                    .init(color: Color.clear, location: 1.0)
                ]),
                center: .center,
                startRadius: 0,
                endRadius: max(imageWidth, imageHeight) * 0.3
            )
            .frame(width: imageWidth, height: imageHeight)
            .scaleEffect(1.5)
            .offset(x: imageOffsetX, y: imageOffsetY)
            .allowsHitTesting(false)

            Image(backgroundImage(
                for: weatherResponse.current.weather.description,
                currentTime: weatherResponse.current.dt,
                sunriseTime: weatherResponse.current.sunrise ?? 0,
                sunsetTime: weatherResponse.current.sunset ?? 0
            ))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imageWidth, height: imageHeight)
            .offset(x: imageOffsetX, y: imageOffsetY)
            .opacity(0.3)
            .allowsHitTesting(false)

            VStack(alignment: .center, spacing: 8) {
                Text("\(weatherResponse.cityName.uppercased()), \(weatherResponse.country.uppercased())")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)

                Text(dayName.uppercased())
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)

                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("\(weatherResponse.current.temp, specifier: "%.0f")")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.white)

                    Text("°")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(Color(red: 0.89, green: 0.14, blue: 0.42))
                }

                Text(weatherResponse.daily?.first?.summary ?? "No summary available")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)

                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("Feels Like \(weatherResponse.current.feelsLike, specifier: "%.0f")")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))

                    Text("°")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.89, green: 0.14, blue: 0.42))
                }
                .padding(.top, 5)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, UIScreen.main.bounds.height * 0.12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
