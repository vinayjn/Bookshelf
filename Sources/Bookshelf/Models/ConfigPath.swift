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

    page = try URL(fileURLWithPath: container.decode(String.self, forKey: CodingKeys.page))
    section = try URL(fileURLWithPath: container.decode(String.self, forKey: CodingKeys.section))
    book = try URL(fileURLWithPath: container.decode(String.self, forKey: CodingKeys.book))
  }
}

struct ConfigPath: Decodable {
  let booksJSON: URL
  let bookshelf: URL
  let imagesDirectory: URL
  let relativeImagePath: String
  let templatePath: TemplatePath

  enum CodingKeys: CodingKey {
    case booksJSON
    case bookshelf
    case imagesDirectory
    case relativeImagePath
    case templatePath
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    booksJSON = try URL(fileURLWithPath: container.decode(String.self, forKey: CodingKeys.booksJSON))
    bookshelf = try URL(fileURLWithPath: container.decode(String.self, forKey: CodingKeys.bookshelf))
    imagesDirectory = try URL(fileURLWithPath: container.decode(String.self, forKey: CodingKeys.imagesDirectory))
    templatePath = try container.decode(TemplatePath.self, forKey: CodingKeys.templatePath)
    relativeImagePath = try container.decode(String.self, forKey: CodingKeys.relativeImagePath)
  }
}
