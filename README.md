# Bookshelf

[![Swift](https://github.com/vinayjn/Bookshelf/actions/workflows/swift.yml/badge.svg)](https://github.com/vinayjn/Bookshelf/actions/workflows/swift.yml)

A command-line tool that generates the bookshelf page on my website [https://vinayjain.me/bookshelf](https://vinayjain.me/bookshelf). 

### Installation

```bash
git clone https://github.com/vinayjn/Bookshelf.git
cd Bookshelf 
make install

bookshelf books.json bookshelf.md 
```



### Dependencies

- [Kanna](https://github.com/tid-kijyun/Kanna.git) for scrapping websites.

- [Argument Parser](https://github.com/apple/swift-argument-parser) for the basic command line interface.



### How does it work?

Bookshelf is simply a web scrapper, it fetches basic information of books from Goodreads. It expects two input arguments

- A JSON file which is split into sections, each section represent a row in a real-world bookshelf. It has the following format:

  ```json
  [
    {
      "header": "Currently Reading",
      "books": [
        {
          "goodreadsURL": "https://www.goodreads.com/book/show/40591677-keep-going"        
        },
        {
          "goodreadsURL": "https://www.goodreads.com/book/show/840.The_Design_of_Everyday_Things"        
        }      
      ]
    },
    {
      "header": "Read",
      "books": [
        {
          "goodreadsURL": "https://www.goodreads.com/book/show/11084145-steve-jobs"        
        },
        {
          "goodreadsURL": "https://www.goodreads.com/book/show/27833670-dark-matter"        
        }
      ]
    }
  ]
  ```

- Path to an output file where the final `HTML` of the bookshelf will be written.



Each of these URLs represent a book and because the scrapper works by traversing the `HTML` document, it is necessary to provide the correct URLs else the data for the book won't be added. In the existing  implementation, the scrapper looks for the following information:

- title
- thumbnail url
- author names

These properties are then written back to the original input `JSON` to avoid scrapping for exisiting books in shelf. 

```json
[
  {
  	"header" : "Currently Reading",
    "books" : [
      {
        "title" : "Keep Going: 10 Ways to Stay Creative in Good Times and Bad",
        "imageURL" : "images/bookshelf/afca15c8915d0ef2008995c803e9d62d.jpg",
        "goodreadsURL" : "https://www.goodreads.com/book/show/40591677-keep-going",
        "authors" : [
          "Austin Kleon"
        ]
      },
      {
        "title" : "The Design of Everyday Things",
        "imageURL" : "images/bookshelf/129ab3effe978b743bc1a58f918a4f87.jpg",
        "goodreadsURL" : "https://www.goodreads.com/book/show/840.The_Design_of_Everyday_Things",
        "authors" : [
          "Donald A. Norman"
        ]
      }
  },
  {
  	"header" : "Read",
    "books" : [
      {
        "title" : "Steve Jobs",
        "imageURL" : "images/bookshelf/7f76ff8615d64e788ea5e9633def1625.jpg",
        "goodreadsURL" : "https://www.goodreads.com/book/show/11084145-steve-jobs",
        "authors" : [
          "Walter Isaacson"
        ]
      },
      {
        "title" : "Dark Matter",
        "imageURL" : "images/bookshelf/2360b31c1628a21ddd778891dabac91d.jpg",
        "goodreadsURL" : "https://www.goodreads.com/book/show/27833670-dark-matter",
        "authors" : [
          "Blake Crouch"
        ]
      }
    ]
  }
]
```



### Todo

Right now most of the configuration of the scrapper is hardcoded as per my usecase. The following needs to be done to get more flexibility 

- [ ] Provide a config file to read `HTML` template
- [ ] Provide images directory path as a parameter

