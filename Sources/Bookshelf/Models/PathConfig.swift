import Foundation

struct TemplatePath: Decodable {
    let page: URL
    let section: URL
    let book: URL

    enum CodingKeys: String, CodingKey {
        case page
        case section
        case book
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        page = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.page))
        section = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.section))
        book = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.book))
    }
}

struct PathConfig: Decodable {
    let booksJSON: URL
    let bookshelf: URL
    let images: URL
    let relativeImagePath: String
    let template: TemplatePath

    enum CodingKeys: String, CodingKey {
        case booksJSON = "book"
        case bookshelf
        case images
        case relativeImagePath
        case template
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        booksJSON = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.booksJSON))
        bookshelf = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.bookshelf))
        images = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.images))
        template = try container.decode(TemplatePath.self, forKey: CodingKeys.template)
        relativeImagePath = try container.decode(String.self, forKey: CodingKeys.relativeImagePath)
    }
}
