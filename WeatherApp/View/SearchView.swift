import SwiftUI

struct SearchView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @Environment(\.dismiss) private var dismiss // ✅ Proper dismissal method

    @State private var searchQuery = ""

    var body: some View {
        VStack {
            TextField("Search for a city", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Search") {
                searchViewModel.searchCity(cityName: searchQuery)
            }
            .padding()

            List(searchViewModel.savedCities, id: \.city.name) { weatherResponse in
                CityCardView(weatherResponse: weatherResponse)
                    .onTapGesture {
                        print("🏙 Tapped city: \(weatherResponse.city.name)") // ✅ Debugging
                        weatherViewModel.setWeatherForCity(weatherResponse: weatherResponse)
                        dismiss() // ✅ Close and go back
                    }
            }
        }
        .navigationTitle("Search & Saved Cities")
    }
}


#Preview {
    SearchView()
        .environmentObject(SearchViewModel())
        .environmentObject(WeatherViewModel())
}
