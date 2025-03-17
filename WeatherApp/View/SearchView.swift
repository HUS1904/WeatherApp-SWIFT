import SwiftUI

struct SearchView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModel

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

            List(searchViewModel.savedCities, id: \.city.name) { weatherData in
                CityCardView(weatherData: weatherData)
                    .onTapGesture {
                        weatherViewModel.setWeatherForCity(weatherData: weatherData)
                    }
            }
        }
        .navigationTitle("Search & Saved Cities")
    }
}
#Preview {
    SearchView()
        .environmentObject(SearchViewModel())
        .environmentObject(WeatherViewModel()) // ✅ Wrap in Task to prevent crashes
}

