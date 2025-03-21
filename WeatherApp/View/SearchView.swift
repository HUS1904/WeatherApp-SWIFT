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
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                        searchViewModel.clearSearch()
                    }) {
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

                    // Dummy space to balance the back button width
                    Image(systemName: "chevron.backward.square")
                        .resizable()
                        .opacity(0)
                        .frame(width: 27, height: 27)
                }
                .padding(.top, 70)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)

                // Search Section
                HStack(spacing: 10) {
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
                                .focused($isSearchFieldFocused)
                                .onChange(of: searchQuery) { newValue in
                                    if newValue.isEmpty {
                                        searchViewModel.clearSearch()
                                    } else {
                                        searchViewModel.searchCity(cityName: newValue)
                                    }
                                }
                        }
                    }
                    .frame(height: 50)
                    .background(Color(red: 56/255, green: 56/255, blue: 56/255))
                    .cornerRadius(15)
                    .animation(.easeInOut(duration: 0.25), value: isSearchFieldFocused)

                    if showCancelButton {
                        Button(action: {
                            isSearchFieldFocused = false
                            searchViewModel.clearSearch()
                            searchQuery = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.white, Color(red: 0.89, green: 0.14, blue: 0.42))
                        }
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.25), value: showCancelButton)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                .onChange(of: isSearchFieldFocused) { focused in
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

                // Results or saved cities
                Group {
                    if isSearchFieldFocused {
                        List(searchViewModel.searchResults, id: \.id) { city in
                            HStack {
                                Text("\(city.name), \(city.country)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .medium))
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                searchViewModel.addCityAndClearSearch(city)
                                isSearchFieldFocused = false
                                searchQuery = "" // ✅ Clear search field
                            }
                            .listRowBackground(Color.clear)
                        }
                    } else {
                        List {
                            ForEach(searchViewModel.savedCities, id: \.city.name) { weatherResponse in
                                CityCardView(
                                    weatherResponse: weatherResponse,
                                    onDelete: {
                                        searchViewModel.removeCity(weatherResponse)
                                    },
                                    onSelect: {
                                        weatherViewModel.setWeatherForCity(weatherResponse: weatherResponse)
                                        dismiss()
                                    }
                                )
                                .listRowBackground(Color.clear)
                            }
                        }
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
