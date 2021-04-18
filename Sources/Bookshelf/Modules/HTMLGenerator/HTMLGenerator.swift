//
//  HTMLGenerator.swift
//  Library
//
//  Created by Vinay Jain on 17/04/21.
//

import Foundation

class HTMLGenerator {
  
  class func generate(sections: [ShelfSection]) -> String {
    var sectionStrings = [String]()
    for section in sections {
      var books = [String]()
      
      for book in section.books {
        
        guard let bookInfo = book.title?.split(separator: ":").compactMap({ String($0) }),
              let cover = book.imageURL,
              let title = bookInfo.first
        else {
          continue
        }
        
        let subtitle = bookInfo.dropFirst().joined()
        
        books.append(
          String(format: Constants.BOOK, cover, book.goodreadsURL, title, subtitle))
      }
      
      sectionStrings.append(
        String(format: Constants.SECTION, section.header, books.joined(separator: "\n")))
    }
    
    return String(format: Constants.BASE, sectionStrings.joined(separator: "\n"))
  }
  
}
