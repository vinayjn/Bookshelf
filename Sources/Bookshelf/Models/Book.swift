//
//  Book.swift
//  
//
//  Created by Vinay Jain on 09/06/21.
//

import Foundation


/// Book
/// Represents a Book
struct Book: Codable {
  let goodreadsURL: String
  var title: String?
  var imageURL: String?
  var authors: [String]?
}
