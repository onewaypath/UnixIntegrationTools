import XCTest

import unixToolsTests

var tests = [XCTestCaseEntry]()
tests += unixToolsTests.allTests()
XCTMain(tests)
