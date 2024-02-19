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

    func testOnAppear() throws {
        let imageName = try view.inspect().geometryReader().vStack().group(0).image(0).actualImage().name()
        let minTemperature = try view.inspect().geometryReader().vStack().hStack(0).text(0).string()
        let maxTemperature = try view.inspect().geometryReader().vStack().hStack(0).text(1).string()
        XCTAssertEqual(imageName, "Sunny")
        XCTAssertEqual(minTemperature, "-10")
        XCTAssertEqual(maxTemperature, "10")
    }

    func testReload() throws {
        try view.inspect().geometryReader().hStack().button(1).tap()
        let imageName = try view.inspect().geometryReader().vStack().group(0).image(0).actualImage().name()
        let minTemperature = try view.inspect().geometryReader().vStack().hStack(0).text(0).string()
        let maxTemperature = try view.inspect().geometryReader().vStack().hStack(0).text(1).string()
        XCTAssertEqual(imageName, "Cloudy")
        XCTAssertEqual(minTemperature, "-10")
        XCTAssertEqual(maxTemperature, "10")
    }
}
