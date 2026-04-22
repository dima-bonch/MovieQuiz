import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil

        try super.tearDownWithError()
    }

    // MARK: - Постер меняется после "Да"

    func testYesButtonChangesQuestion() throws {
        let questionLabel = app.staticTexts["QuestionNumberLabel"]

        XCTAssertTrue(
            questionLabel.waitForExistence(timeout: 10)
        )

        let firstQuestion = questionLabel.label

        app.buttons["Yes"].tap()

        sleep(2)

        let secondQuestion = questionLabel.label

        XCTAssertNotEqual(
            firstQuestion,
            secondQuestion
        )
    }

    // MARK: - Постер меняется после "Нет"

    func testNoButtonChangesQuestion() throws {
        let questionLabel = app.staticTexts["QuestionNumberLabel"]

        XCTAssertTrue(
            questionLabel.waitForExistence(timeout: 10)
        )

        let firstQuestion = questionLabel.label

        app.buttons["No"].tap()

        sleep(2)

        let secondQuestion = questionLabel.label

        XCTAssertNotEqual(
            firstQuestion,
            secondQuestion
        )
    }

    // MARK: - Алерт появляется после 10 ответов

    func testAlertAppearsAfterTenAnswers() throws {

        let questionLabel = app.staticTexts["QuestionNumberLabel"]

        XCTAssertTrue(
            questionLabel.waitForExistence(timeout: 10)
        )

        // Первые 9 вопросов
        for _ in 0..<9 {
            app.buttons["Yes"].tap()
            sleep(2)
        }

        // 10-й отдельно
        app.buttons["Yes"].tap()

        let alert = app.alerts["Этот раунд окончен!"]

        XCTAssertTrue(
            alert.waitForExistence(timeout: 20)
        )

        XCTAssertTrue(
            alert.buttons["Сыграть ещё раз"]
                .waitForExistence(timeout: 5)
        )
    }

    // MARK: - Алерт скрывается и игра начинается заново

    func testAlertDismissesAndGameRestarts() throws {

        let questionLabel = app.staticTexts["QuestionNumberLabel"]

        XCTAssertTrue(
            questionLabel.waitForExistence(timeout: 10)
        )

        for _ in 0..<9 {
            app.buttons["Yes"].tap()
            sleep(2)
        }

        app.buttons["Yes"].tap()

        let alert = app.alerts["Этот раунд окончен!"]

        XCTAssertTrue(
            alert.waitForExistence(timeout: 20)
        )

        let playAgainButton = alert.buttons["Сыграть ещё раз"]

        XCTAssertTrue(
            playAgainButton.waitForExistence(timeout: 5)
        )

        playAgainButton.tap()

        XCTAssertFalse(
            alert.exists
        )

        let predicate = NSPredicate(
            format: "label == %@",
            "1/10"
        )

        expectation(
            for: predicate,
            evaluatedWith: questionLabel
        )

        waitForExpectations(
            timeout: 10
        )
    }
}
