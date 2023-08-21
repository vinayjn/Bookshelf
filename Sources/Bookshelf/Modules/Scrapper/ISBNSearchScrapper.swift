import SwiftSoup

import Foundation

enum ISBNSearchError: Error {
  case invalidURL
}

public struct ISBNSearchScrapper: WebScrapper {
  private var book: Element?
  private var bookInfo: Element?

  private let isbn: String

  public init(isbn: String) {
    self.isbn = isbn
  }

  public func getTitle() throws -> String {
    guard let title = try bookInfo?.children().first(where: { $0.tagName() == "h1" })?.text(), title.count > 0 else {
      throw WebScrapperError.parsingError(.title)
    }
    return title
  }

  public func getImageURL() throws -> URL {
    guard
      let imageSrc = try book?.getElementsByClass("image").first()?.children().first()?.attr("src"),
      let url = URL(string: imageSrc)
    else {
      throw WebScrapperError.parsingError(.imageURL)
    }
    return url
  }

  public func getAuthors() throws -> [String] {
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

  public mutating func scrap() async throws {
    let urlString = String(format: "https://isbnsearch.org/isbn/%@", isbn)
    guard let url = URL(string: urlString) else {
      throw ISBNSearchError.invalidURL
    }
    let htmlStr = try await html(from: url)
    let doc = try SwiftSoup.parse(htmlStr)
    book = try doc.getElementById("book")
    bookInfo = try book?.getElementsByClass("bookInfo").first()
  }
}
