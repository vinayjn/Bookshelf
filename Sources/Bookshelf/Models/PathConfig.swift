//
//  PathConfig.swift
//  
//
//  Created by Vinay Jain on 21/04/21.
//

import Foundation

struct Template: Decodable {
  let page: URL
  let section: URL
  let book: URL
  
  enum CodingKeys: String, CodingKey {
    case page
    case section
    case book
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.page = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.page))
    self.section = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.section))
    self.book = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.book))
  }
  
}

struct PathConfig: Decodable {
  let booksJSON: URL
  let bookshelf: URL
  let images: URL
  let relativeImagePath: String
  let template: Template
   
  enum CodingKeys: String, CodingKey {
    case booksJSON = "book"
    case bookshelf
    case images
    case relativeImagePath
    case template
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
        
    self.booksJSON = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.booksJSON))
    self.bookshelf = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.bookshelf))
    self.images = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.images))
    self.template = try container.decode(Template.self, forKey: CodingKeys.template)
    self.relativeImagePath = try container.decode(String.self, forKey: CodingKeys.relativeImagePath)
  }

}

