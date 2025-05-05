import XCTest
@testable import WeatherApp

@MainActor
final class WeatherPersistenceTests: XCTestCase {
    var viewModel: SearchViewModel!

    override func setUp() async throws {
        viewModel = SearchViewModel()
        viewModel.savedCities = []
        try? FileManager.default.removeItem(at: viewModel.getCitiesFileURL())
    }

    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: viewModel.getCitiesFileURL())
        viewModel = nil
    }

    func testWeatherResponseCodableRoundTrip() throws {
        let original = WeatherResponse.dummy(cityName: "RoundTripCity", isFavorite: true)

        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(WeatherResponse.self, from: encoded)

        XCTAssertEqual(original.cityName, decoded.cityName)
        XCTAssertEqual(original.isFavorite, decoded.isFavorite)
    }

    func testSaveCitiesWritesFile() throws {
        let dummy = WeatherResponse.dummy(cityName: "FileCity", isFavorite: true)
        viewModel.savedCities = [dummy]
        viewModel.saveCities()

        let url = viewModel.getCitiesFileURL()
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }

    func testLoadCitiesReadsCorrectFile() throws {
        let dummy = WeatherResponse.dummy(cityName: "LoadCity", isFavorite: true)
        viewModel.savedCities = [dummy]
        viewModel.saveCities()

        viewModel.savedCities = []
        viewModel.loadCities()

        XCTAssertEqual(viewModel.savedCities.count, 1)
        XCTAssertEqual(viewModel.savedCities.first?.cityName, "LoadCity")
    }
}
