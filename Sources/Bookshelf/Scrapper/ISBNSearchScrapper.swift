import SwiftSoup

import Foundation

struct ISBNSearchScrapper: WebScrapper {
    func getTitle() throws -> String {
        guard let title = try bookInfo?.children().first(where: { $0.tagName() == "h1" })?.text(), title.count > 0 else {
            throw WebScrapperError.parsingError(.title)
        }
        return title
    }

    func getImageURL() throws -> URL {
        guard
            let imageSrc = try book?.getElementsByClass("image").first()?.children().first()?.attr("src"),
            let url = URL(string: imageSrc)
        else {
            throw WebScrapperError.parsingError(.imageURL)
        }
        return url
    }

    func getAuthors() throws -> [String] {
        let allPs = bookInfo?.children().filter { $0.tagName() == "p" } ?? []
        var authors = [String]()
        for p in allPs {
            let text = try p.text()
            if text.starts(with: "Author"),
               let authorString = text.split(separator: ":").last
            {
                authors = authorString.components(separatedBy: ";")
                break
            }
        }

        guard authors.count > 0 else {
            throw WebScrapperError.parsingError(.authors)
        }
        return authors
    }

    private let url: URL
    private var book: Element?
    private var bookInfo: Element?

    mutating func scrap() async throws {
        let htmlStr = try await html(from: url)
        let doc = try SwiftSoup.parse(htmlStr)
        book = try doc.getElementById("book")
        bookInfo = try book?.getElementsByClass("bookInfo").first()
    }

    init(url: URL) {
        self.url = url
    }
}
