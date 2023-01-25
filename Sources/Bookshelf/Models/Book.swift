import Foundation

public struct Book: Codable {
    public let goodreadsURL: String
    public var title: String?
    public var imageURL: String?
    public var authors: [String]?
}
