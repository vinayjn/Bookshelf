import Foundation

public struct ScrappedBook {
  public let title: String
  public let imageURL: URL
  public let authors: [String]
  
  public init(title: String, imageURL: URL, authors: [String]) {
    self.title = title
    self.imageURL = imageURL
    self.authors = authors
  }
}

public struct ResolvedBook: Codable {
  public let title: String
  public let imageURL: String
  public let authors: [String]
  public let affiliateURL: String
  
  public init(title: String, imageURL: String, authors: [String], affiliateURL: String) {
    self.title = title
    self.imageURL = imageURL
    self.authors = authors
    self.affiliateURL = affiliateURL
  }
}

public struct PendingBook: Codable {
  public let pid: String
  public let isbn: String
  
  public init(pid: String, isbn: String) {
    self.pid = pid
    self.isbn = isbn
  }
}

public enum BookState: Codable {
  case pending(PendingBook)
  case resolved(ResolvedBook)
  
  enum Keys: String, CodingKey {
    case pid
    case isbn
    case title
    case imageURL
    case authors
    case affliateURL
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Keys.self)
    if container.contains(Keys.isbn) && container.contains(Keys.pid) {
      self = .pending(try PendingBook(from: decoder))
    } else {
      self = .resolved(try ResolvedBook(from: decoder))
    }
  }
}

public struct ShelfSection: Codable {

  public let header: String
  public let books: [BookState]
  
  public init(header: String, books: [BookState]) {
    self.header = header
    self.books = books
  }
  
}

