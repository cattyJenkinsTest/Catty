/**
 *  Copyright (C) 2010-2019 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

import XCTest

class MyFirstProjectTests: XCTestCase, UITestProtocol {

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        XCUIApplication().launch()

        dismissWelcomeScreenIfShown()
        restoreDefaultProject()
    }

    func testCanDeleteMultipleObjectsViaEditMode() {
        let app = XCUIApplication()
        app.tables.staticTexts["Projects"].tap()
        app.tables.staticTexts["My first project"].tap()
        app.navigationBars["My first project"].buttons["Edit"].tap()
        app.buttons["Delete Objects"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Mole 1"].tap()
        tablesQuery.staticTexts["Mole 2"].tap()
        app.toolbars.buttons["Delete"].tap()
        XCTAssert(app.tables.staticTexts["Background"].exists)
        XCTAssert(app.tables.staticTexts["Mole 1"].exists == false)
        XCTAssert(app.tables.staticTexts["Mole 2"].exists == false)
        XCTAssert(app.tables.staticTexts["Mole 3"].exists)
        XCTAssert(app.tables.staticTexts["Mole 4"].exists)
    }

    func testCanRenameProjectViaEditMode() {
        let app = XCUIApplication()
        app.tables.staticTexts["Projects"].tap()
        app.tables.staticTexts["My first project"].tap()
        app.navigationBars["My first project"].buttons["Edit"].tap()
        app.buttons["Rename Project"].tap()

        XCTAssert(app.alerts["Rename Project"].exists)
        let alertQuery = app.alerts["Rename Project"]
        XCTAssert(alertQuery.buttons["Clear text"].exists)
        alertQuery.buttons["Clear text"].tap()
        alertQuery.textFields["Enter your project name here..."].typeText("My renamed project")
        XCTAssert(alertQuery.buttons["OK"].exists)
        alertQuery.buttons["OK"].tap()

        XCTAssert(app.navigationBars["My renamed project"].exists)

        // go back and forth to force reload table view!!
        app.navigationBars["My renamed project"].buttons["Projects"].tap()
        app.navigationBars["Projects"].buttons["Pocket Code"].tap()
        app.tables.staticTexts["Projects"].tap()

        // check again
        XCTAssert(app.tables.staticTexts["My renamed project"].exists)

    }

    func testCanAbortRenameProjectViaEditMode() {
        let app = XCUIApplication()
        app.tables.staticTexts["Projects"].tap()
        app.tables.staticTexts["My first project"].tap()
        app.navigationBars["My first project"].buttons["Edit"].tap()
        app.buttons["Rename Project"].tap()

        XCTAssert(app.alerts["Rename Project"].exists)
        let alertQuery = app.alerts["Rename Project"]
        XCTAssert(alertQuery.buttons["Clear text"].exists)
        alertQuery.buttons["Clear text"].tap()
        alertQuery.textFields["Enter your project name here..."].typeText("My renamed project")
        XCTAssert(alertQuery.buttons["Cancel"].exists)
        alertQuery.buttons["Cancel"].tap()

        XCTAssert(app.navigationBars["My first project"].exists)

        // go back and forth to force reload table view!!
        app.navigationBars["My first project"].buttons["Projects"].tap()
        app.navigationBars["Projects"].buttons["Pocket Code"].tap()
        app.tables.staticTexts["Projects"].tap()

        // check again
        XCTAssert(app.tables.staticTexts["My first project"].exists)
    }

    func testCanShowAndHideDetailsViaEditMode() {
        let app = XCUIApplication()
        app.tables.staticTexts["Projects"].tap()
        app.tables.staticTexts["My first project"].tap()
        app.navigationBars["My first project"].buttons["Edit"].tap()

        if app.buttons["Hide Details"].exists {
            app.buttons["Hide Details"].tap()
            app.navigationBars["My first project"].buttons["Edit"].tap()
        }

        app.buttons["Show Details"].tap()

        app.navigationBars["My first project"].buttons["Edit"].tap()
        XCTAssert(app.buttons["Hide Details"].exists)
        app.buttons["Hide Details"].tap()
        app.navigationBars["My first project"].buttons["Edit"].tap()

        XCTAssert(app.buttons["Show Details"].exists)
        app.buttons["Cancel"].tap()

        XCTAssert(app.navigationBars["My first project"].exists)
    }

    func testCanEditDescriptionViaEditMode() {
        let app = XCUIApplication()
        app.tables.staticTexts["Projects"].tap()
        app.tables.staticTexts["My first project"].tap()
        app.navigationBars["My first project"].buttons["Edit"].tap()

        XCTAssert(app.buttons["Description"].exists)
        app.buttons["Description"].tap()

        app.textViews["descriptionTextView"].typeText("This is test description")

        app.navigationBars.buttons["Done"].tap()
        XCTAssert(app.navigationBars["My first project"].exists)

        app.navigationBars["My first project"].buttons["Edit"].tap()

        XCTAssert(app.buttons["Description"].exists)
        app.buttons["Description"].tap()

        XCTAssertEqual(app.textViews["descriptionTextView"].value as! String, "This is test description")
    }

    func testCanAbortEditDescriptionViaEditMode() {
        let app = XCUIApplication()
        app.tables.staticTexts["Projects"].tap()
        app.tables.staticTexts["My first project"].tap()
        app.navigationBars["My first project"].buttons["Edit"].tap()

        XCTAssert(app.buttons["Description"].exists)
        app.buttons["Description"].tap()

        app.navigationBars.buttons["Cancel"].tap()
        XCTAssert(app.navigationBars["My first project"].exists)
    }

    func testCanAbortDeleteSingleObjectViaSwipe() {
        let app = XCUIApplication()
        app.tables.staticTexts["Projects"].tap()
        app.tables.staticTexts["My first project"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Mole 3"].swipeLeft()
        XCTAssert(app.buttons["Delete"].exists)

        app.buttons["Delete"].tap()
        let yesButton = app.alerts["Delete this object"].buttons["Cancel"]
        yesButton.tap()
        XCTAssert(app.tables.staticTexts["Mole 3"].exists)
    }

    func testCanDeleteSingleObjectViaSwipe() {
        let app = XCUIApplication()
        app.tables.staticTexts["Projects"].tap()
        app.tables.staticTexts["My first project"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Mole 1"].swipeLeft()
        XCTAssert(app.buttons["Delete"].exists)

        app.buttons["Delete"].tap()
        let yesButton = app.alerts["Delete this object"].buttons["Yes"]
        yesButton.tap()
        XCTAssert(app.tables.staticTexts["Mole 1"].exists == false)
    }

    func testCanRenameSingleObjectViaSwipe() {
        let app = XCUIApplication()
        app.tables.staticTexts["Projects"].tap()
        app.tables.staticTexts["My first project"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Mole 3"].swipeLeft()
        XCTAssert(app.buttons["More"].exists)

        app.buttons["More"].tap()
        app.buttons["Rename"].tap()

        let alert = waitForElementToAppear(app.alerts["Rename object"])
        alert.buttons["Clear text"].tap()
        alert.textFields["Enter your object name here..."].typeText("Mole 5")
        alert.buttons["OK"].tap()

        XCTAssert(app.tables.staticTexts["Mole 5"].exists)
    }

    func testCanAbortRenameSingleObjectViaSwipe() {
        let app = XCUIApplication()
        app.tables.staticTexts["Projects"].tap()
        app.tables.staticTexts["My first project"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Mole 1"].swipeLeft()
        XCTAssert(app.buttons["More"].exists)

        app.buttons["More"].tap()
        app.buttons["Rename"].tap()

        let alert = waitForElementToAppear(app.alerts["Rename object"])
        alert.buttons["Clear text"].tap()
        alert.textFields["Enter your object name here..."].typeText("Mole 5")
        alert.buttons["Cancel"].tap()

        XCTAssert(app.tables.staticTexts["Mole 1"].exists)
    }

    func testCanCopySingleObjectViaSwipe() {
        let app = XCUIApplication()
        app.tables.staticTexts["Projects"].tap()
        app.tables.staticTexts["My first project"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Mole 1"].swipeLeft()
        XCTAssert(app.buttons["More"].exists)

        app.buttons["More"].tap()
        app.buttons["Copy"].tap()
        app.swipeDown()
        XCTAssert(app.tables.staticTexts["Mole 1 (1)"].exists)
    }

    func testCanAbortSwipe() {
        let app = XCUIApplication()
        app.tables.staticTexts["Projects"].tap()
        app.tables.staticTexts["My first project"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Mole 1"].swipeLeft()
        XCTAssert(app.buttons["More"].exists)

        app.buttons["More"].tap()
        app.buttons["Cancel"].tap()
    }
}
