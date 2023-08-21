import XCTest

#if !canImport(ObjectiveC)
  public func allTests() -> [XCTestCaseEntry] {
    [
      testCase(BookshelfTests.allTests),
    ]
  }
#endif
