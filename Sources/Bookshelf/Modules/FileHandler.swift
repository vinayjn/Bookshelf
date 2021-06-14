//
//  FileHandler.swift
//  Library
//
//  Created by Vinay Jain on 17/04/21.
//

import Foundation

public struct FileError: LocalizedError {
  private let description: String
  
  public init(_ description: String) {
    self.description = description
  }
  
  public var errorDescription: String? {
    return self.description
  }
}

public class FileHandler {
      
  private var pathConfig: PathConfig
  
  public init(_ configPath: String) throws {
    let pathUrl = URL(fileURLWithPath: configPath)
    guard let data = try? Data(contentsOf: pathUrl),
          let pathConfig = try? JSONDecoder().decode(PathConfig.self, from: data) else {
      throw FileError("Cannot parse PathConfig with the given file")
    }
    
    self.pathConfig = pathConfig
    try self.createImagesDirectoryIfNeeded()
  }
  
  public func getSections() throws -> [ShelfSection] {
    let data = try Data(contentsOf: self.pathConfig.booksJSON)
    let sections = try JSONDecoder().decode([ShelfSection].self, from: data)
    
    return sections
  }
  
  public func write(sections: [ShelfSection]) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
    let encodedData = try encoder.encode(sections)
    
    try encodedData.write(to: self.pathConfig.booksJSON, options: [])
  }
  
  public func saveImage(data: Data, book title: String) -> String {
    let imageNameHash = title.MD5() + ".jpg"
    
    let path = self.pathConfig.images.appendingPathComponent(imageNameHash).path
    FileManager.default.createFile(
      atPath: path,
      contents: data, attributes: nil)
    return self.pathConfig.relativeImagePath.appending(imageNameHash)
  }
  
  public func save(html: String) throws {
    let data = html.data(using: .utf8)
    
    if !fileExists(path: self.pathConfig.bookshelf.path) {
      print(FileManager.default.createFile(
              atPath: self.pathConfig.bookshelf.path,
        contents: data, attributes: nil))
    } else {
      try data?.write(to: self.pathConfig.bookshelf, options: [])
    }
  }
  
}

extension FileHandler {
  
  public func getPageTemplate() throws -> String {
    return try String(contentsOf: self.pathConfig.template.page, encoding: .utf8)
  }
  
  public func getSectionTemplate() throws -> String {
    return try String(contentsOf: self.pathConfig.template.section, encoding: .utf8)
  }
  
  public func getBookTemplate() throws -> String {
    return try String(contentsOf: self.pathConfig.template.book, encoding: .utf8)
  }
  
}

private extension FileHandler {
  
  func fileExists(path: String) -> Bool {
    return FileManager.default.fileExists(atPath: path)
  }
  
  func folderExists(path: String) -> Bool {
    var isDirectory = ObjCBool(true)
    let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
  }
  
  func createImagesDirectoryIfNeeded() throws {
    try FileManager.default.createDirectory(
      at: self.pathConfig.images,
      withIntermediateDirectories: true,
      attributes: nil)
  }
  
}
