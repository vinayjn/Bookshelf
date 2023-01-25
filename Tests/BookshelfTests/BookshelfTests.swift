@testable import Bookshelf
import Stencil
import XCTest

final class BookshelfTests: XCTestCase {
  
  func testBooksJSONParsing() throws {
    let data = try XCTUnwrap(SampleJSON.books.data(using: .utf8))
    let sections = try JSONDecoder().decode([NewShelfSection].self, from: data)
    XCTAssertNotNil(sections)
    
    XCTAssertEqual(sections.count, 2)
    let currentlyReading = try XCTUnwrap(sections.first)    
    let currentlyPending = currentlyReading.books.filter { state in
      if case .pending = state {
        return true
      }
      return false
    }
    
    XCTAssertEqual(currentlyPending.count, 1)
    XCTAssertEqual(currentlyReading.books.count, 4)
    XCTAssertEqual(currentlyReading.header, "Currently Reading")
  }
  
  func testHTMLGeneration() {
    let generated = try? HTMLGenerator.generate(
      sections: [
        ShelfSection(
          header: "Reading",
          books: [
            Book(
              goodreadsURL: "www.goodreads.com",
              title: "Steve Jobs",
              imageURL: "",
              authors: ["Walter Issacson"]
            ),
          ]
        ),
      ])

    XCTAssertNotNil(generated)
  }
  
  func testISBNScrapper() async throws {
    var scrapper: WebScrapper = ISBNSearchScrapper(isbn: "9781099617201")
    let book = try await scrapBook(with: &scrapper)
    XCTAssertNotNil(book)
  }
  
  func testAmazonScrapper() async throws {
    var scrapper: WebScrapper = AmazonScrapper(pid: "1608685489")
    let book = try await scrapBook(with: &scrapper)
    XCTAssertNotNil(book)
  }
  
  static var allTests = [
    ("testBooksJSONParsing", testHTMLGeneration),
    ("testHTMLGeneration", testHTMLGeneration),
    ("testISBNScrapper", testISBNScrapper),
    ("testAmazonScrapper", testAmazonScrapper),
  ]
}

private extension BookshelfTests {
  
  private func jsonData(from string: String) throws -> Data {
    return try XCTUnwrap(string.data(using: .utf8))
  }
  
  func scrapBook(with scrapper: inout WebScrapper) async throws -> NewBook {
    try await scrapper.scrap()
    return try scrapper.buildBook()
  }
  
}
