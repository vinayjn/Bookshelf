import Foundation
import XCTest
@testable import Bookshelf

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
    print("Saved Sections: ", sections.count)
  }
  
  func save(html: String) throws {
    print("Saved HTML: ", html)
  }
  
  func saveImage(data: Data) -> String {
    let imageName = UUID().uuidString
    print("Saved Image: ", imageName)
    return imageName
  }
  
}
