import SwiftUI

struct SearchResultsList: View {
    let searchResults: [CitySearchResult]
    let onSelectCity: (CitySearchResult) -> Void

    var body: some View {
        List(searchResults, id: \.id) { city in
            HStack {
                Text("\(city.name), \(city.country)")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium))
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onSelectCity(city)
            }
            .listRowBackground(Color.clear)
        }
    }
}
