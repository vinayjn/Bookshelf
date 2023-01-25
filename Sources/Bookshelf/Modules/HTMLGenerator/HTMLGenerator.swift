import Foundation
import Stencil

public class HTMLGenerator {
    private let fileHandler: FileHandlerProtocol

    public init(fileHandler: FileHandlerProtocol) {
        self.fileHandler = fileHandler
    }

    public func generate(sections: [ShelfSection]) throws -> String {
        var sectionStrings = [String]()

        let pageTemplate = Template(templateString: try fileHandler.getPageTemplate())
        let sectionTemplate = Template(templateString: try fileHandler.getSectionTemplate())
        let bookTemplate = Template(templateString: try fileHandler.getBookTemplate())

        for section in sections {
            var books = [String]()

            for book in section.books {
                guard let bookInfo = book.title?.split(separator: ":").compactMap({ String($0) }),
                      let cover = book.imageURL,
                      let title = bookInfo.first,
                      let authors = book.authors?.joined(separator: ", ")
                else {
                    continue
                }

                let subtitle = bookInfo.dropFirst().joined()

                do {
                    let bookString = try bookTemplate.render([
                        "cover": cover,
                        "goodreadsURL": book.goodreadsURL,
                        "title": title,
                        "subtitle": subtitle,
                        "authors": authors,
                    ])
                    books.append(bookString)

                } catch {
                    print("\nTemplating failed for Book: \(title) \n", error)
                }
            }

            do {
                let sectionString = try sectionTemplate.render([
                    "header": section.header,
                    "books": books.joined(separator: "\n"),
                ])
                sectionStrings.append(sectionString)

            } catch {
                print("\nTemplating failed for Section: \(section.header) \n", error)
            }
        }
        return try pageTemplate.render(["content": sectionStrings.joined(separator: "\n")])
    }
}
