@testable import Bookshelf
import Foundation
import XCTest

class MockFileHandler: FileHandlerProtocol {
  func getPageTemplate() throws -> String {
    "{{content}}"
  }

  func getSectionTemplate() throws -> String {
    """
    {{header}}

    {{books}}

    """
  }

  func getBookTemplate() throws -> String {
    """
    Cover: {{cover}}
    AffiliateURL: {{affiliateURL}}
    Title: {{title}}
    Authors: {{authors}}
    """
  }

  func getPersistedSections() throws -> [ShelfSection] {
    let data = try XCTUnwrap(SampleJSON.books.data(using: .utf8))
    return try JSONDecoder().decode([ShelfSection].self, from: data)
  }

  func save(sections: [ShelfSection]) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
    let encodedData = try encoder.encode(sections)

    guard let string = String(data: encodedData, encoding: .utf8) else {
      fatalError()
    }
    print("Saved Sections: ", string)
  }

  func save(html: String) throws {
    print("Saved HTML: ", html)
  }

  func saveImage(data _: Data) -> String {
    let imageName = UUID().uuidString
    print("Saved Image: ", imageName)
    return imageName
  }
}
