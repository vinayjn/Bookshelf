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


  I pick up a lot of books and only get through a few.

  Mentioned below are some books that continued grabbing my attention from start to finish.

  <div class="bookshelf">%@</div>
  """
  
  static let SECTION = """
  <div class="section"><h3>%@</h3>%@</div>
  """
  
  static let BOOK = """
  <div class="book">
    <div class="book-detail-row">
      <img class="book-cover" src="{{ site.baseurl }}/%@">
      <div class="book-text-col">
        <span class="book-title"> %@</span>
        <span class="book-authors"> %@</span>
      </div>
    </div>
  </div>
  """
}
