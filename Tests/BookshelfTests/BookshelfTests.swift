@testable import Bookshelf
import Stencil
import XCTest

final class FileHandlerMock: FileHandlerProtocol {
    func getPageTemplate() throws -> String {
        "{{content}}"
    }

    func getSectionTemplate() throws -> String {
        "Header: {{header}}\n Books: {{books}}"
    }

    func getBookTemplate() throws -> String {
        "Title: {{title}} Subtitle: {{subtitle}} Goodreads: {{goodreadsURL}} Authors: {{authors}} Cover: {{cover}}"
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
                            authors: ["Walter Issacson"]
                        ),
                    ]
                ),
            ])

        XCTAssertNotNil(generated)
    }

    func testISBNScrapper() async throws {
        let url = URL(string: "https://isbnsearch.org/isbn/9781099617201")!
        var scrapper: WebScrapper = ISBNSearchScrapper(url: url)
        let book = try await scrapBook(with: &scrapper)

        XCTAssertNotNil(book)
    }

    func testAmazonScrapper() async throws {
        let url = URL(string: "https://www.amazon.co.uk/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164")!
        var scrapper: WebScrapper = AmazonScrapper(url: url)
        let book = try await scrapBook(with: &scrapper)
        print(book)
        XCTAssertNotNil(book)
    }

    func scrapBook(with scrapper: inout WebScrapper) async throws -> Book {
        try await scrapper.scrap()
        return try scrapper.buildBook()
    }

    static var allTests = [
        ("testHTMLGeneration", testHTMLGeneration),
        ("testISBNScrapper", testISBNScrapper),
        ("testAmazonScrapper", testAmazonScrapper),
    ]
}
