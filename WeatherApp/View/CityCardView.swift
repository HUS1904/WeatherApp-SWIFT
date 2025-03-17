import SwiftUI

struct CityCardView: View {
    let weatherResponse: WeatherResponse // ✅ Consistent

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(weatherResponse.city.name)
                    .font(.headline)
                Text(weatherResponse.city.country)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(weatherResponse.list.first?.main.temp ?? 0, specifier: "%.1f")°C")
                .bold()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

