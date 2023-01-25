import Foundation

public struct Book: Codable {
  public let goodreadsURL: String
  public var title: String?
  public var imageURL: String?
  public var authors: [String]?
}


public struct ShelfSection: Codable {
    public let header: String
    public var books: [Book]
}


public struct NewBook: Codable {
  public let affiliateURL: String
  public let title: String
  public let imageURL: String
  public let authors: [String]
}

public struct PendingBook: Codable {
  let pid: String
  let isbn: String
}

public enum BookState: Codable {
  case pending(PendingBook)
  case resolved(NewBook)
  
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
      self = .resolved(try NewBook(from: decoder))
    }
  }
}

public struct NewShelfSection: Codable {
  public let header: String
  public var books: [BookState]
}

