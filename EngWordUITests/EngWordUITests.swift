//
//  EngWordUITests.swift
//  EngWordUITests
//
//  Created by hieu nguyen on 17/02/2023.
//

import XCTest

@testable import EngWord
final class EngWordUITests: XCTestCase {


    let app = XCUIApplication()

    override func setUp() {
        app.launch()
    }

    func testExample() throws {
//        let app = XCUIApplication()
//        let tablesQuery = app.tables
//        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Thư Mục"]/*[[".cells.staticTexts[\"Thư Mục\"]",".staticTexts[\"Thư Mục\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts["ngày 21 thg 2, 2023"].tap()
//        let textField = tablesQuery.cells.children(matching: .textField).element
//        textField.tap()

        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Thư Mục"]/*[[".cells.staticTexts[\"Thư Mục\"]",".staticTexts[\"Thư Mục\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts["ngày 21 thg 2, 2023"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["+ New Term"]/*[[".otherElements[\"+ New Term\"].staticTexts[\"+ New Term\"]",".staticTexts[\"+ New Term\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let textField = tablesQuery.cells.children(matching: .textField).element
        textField.tap()

        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
//
        app.keys["d"].tap()
        app.keys["e"].tap()
        app.keys["f"].tap()
        app.keys["i"].tap()
        app.keys["n"].tap()
        app.keys["i"].tap()
        app.keys["t"].tap()
        app.keys["i"].tap()
        app.keys["o"].tap()
        app.keys["n"].tap()

        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: 7)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
