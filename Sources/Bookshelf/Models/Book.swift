//
//  Book.swift
//  Bookshelf
//
//  Created by Vinay Jain on 09/06/21.
//

import Foundation

struct Book: Codable {
  public let goodreadsURL: String
  public var title: String?
  public var imageURL: String?
  public var authors: [String]?
}
