import XCTest
import Stencil
@testable import Bookshelf

final class FileHandlerMock: FileHandlerProtocol {
  
  func getPageTemplate() throws -> String {
    return "{{content}}"
  }
  
  func getSectionTemplate() throws -> String {
    return "Header: {{header}}\n Books: {{books}}"
  }
  
  func getBookTemplate() throws -> String {
    return "Title: {{title}} Subtitle: {{subtitle}} Goodreads: {{goodreadsURL}} Authors: {{authors}} Cover: {{cover}}"
  }
  
}

final class BookshelfTests: XCTestCase {
  
  func testHTMLGeneration() {
    let generator = HTMLGenerator(fileHandler: FileHandlerMock())
    let generated = try? generator.generate(
      sections: [
        ShelfSection(
          header: "Reading",
          books: [
            Book(
              goodreadsURL: "www.goodreads.com",
              title: "Steve Jobs",
              imageURL: "",
              authors: ["Walter Issacson"])])])
    
    XCTAssertNotNil(generated)
  }
  
  static var allTests = [
    ("testHTMLGeneration", testHTMLGeneration),
  ]
}
