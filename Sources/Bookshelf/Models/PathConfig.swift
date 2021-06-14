//
//  PathConfig.swift
//  
//
//  Created by Vinay Jain on 21/04/21.
//

import Foundation

public struct Template: Decodable {
  public let page: URL
  public let section: URL
  public let book: URL
  
  public enum CodingKeys: String, CodingKey {
    case page
    case section
    case book
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.page = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.page))
    self.section = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.section))
    self.book = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.book))
  }
  
}

public struct PathConfig: Decodable {
  public let booksJSON: URL
  public let bookshelf: URL
  public let images: URL
  public let relativeImagePath: String
  public let template: Template
   
  public enum CodingKeys: String, CodingKey {
    case booksJSON = "book"
    case bookshelf
    case images
    case relativeImagePath
    case template
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
        
    self.booksJSON = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.booksJSON))
    self.bookshelf = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.bookshelf))
    self.images = URL(fileURLWithPath: try container.decode(String.self, forKey: CodingKeys.images))
    self.template = try container.decode(Template.self, forKey: CodingKeys.template)
    self.relativeImagePath = try container.decode(String.self, forKey: CodingKeys.relativeImagePath)
  }

}

