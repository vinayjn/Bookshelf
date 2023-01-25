import Foundation

public struct TemplateConfiguration {
  public let page: String
  public let section: String
  public let book: String
  
  public init(page: String, section: String, book: String) {
    self.page = page
    self.section = section
    self.book = book
  }
  
}
