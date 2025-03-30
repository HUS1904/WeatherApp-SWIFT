import SwiftUI

struct SearchView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var searchQuery = ""
    @FocusState private var isSearchFieldFocused: Bool
    @State private var showCancelButton = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchHeaderView {
                    dismiss()
                    searchViewModel.clearSearch()
                }

                SearchBarView(
                    searchQuery: $searchQuery,
                    isSearchFieldFocused: _isSearchFieldFocused,
                    showCancelButton: $showCancelButton,
                    onSearchChanged: { newValue in
                        if newValue.isEmpty {
                            searchViewModel.clearSearch()
                        } else {
                            searchViewModel.searchCity(cityName: newValue)
                        }
                    },
                    onClearSearch: {
                        searchViewModel.clearSearch()
                    }
                )
                .onChange(of: isSearchFieldFocused) { _, focused in
                    if focused {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation {
                                showCancelButton = true
                            }
                        }
                    } else {
                        withAnimation {
                            showCancelButton = false
                        }
                    }
                }

                Group {
                    if isSearchFieldFocused {
                        SearchResultsList(
                            searchResults: searchViewModel.searchResults,
                            onSelectCity: { city in
                                searchViewModel.addCityAndClearSearch(city)
                                isSearchFieldFocused = false
                                searchQuery = ""
                            }
                        )
                    } else {
                        SavedCitiesList(
                            savedCities: searchViewModel.savedCities,
                            onSelectCity: { weatherResponse in
                                weatherViewModel.setWeatherForCity(weatherResponse: weatherResponse)
                                dismiss()
                            },
                            onDeleteCity: { weatherResponse in
                                searchViewModel.removeCity(weatherResponse)
                            }
                        )
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
                .scrollContentBackground(.hidden)
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.3), value: isSearchFieldFocused)
            }
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.156, green: 0.156, blue: 0.156))
            .edgesIgnoringSafeArea(.all)
            .onDisappear {
                searchViewModel.clearSearch()
            }
        }
        .background(Color(red: 0.156, green: 0.156, blue: 0.156))
    }
}
