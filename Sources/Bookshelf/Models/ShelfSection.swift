//
//  ShelfSection.swift
//  Library
//
//  Created by Vinay Jain on 17/04/21.
//

import Foundation

struct Book: Codable {
  let goodreadsURL: String
  var title: String?
  var imageURL: String?
  var authors: [String]?
}

struct ShelfSection: Codable {
  let header: String
  var books: [Book]
}
