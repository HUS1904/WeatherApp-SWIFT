import XCTest
@testable import WeatherApp

@MainActor
final class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!

    override func setUp() async throws {
        viewModel = WeatherViewModel()
    }

    override func tearDown() async throws {
        viewModel = nil
    }

    func testSetWeatherForCityUpdatesState() {
        let dummyWeather = WeatherResponse.dummy()
        viewModel.setWeatherForCity(weatherResponse: dummyWeather)

        XCTAssertNotNil(viewModel.weatherResponse)
        XCTAssertEqual(viewModel.weatherResponse?.cityName, dummyWeather.cityName)
    }

    func testFetchWeatherForCoordinatesReturnsValidData() async throws {
        let weatherService = WeatherService()
        let viewModel = WeatherViewModel(weatherService: weatherService)

        await viewModel.setWeatherForCoordinates(lat: 55.6761, lon: 12.5683)

        guard let weather = viewModel.weatherResponse else {
            XCTFail("No weather data returned")
            return
        }

        XCTAssertFalse(weather.cityName.isEmpty, "City name should not be empty")
        XCTAssert(weather.current.temp > -100 && weather.current.temp < 100, "Temperature should be within realistic bounds")
    }
}
