//
//  LocketTests.swift
//  LocketTests
//
//  Created by Justin Damhaut on 9/6/24.
//

import XCTest
@testable import Locket

final class LocketTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPersonFlagsToggleWithoutChangingIdentity() throws {
        let subject = person(priority: 0, personid: generatePersonID())
        let originalID = subject.personid

        subject.pinToggle()
        XCTAssertTrue(subject.isPinned())
        subject.hiddenToggle()
        XCTAssertTrue(subject.isHiddenProfile())
        subject.hiddenToggle()
        subject.pinToggle()

        XCTAssertFalse(subject.isPinned())
        XCTAssertFalse(subject.isHiddenProfile())
        XCTAssertEqual(subject.personid, originalID)
    }

    func testTomorrowBirthdayAcrossYearBoundary() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let referenceDate = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 12, day: 31)))
        let birthday = try XCTUnwrap(calendar.date(from: DateComponents(year: 2000, month: 1, day: 1)))
        let subject = person(personid: generatePersonID(), birthday: birthday)

        XCTAssertTrue(subject.isBirthdayTomorrow(referenceDate: referenceDate))
    }

    func testDateInputPreservesFourDigitYear() {
        let date = DMYtoDate(day: "17", month: "9", year: "2026")
        let components = Calendar.current.dateComponents([.day, .month, .year], from: date)

        XCTAssertEqual(components.day, 17)
        XCTAssertEqual(components.month, 9)
        XCTAssertEqual(components.year, 2026)
    }

}
