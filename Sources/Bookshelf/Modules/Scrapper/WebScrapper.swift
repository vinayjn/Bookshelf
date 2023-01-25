import Foundation

enum BookAttribute {
  case title
  case imageURL
  case authors
  case affiliateURL
}

enum WebScrapperError: Error {
  case invalidHTTPResponse
  case parsingError(BookAttribute)
  case encodingError
}

protocol WebScrapper {
  func buildBook() throws -> NewBook
  func getTitle() throws -> String
  func getImageURL() throws -> URL
  func getAuthors() throws -> [String]
  func html(from url: URL) async throws -> String
  //  func getAffiliateURL() throws -> URL
  
  mutating func scrap() async throws
}

extension WebScrapper {
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
  
  func buildBook() throws -> NewBook {
    NewBook(
      affiliateURL: "",
      title: try getTitle(),
      imageURL: try getImageURL().absoluteString,
      authors: try getAuthors()
    )
  }
}
