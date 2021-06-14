//
//  ShelfSection.swift
//  Library
//
//  Created by Vinay Jain on 17/04/21.
//

import Foundation

public struct ShelfSection: Codable {
  public let header: String
  public var books: [Book]
}
