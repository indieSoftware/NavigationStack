import XCTest

#if !canImport(ObjectiveC)
	public func allTests() -> [XCTestCaseEntry] {
		[
			testCase(NavigationStackTests.allTests)
		]
	}
#endif
