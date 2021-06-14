//
//  ShelfSection.swift
//  Library
//
//  Created by Vinay Jain on 17/04/21.
//

import Foundation

struct ShelfSection: Codable {
  let header: String
  var books: [Book]
}
