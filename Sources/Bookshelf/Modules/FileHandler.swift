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
        description
    }
}

public protocol FileHandlerProtocol {
    func getPageTemplate() throws -> String

    func getSectionTemplate() throws -> String

    func getBookTemplate() throws -> String
}

public class FileHandler {
    private var pathConfig: PathConfig

    public init(_ configPath: String) throws {
        let pathUrl = URL(fileURLWithPath: configPath)
        guard let data = try? Data(contentsOf: pathUrl),
              let pathConfig = try? JSONDecoder().decode(PathConfig.self, from: data)
        else {
            throw FileError("Cannot parse PathConfig with the given file")
        }

        self.pathConfig = pathConfig
        try createImagesDirectoryIfNeeded()
    }

    public func getSections() throws -> [ShelfSection] {
        let data = try Data(contentsOf: pathConfig.booksJSON)
        let sections = try JSONDecoder().decode([ShelfSection].self, from: data)

        return sections
    }

    func write(sections: [ShelfSection]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
        let encodedData = try encoder.encode(sections)

        try encodedData.write(to: pathConfig.booksJSON, options: [])
    }

    func saveImage(data: Data, book _: String) -> String {
        let imageNameHash = UUID().uuidString + ".jpg"

        let path = pathConfig.images.appendingPathComponent(imageNameHash).path
        FileManager.default.createFile(
            atPath: path,
            contents: data, attributes: nil
        )
        return pathConfig.relativeImagePath.appending(imageNameHash)
    }

    public func save(html: String) throws {
        let data = html.data(using: .utf8)

        if !fileExists(path: pathConfig.bookshelf.path) {
            print(FileManager.default.createFile(
                atPath: pathConfig.bookshelf.path,
                contents: data, attributes: nil
            ))
        } else {
            try data?.write(to: pathConfig.bookshelf, options: [])
        }
    }
}

extension FileHandler: FileHandlerProtocol {
    public func getPageTemplate() throws -> String {
        try String(contentsOf: pathConfig.template.page, encoding: .utf8)
    }

    public func getSectionTemplate() throws -> String {
        try String(contentsOf: pathConfig.template.section, encoding: .utf8)
    }

    public func getBookTemplate() throws -> String {
        try String(contentsOf: pathConfig.template.book, encoding: .utf8)
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
            at: pathConfig.images,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
}
