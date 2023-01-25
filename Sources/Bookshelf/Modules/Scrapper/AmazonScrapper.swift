import Foundation
import SwiftSoup

public enum AmazonError: Error {
  case invalidURL
}

public struct AmazonScrapper {
  
  private let productID: String
  private var document: Document?
  
  public init(pid: String) {
    self.productID = pid
  }
  
}

extension AmazonScrapper: WebScrapper {
  public func getTitle() throws -> String {
    guard
      let productTitle = try document?.getElementById("productTitle")?.text(),
      productTitle.count > 0
    else {
      throw WebScrapperError.parsingError(.title)
    }
    
    return productTitle
  }
  
  public func getImageURL() throws -> URL {
    guard
      let imageSrc = try document?.getElementById("imgBlkFront")?.attr("src"),
      let url = URL(string: imageSrc)
    else {
      throw WebScrapperError.parsingError(.imageURL)
    }
    return url
  }
  
  public func getAuthors() throws -> [String] {
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
  
  public mutating func scrap() async throws {
    let urlString = String(format: "https://www.amazon.in/gp/product/%@", productID)
    guard let url = URL(string: urlString) else {
      throw AmazonError.invalidURL
    }
    let htmlStr = try await html(from: url)
    document = try SwiftSoup.parse(htmlStr)
  }
}
