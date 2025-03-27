import SwiftUI

struct CityInfoView: View {
    let weatherResponse: WeatherResponse
    let dayName = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
        
            // City Name & Country
            Text("\(weatherResponse.cityName.uppercased()), \(weatherResponse.country.uppercased())")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)

            // Day Name
            Text(dayName.uppercased())
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)

            // Temperature with custom color for "°"
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("\(weatherResponse.current.temp, specifier: "%.0f")") // Temperature number
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(.white)
                
                Text("°") // Degree symbol with custom color
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(Color(red: 0.89, green: 0.14, blue: 0.42))
            }

            // Weather Summary
            Text(weatherResponse.daily?.first?.summary ?? "No summary available")
                .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)         // Centers each line
                    .lineLimit(nil)                          // Unlimited lines (can be omitted; default is nil)
                    .fixedSize(horizontal: false, vertical: true) // Allows wrapping
                    .frame(maxWidth: .infinity)              // Ensures it takes full width of parent
                    .padding(.horizontal, 16)

            // Feels Like Temperature with custom "°"
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("Feels Like \(weatherResponse.current.feelsLike, specifier: "%.0f")") // Text and number
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Text("°") // Degree symbol with custom color
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.89, green: 0.14, blue: 0.42))
            }
            .padding(.top,5)
        }
        .frame(maxWidth: .infinity)
                .padding(.top, UIScreen.main.bounds.height * 0.12)
    }
}
