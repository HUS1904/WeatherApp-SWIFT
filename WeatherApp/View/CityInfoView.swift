import SwiftUI

struct CityInfoView: View {
    let cityName: String
    let country: String
    let description: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(cityName)
                .font(.headline)
            Text(country)
                .font(.caption)
            Text(description)
                .font(.caption)
        }
    }
}
#Preview {
    CityInfoView(
        cityName: "New York",
        country: "USA",
        description: "The most populous city in the United States."
    )
}
