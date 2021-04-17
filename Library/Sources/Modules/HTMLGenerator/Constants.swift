//
//  Constants.swift
//  Library
//
//  Created by Vinay Jain on 17/04/21.
//

import Foundation

public enum Constants {
  
  static let BASE = """
  ---
  layout: page
  title: Books
  permalink: /bookshelf/
  tags: bookshelf
  ---

  <div class="bookshelf">%@</div>
  """
  
  static let SECTION = """
  <div class="section">%@</div>
  """
  
  static let BOOK = """
  <div class="book">
    <div class="book-detail-row">
      <img class="book-cover" src="{{ site.baseurl }}/images/bookshelf/0af706f9c7d2d3e6e058db608c6eaa4b.jpg">
      <div class="book-text-col">
        <span class="book-title"> %@</span>
        <span class="book-authors"> %@</span>
      </div>
    </div>
  </div>
  """
}
