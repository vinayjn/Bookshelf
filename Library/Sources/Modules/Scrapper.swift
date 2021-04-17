//
//  LibraryBuilder.swift
//  Library
//
//  Created by Vinay Jain on 17/04/21.
//

import Kanna
import Foundation

class Scrapper {
  
  private let fileHandler: FileHandler
  
  init(_ fileHandler: FileHandler) {
    self.fileHandler = fileHandler
  }
  
  func scrap() throws {
    var sections = try self.fileHandler.getSections()
    
    for sectionIndex in 0..<sections.count {
      var books = sections[sectionIndex].books
      
      for bookIndex in 0..<books.count {
        if books[bookIndex].title == nil || books[bookIndex].imageURL == nil {
          if let book = self.scrapBookDetails(using: books[bookIndex].goodreadsURL) {
            books[bookIndex] = book
          }
        }
      }
      
      sections[sectionIndex].books = books
    }
    
    try self.fileHandler.write(sections: sections)
  }
  
}

private extension Scrapper {
  
  func scrapBookDetails(using urlString: String) -> Book? {
    guard let url = URL(string: urlString),
          let html = try? HTML(url: url, encoding: .utf8),
          let title = self.getTitleText(from: html),
          let imageURLString = self.getCoverImageURL(from: html),
          let imageURL = URL(string: imageURLString),
          let imageData = try? Data(contentsOf: imageURL)
    else {
      return nil
    }
    
    return Book(
      goodreadsURL: urlString,
      title: title,
      imageURL: self.fileHandler.saveImage(data: imageData, book: title))
  }
  
  func getTitleText(from html: HTMLDocument) -> String? {
    return html.at_xpath("//*[@id=\"bookTitle\"]")?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  func getCoverImageURL(from html: HTMLDocument) -> String? {
    let coverImage = html.at_xpath("//*[@id=\"coverImage\"]")
    let src = coverImage?["src"]
    
    return src?.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
}
