import SwiftUI

struct CityInfoView: View {
    let weatherResponse: WeatherResponse
    let dayName = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
        
            // City Name & Country
            Text("\(weatherResponse.city.name.uppercased()), \(weatherResponse.city.country.uppercased())")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)

            // Day Name
            Text(dayName.uppercased())
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)

            // Temperature with custom color for "°"
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("\(weatherResponse.list.first?.main.temp ?? 0, specifier: "%.0f")") // Temperature number
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(.white)
                
                Text("°") // Degree symbol with custom color
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(Color(red: 0.89, green: 0.14, blue: 0.42))
            }

            // Weather Description
            Text(weatherResponse.list.first?.weather.first?.description.capitalized ?? "N/A")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)

            // Feels Like Temperature with custom "°"
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("Feels Like \(weatherResponse.list.first?.main.feels_like ?? 0, specifier: "%.1f")") // Text and number
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Text("°") // Degree symbol with custom color
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.89, green: 0.14, blue: 0.42))
            }
        }
        .frame(maxWidth: .infinity)
                .padding(.top, UIScreen.main.bounds.height * 0.12)
    }
}
