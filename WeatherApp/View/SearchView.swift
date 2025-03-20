import SwiftUI

struct SearchView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var searchQuery = ""
    @State private var searchTimer: Timer?

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                // Back button & Saved Cities
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.backward.square")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 27, height: 27)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, Color(red: 0.89, green: 0.14, blue: 0.42))
                    }

                    Spacer()

                    Text("Saved Cities")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding(.top, 70)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)

                // Search field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.leading, 12)

                    ZStack(alignment: .leading) {
                        if searchQuery.isEmpty {
                            Text("Search for a city")
                                .foregroundColor(.white.opacity(0.6))
                        }

                        TextField("", text: $searchQuery)
                            .foregroundColor(.white)
                            .padding(10)
                            .tint(Color(red: 0.89, green: 0.14, blue: 0.42))
                            .onChange(of: searchQuery) { newValue in
                                searchViewModel.searchCity(cityName: newValue)
                            }
                    }
                }
                .frame(height: 50)
                .background(Color(red: 56/255, green: 56/255, blue: 56/255))
                .cornerRadius(15)
                .padding(.horizontal)

                // Live results
                if !searchViewModel.searchResults.isEmpty {
                    VStack {
                        ForEach(searchViewModel.searchResults, id: \.id) { city in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(city.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .medium))
                                    Text(city.country)
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.system(size: 14))
                                }
                                Spacer()

                                Button("Add") {
                                    searchViewModel.addCity(city)
                                }
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(Color(red: 0.89, green: 0.14, blue: 0.42))
                                .cornerRadius(8)
                            }
                            .padding(.vertical, 8)
                            .background(Color(red: 56/255, green: 56/255, blue: 56/255))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 16)
                }

                // Saved cities list
                List(searchViewModel.savedCities, id: \.city.name) { weatherResponse in
                    CityCardView(weatherResponse: weatherResponse)
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            weatherViewModel.setWeatherForCity(weatherResponse: weatherResponse)
                            dismiss()
                        }
                }
                .background(Color.clear)
                .scrollContentBackground(.hidden)
            }
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.156, green: 0.156, blue: 0.156))
            .edgesIgnoringSafeArea(.all)
        }
        .background(Color(red: 0.156, green: 0.156, blue: 0.156))
        .edgesIgnoringSafeArea(.all)
    }
}
