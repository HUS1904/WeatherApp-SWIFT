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
        var dummyWeather = WeatherResponse.dummy()
        dummyWeather.id = UUID()
        dummyWeather.isFavorite = false

        viewModel.savedCities = [dummyWeather]
        viewModel.toggleFavorite(for: dummyWeather)

        let updated = viewModel.savedCities.first(where: { $0.id == dummyWeather.id })

        XCTAssertNotNil(updated)
        XCTAssertTrue(updated?.isFavorite == true, "Favorite flag should toggle to true")
    }

    func testRemoveCityActuallyRemovesIt() throws {
        var dummyWeather = WeatherResponse.dummy()
        dummyWeather.id = UUID()

        viewModel.savedCities = [dummyWeather]
        viewModel.removeCity(dummyWeather)

        let exists = viewModel.savedCities.contains { $0.id == dummyWeather.id }
        XCTAssertFalse(exists, "City should be removed from savedCities")
    }

    func testSaveAndLoadCitiesPersistsFavorites() throws {
        var dummyWeather = WeatherResponse.dummy()
        dummyWeather.id = UUID()
        dummyWeather.isFavorite = true

        viewModel.savedCities = [dummyWeather]
        viewModel.saveCities()

        let newViewModel = SearchViewModel()
        let reloaded = newViewModel.savedCities.first(where: { $0.id == dummyWeather.id })

        XCTAssertNotNil(reloaded, "City should be loaded from file")
        XCTAssertTrue(reloaded?.isFavorite == true, "Favorite flag should persist as true")
    }
}
