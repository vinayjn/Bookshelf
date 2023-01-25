import Foundation

public struct ShelfSection: Codable {
    public let header: String
    public var books: [Book]
}
