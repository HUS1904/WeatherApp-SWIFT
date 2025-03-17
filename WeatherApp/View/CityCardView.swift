import SwiftUI

struct CityCardView: View {
    let weatherData: WeatherResponse

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(weatherData.city.name)
                    .font(.headline)
                Text(weatherData.city.country)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(weatherData.list.first?.main.temp ?? 0, specifier: "%.1f")°C")
                .bold()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
