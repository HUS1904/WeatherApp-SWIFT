import SwiftUI

struct SavedCitiesList: View {
    let savedCities: [WeatherResponse]
    let onSelectCity: (WeatherResponse) -> Void
    let onDeleteCity: (WeatherResponse) -> Void

    var body: some View {
        List {
            ForEach(savedCities, id: \.cityName) { weatherResponse in
                CityCardView(
                    weatherResponse: weatherResponse,
                    onDelete: {
                        onDeleteCity(weatherResponse)
                    },
                    onSelect: {
                        onSelectCity(weatherResponse)
                    }
                )
                .listRowBackground(Color.clear)
            }
        }
    }
}
