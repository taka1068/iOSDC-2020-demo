import XCTest

import ConcurrencyWithGCDTests

var tests = [XCTestCaseEntry]()
tests += ConcurrencyWithGCDTests.allTests()
XCTMain(tests)
