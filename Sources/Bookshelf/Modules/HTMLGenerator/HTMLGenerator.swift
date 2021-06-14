//
//  HTMLGenerator.swift
//  Library
//
//  Created by Vinay Jain on 17/04/21.
//

import Foundation

public class HTMLGenerator {
  
  private let fileHandler: FileHandler
  
  public init(fileHandler: FileHandler) {
    self.fileHandler = fileHandler
  }
  
  public func generate(sections: [ShelfSection]) throws -> String {
    var sectionStrings = [String]()
    
    let pageTemplate = try self.fileHandler.getPageTemplate()
    let sectionTemplate = try self.fileHandler.getSectionTemplate()
    let bookTemplate = try self.fileHandler.getBookTemplate()
              
    for section in sections {
      var books = [String]()
      
      for book in section.books {
        
        guard let bookInfo = book.title?.split(separator: ":").compactMap({ String($0) }),
              let cover = book.imageURL,
              let title = bookInfo.first,
              let authors = book.authors?.joined(separator: ", ")
        else {
          continue
        }
        
        let subtitle = bookInfo.dropFirst().joined()
        
        let bookString = bookTemplate
          .replacingOccurrences(of: "{{cover}}", with: cover)
          .replacingOccurrences(of: "{{goodreadsURL}}", with: book.goodreadsURL)
          .replacingOccurrences(of: "{{title}}", with: title)
          .replacingOccurrences(of: "{{subtitle}}", with: subtitle)
          .replacingOccurrences(of: "{{authors}}", with: authors)
        
        books.append(bookString)          
      }
      
      sectionStrings.append(
        sectionTemplate
          .replacingOccurrences(of: "{{header}}", with: section.header)
          .replacingOccurrences(of: "{{books}}", with: books.joined(separator: "\n")))
    }
    
    return pageTemplate.replacingOccurrences(of: "{{content}}", with: sectionStrings.joined(separator: "\n"))
  }
  
}
