import Foundation

public enum BookAttribute {
  case title
  case imageURL
  case authors
  case affiliateURL
}

public enum WebScrapperError: Error {
  case invalidHTTPResponse
  case parsingError(BookAttribute)
  case encodingError
}

public protocol WebScrapper {
  func buildBook() throws -> ScrappedBook
  func getTitle() throws -> String
  func getImageURL() throws -> URL
  func getAuthors() throws -> [String]
  func html(from url: URL) async throws -> String
  //  func getAffiliateURL() throws -> URL

  mutating func scrap() async throws
}

public extension WebScrapper {
  func html(from url: URL) async throws -> String {
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
      throw WebScrapperError.invalidHTTPResponse
    }

    guard let htmlStr = String(data: data, encoding: .utf8) else {
      throw WebScrapperError.encodingError
    }
    return htmlStr
  }

  func buildBook() throws -> ScrappedBook {
    try ScrappedBook(
      title: getTitle(),
      imageURL: getImageURL(),
      authors: getAuthors()
    )
  }
}
