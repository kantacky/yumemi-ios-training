//
//  ForecastViewUITests.swift
//  YumemiTrainingUITests
//
//  Created by 及川 寛太 on 2024/02/19.
//

import XCTest
import ViewInspector
@testable import YumemiTraining

@MainActor
final class ForecastViewUITests: XCTestCase {

    let view: ForecastView = .init(viewModel: ForecastViewModelMock())

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testOnAppearSunny() throws {
        let imageName = try view.inspect().vStack().vStack(0).group(0).image(0).actualImage().name()
        let minTemperature = try view.inspect().vStack().vStack(0).hStack(0).text(0).string()
        let maxTemperature = try view.inspect().vStack().vStack(0).hStack(0).text(1).string()
        XCTAssertEqual(imageName, "Sunny")
        XCTAssertEqual(minTemperature, "-10")
        XCTAssertEqual(maxTemperature, "10")
    }

    func testReloadCloudy() throws {
        try view.inspect().vStack().hStack(0).button(1).tap()
        let imageName = try view.inspect().vStack().vStack(0).group(0).image(0).actualImage().name()
        let minTemperature = try view.inspect().vStack().vStack(0).hStack(0).text(0).string()
        let maxTemperature = try view.inspect().vStack().vStack(0).hStack(0).text(1).string()
        XCTAssertEqual(imageName, "Cloudy")
        XCTAssertEqual(minTemperature, "-10")
        XCTAssertEqual(maxTemperature, "10")
    }

    func testReloadRainy() throws {
        try view.inspect().vStack().hStack(0).button(1).tap()
        let imageName = try view.inspect().vStack().vStack(0).group(0).image(0).actualImage().name()
        let minTemperature = try view.inspect().vStack().vStack(0).hStack(0).text(0).string()
        let maxTemperature = try view.inspect().vStack().vStack(0).hStack(0).text(1).string()
        XCTAssertEqual(imageName, "Rainy")
        XCTAssertEqual(minTemperature, "-10")
        XCTAssertEqual(maxTemperature, "10")
    }
}
