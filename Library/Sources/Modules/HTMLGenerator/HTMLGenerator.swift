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
        books.append(
          String(format: Constants.BOOK, book.imageURL!, book.title!, book.title!))
      }
      
      sectionStrings.append(
        String(format: Constants.SECTION, section.header, books.joined(separator: "\n")))
    }
    
    return String(format: Constants.BASE, sectionStrings.joined(separator: "\n"))
  }
  
}
