import Foundation

public protocol FileHandlerProtocol {
  func getPageTemplate() throws -> String
  func getSectionTemplate() throws -> String
  func getBookTemplate() throws -> String

  func getPersistedSections() throws -> [ShelfSection]
  func save(sections: [ShelfSection]) throws
  func save(html: String) throws
  func saveImage(data: Data) -> String
}

public class FileHandler {
  private let configPath: ConfigPath

  public init(_ configPath: String) throws {
    let pathUrl = URL(fileURLWithPath: configPath)
    let data = try Data(contentsOf: pathUrl)
    self.configPath = try JSONDecoder().decode(ConfigPath.self, from: data)

    try createImagesDirectoryIfNeeded()
  }
}

extension FileHandler: FileHandlerProtocol {
  public func getPageTemplate() throws -> String {
    try String(contentsOf: configPath.templatePath.page, encoding: .utf8)
  }

  public func getSectionTemplate() throws -> String {
    try String(contentsOf: configPath.templatePath.section, encoding: .utf8)
  }

  public func getBookTemplate() throws -> String {
    try String(contentsOf: configPath.templatePath.book, encoding: .utf8)
  }

  public func getPersistedSections() throws -> [ShelfSection] {
    let data = try Data(contentsOf: configPath.booksJSON)
    let sections = try JSONDecoder().decode([ShelfSection].self, from: data)

    return sections
  }

  public func save(sections: [ShelfSection]) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
    let encodedData = try encoder.encode(sections)

    try encodedData.write(to: configPath.booksJSON, options: [])
  }

  public func saveImage(data: Data) -> String {
    let imageNameHash = UUID().uuidString + ".jpg"
    let path = configPath.imagesDirectory.appendingPathComponent(imageNameHash).path
    FileManager.default.createFile(atPath: path, contents: data, attributes: nil)

    return configPath.relativeImagePath.appending(imageNameHash)
  }

  public func save(html: String) throws {
    let data = html.data(using: .utf8)

    if !fileExists(path: configPath.bookshelf.path) {
      print(FileManager.default.createFile(
        atPath: configPath.bookshelf.path,
        contents: data, attributes: nil
      ))
    } else {
      try data?.write(to: configPath.bookshelf, options: [])
    }
  }
}

private extension FileHandler {
  func fileExists(path: String) -> Bool {
    FileManager.default.fileExists(atPath: path)
  }

  func folderExists(path: String) -> Bool {
    var isDirectory = ObjCBool(true)
    let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
  }

  func createImagesDirectoryIfNeeded() throws {
    try FileManager.default.createDirectory(
      at: configPath.imagesDirectory,
      withIntermediateDirectories: true,
      attributes: nil
    )
  }
}
