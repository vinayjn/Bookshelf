@testable import Bookshelf
import Stencil
import XCTest

final class BookshelfTests: XCTestCase {
  func testSaveSections() throws {
    let data = try XCTUnwrap(SampleJSON.books.data(using: .utf8))
    let sections = try JSONDecoder().decode([ShelfSection].self, from: data)

    let fileHandler = MockFileHandler()

    try fileHandler.save(sections: sections)
  }

  func testBooksJSONParsing() throws {
    let data = try XCTUnwrap(SampleJSON.books.data(using: .utf8))
    let sections = try JSONDecoder().decode([ShelfSection].self, from: data)
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

  func testHTMLGeneration() throws {
    let fileHandler = MockFileHandler()
    let sections = try fileHandler.getPersistedSections()
    let templateConfiguration = try TemplateConfiguration(
      page: fileHandler.getPageTemplate(),
      section: fileHandler.getSectionTemplate(),
      book: fileHandler.getBookTemplate()
    )

    let html = try HTMLGenerator.generate(using: sections, templateConfiguration: templateConfiguration)
    XCTAssertNotNil(html)
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
    try XCTUnwrap(string.data(using: .utf8))
  }

  func scrapBook(with scrapper: inout WebScrapper) async throws -> ScrappedBook {
    try await scrapper.scrap()
    return try scrapper.buildBook()
  }
}
