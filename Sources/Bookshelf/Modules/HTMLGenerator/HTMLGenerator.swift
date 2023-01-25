import Foundation
import Stencil

enum HTMLGeneratorError: Error {
  case templateError(String)
}

public class HTMLGenerator {

  public static func generate(using sections: [NewShelfSection], templateConfiguration: TemplateConfiguration) throws -> String {
    guard templateConfiguration.page.contains("{{content}}") else {
      throw HTMLGeneratorError.templateError("Invalid page template")
    }
    
    guard
      templateConfiguration.section.contains("{{header}}"),
      templateConfiguration.section.contains("{{books}}")
    else {
      throw HTMLGeneratorError.templateError("Invalid section template")
    }
    
    guard
      templateConfiguration.book.contains("{{cover}}"),
      templateConfiguration.book.contains("{{title}}"),
      templateConfiguration.book.contains("{{authors}}"),
      templateConfiguration.book.contains("{{affiliateURL}}")
    else {
      throw HTMLGeneratorError.templateError("Invalid book template")
    }
    
    let pageTemplate = Template(templateString: templateConfiguration.page)
    let sectionTemplate = Template(templateString: templateConfiguration.section)
    let bookTemplate = Template(templateString: templateConfiguration.book)

    var sectionStrings = [String]()
    
    for section in sections {
      var books = [String]()
      
      for bookState in section.books {
        if case let .resolved(newBook) = bookState {
          let bookString = try bookTemplate.render([
            "cover": newBook.imageURL,
            "affiliateURL": "",
            "title": newBook.title,
            "authors": newBook.authors,
          ])
          books.append(bookString)
        }
      }
      
      let sectionString = try sectionTemplate.render([
        "header": section.header,
        "books": books.joined(separator: "\n"),
      ])
      sectionStrings.append(sectionString)
    }
    
    return try pageTemplate.render(["content": sectionStrings.joined(separator: "\n")])
  }
}
