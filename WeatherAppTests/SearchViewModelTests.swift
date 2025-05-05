import XCTest
@testable import WeatherApp

@MainActor
final class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModel!

    override func setUp() async throws {
        viewModel = SearchViewModel()
        viewModel.savedCities = []
        try? FileManager.default.removeItem(at: viewModel.getCitiesFileURL())
    }

    override func tearDown() async throws {
        viewModel = nil
    }

    func testAddCityPreventsDuplicates() async throws {
        let dummy = CitySearchResult(name: "TestCity", lat: 12.34, lon: 56.78, country: "TC", state: nil)

        try await viewModel.addCity(dummy)
        try await Task.sleep(nanoseconds: 200_000_000)
        let countAfterFirstAdd = viewModel.savedCities.count

        try await viewModel.addCity(dummy)
        try await Task.sleep(nanoseconds: 200_000_000)
        let countAfterSecondAdd = viewModel.savedCities.count

        XCTAssertEqual(countAfterFirstAdd, 1)
        XCTAssertEqual(countAfterSecondAdd, 1, "City should not be added twice")
    }

    func testToggleFavoriteUpdatesFlag() throws {
        // 1. Create dummy weather response
        var dummyWeather = WeatherResponse.dummy()
        dummyWeather.id = UUID()
        dummyWeather.isFavorite = false

        // 2. Add to savedCities
        viewModel.savedCities = [dummyWeather]

        // 3. Toggle favorite
        viewModel.toggleFavorite(for: dummyWeather)

        // 4. Verify toggle
        let updated = viewModel.savedCities.first(where: { $0.id == dummyWeather.id })

        XCTAssertNotNil(updated)
        XCTAssertTrue(updated?.isFavorite == true, "Favorite flag should toggle to true")
    }

    func testRemoveCityActuallyRemovesIt() throws {
        // 1. Create dummy city
        var dummyWeather = WeatherResponse.dummy()
        dummyWeather.id = UUID()

        // 2. Add to savedCities
        viewModel.savedCities = [dummyWeather]

        // 3. Remove the city
        viewModel.removeCity(dummyWeather)

        // 4. Assert it's gone
        let exists = viewModel.savedCities.contains { $0.id == dummyWeather.id }

        XCTAssertFalse(exists, "City should be removed from savedCities")
    }
    
    func testSaveAndLoadCitiesPersistsFavorites() throws {
        // 1. Create dummy city
        var dummyWeather = WeatherResponse.dummy()
        dummyWeather.id = UUID()
        dummyWeather.isFavorite = true

        // 2. Add and save
        viewModel.savedCities = [dummyWeather]
        viewModel.saveCities()

        // 3. Create new instance and load
        let newViewModel = SearchViewModel()

        let reloaded = newViewModel.savedCities.first(where: { $0.id == dummyWeather.id })

        // 4. Assert
        XCTAssertNotNil(reloaded, "❌ City should be loaded from file")
        XCTAssertTrue(reloaded?.isFavorite == true, "❌ Favorite flag should persist as true")
    }
}
