import Foundation
import SwiftSoup

struct AmazonScrapper {
    private let url: URL
    private var document: Document?

    init(url: URL) {
        self.url = url
    }
}

extension AmazonScrapper: WebScrapper {
    func getTitle() throws -> String {
        guard
            let productTitle = try document?.getElementById("productTitle")?.text(),
            productTitle.count > 0
        else {
            throw WebScrapperError.parsingError(.title)
        }

        return productTitle
    }

    func getImageURL() throws -> URL {
        guard
            let imageSrc = try document?.getElementById("imgBlkFront")?.attr("src"),
            let url = URL(string: imageSrc)
        else {
            throw WebScrapperError.parsingError(.imageURL)
        }
        return url
    }

    func getAuthors() throws -> [String] {
        guard
            let byLineInfo = try document?.getElementById("bylineInfo")
        else {
            throw WebScrapperError.parsingError(.authors)
        }

        let authorSpans = byLineInfo.children().filter { $0.tagName() == "span" }
        var authors = [String]()
        for authorSpan in authorSpans {
            if let author = try? authorSpan.children().first(where: { $0.tagName() == "a" })?.text() {
                authors.append(author)
            }
        }
        guard !authors.isEmpty else {
            throw WebScrapperError.parsingError(.authors)
        }

        return authors
    }

    mutating func scrap() async throws {
        let htmlStr = try await html(from: url)
        document = try SwiftSoup.parse(htmlStr)
    }
}
