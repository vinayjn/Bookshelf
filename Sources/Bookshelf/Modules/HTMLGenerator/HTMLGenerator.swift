import Foundation
import Stencil

enum HTMLGeneratorError: Error {
  case templateError(String)
}

public enum HTMLGenerator {
  public static func generate(using sections: [ShelfSection], templateConfiguration: TemplateConfiguration) throws -> String {
    guard templateConfiguration.page.contains("{{content}}") else {
      throw HTMLGeneratorError.templateError("Page template must contain {{content}}")
    }

    guard
      templateConfiguration.section.contains("{{header}}"),
      templateConfiguration.section.contains("{{books}}")
    else {
      throw HTMLGeneratorError.templateError(
        "Section template must contain {{header}} and {{books}}"
      )
    }

    guard
      templateConfiguration.book.contains("{{cover}}"),
      templateConfiguration.book.contains("{{title}}"),
      templateConfiguration.book.contains("{{authors}}"),
      templateConfiguration.book.contains("{{affiliateURL}}")
    else {
      throw HTMLGeneratorError.templateError(
        "Book template must contain {{cover}}, {{title}}, {{authors}} and {{affiliateURL}}"
      )
    }
    let pageTemplate = Template(templateString: templateConfiguration.page)
    let sectionTemplate = Template(templateString: templateConfiguration.section)
    let bookTemplate = Template(templateString: templateConfiguration.book)

    var sectionStrings = [String]()

    for section in sections {
      var books = [String]()

      for bookState in section.books {
        if case let .resolved(newBook) = bookState {
          let title = newBook.title.components(separatedBy: ":")[0]
          let authors = newBook.authors
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined(separator: ", ")
          let bookString = try bookTemplate.render([
            "cover": newBook.imageURL,
            "affiliateURL": newBook.affiliateURL,
            "title": title,
            "authors": authors,
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
