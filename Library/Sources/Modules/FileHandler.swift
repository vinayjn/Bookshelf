//
//  FileHandler.swift
//  Library
//
//  Created by Vinay Jain on 17/04/21.
//

import Foundation

struct FileError: LocalizedError {
  private let description: String
  
  init(_ description: String) {
    self.description = description
  }
  
  var errorDescription: String? {
    return self.description
  }
}

private enum FileConstants {
  static let IMAGES_FOLDER = "images/bookshelf/"
}

class FileHandler {
  
  private let jsonPath: URL
  private let baseURL: URL
  private let imageDirectory: URL
  
  init(path: String) throws {
    self.jsonPath = URL(fileURLWithPath: path)
    
    self.baseURL = self.jsonPath.deletingLastPathComponent()
    self.imageDirectory = self.baseURL.appendingPathComponent(FileConstants.IMAGES_FOLDER)
    
    if !self.fileExists(path: path) {
      throw FileError("Provided JSON doesn't exists")
    }
    
    try self.createImagesDirectoryIfNeeded()
  }
  
  func getSections() throws -> [ShelfSection] {
    let data = try Data(contentsOf: self.jsonPath)    
    let sections = try JSONDecoder().decode([ShelfSection].self, from: data)
    
    return sections
  }
  
  func write(sections: [ShelfSection]) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
    let encodedData = try encoder.encode(sections)
    
    try encodedData.write(to: self.jsonPath, options: [])
  }
  
  func saveImage(data: Data, book title: String) -> String {
    let imageNameHash = title.MD5() + ".jpg"
    
    let path = self.imageDirectory.appendingPathComponent(imageNameHash).path
    FileManager.default.createFile(
      atPath: path,
      contents: data, attributes: nil)
    return FileConstants.IMAGES_FOLDER.appending(imageNameHash)
  }
  
  func save(html: String, output: String) throws {
    let data = html.data(using: .utf8)
    let mdPath = URL(fileURLWithPath: output)
    
    if !fileExists(path: output) {
      FileManager.default.createFile(
        atPath: output,
        contents: data, attributes: nil)
    } else {
      try data?.write(to: mdPath, options: [])
    }
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
      at: self.imageDirectory,
      withIntermediateDirectories: true,
      attributes: nil)
  }
  
}
