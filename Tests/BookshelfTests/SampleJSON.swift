import Foundation

enum SampleJSON {
  static let books = """
  [
  {
    "books": [
      {
        "pid": "1608685489",
        "isbn": "9781608685486"
      },
      {
        "title": "Fluent Forever: How to Learn Any Language Fast and Never Forget It",
        "imageURL": "images/bookshelf/DBED2811-8F95-43B2-B1CF-7110A2ADD75E.jpg",
        "affiliateURL": "https://www.goodreads.com/book/show/19661852-fluent-forever",
        "authors": [
          "Gabriel Wyner"
        ]
      },
      {
        "title": "Recursion",
        "imageURL": "images/bookshelf/5DC2CB0A-AA8D-4A27-90ED-238434E972DE.jpg",
        "affiliateURL": "https://www.goodreads.com/book/show/43592998-recursion",
        "authors": [
          "Blake Crouch"
        ]
      },
      {
        "title": "Refactoring UI",
        "imageURL": "images/bookshelf/17034B44-2F7C-4658-8B29-41C3A5AECB99.jpg",
        "affiliateURL": "https://www.goodreads.com/book/show/43190966-refactoring-ui",
        "authors": [
          "Adam Wathan",
          "Steve Schoger"
        ]
      }
    ],
    "header": "Currently Reading"
  },
  {
    "books": [
      {
        "pid": "1099617200",
        "isbn": "9781099617201"
      }
    ],
    "header": "2023"
  }
  ]
  """
}
