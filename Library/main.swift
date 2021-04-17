//
//  main.swift
//  Library
//
//  Created by Vinay Jain on 17/04/21.
//

import ArgumentParser

struct LibraryParser: ParsableCommand {
    @Argument(help: "The books json file path")
    var inputJSON: String

    mutating func run() throws {
      
      let fileHandler = try FileHandler(path: inputJSON)
      let builder = LibraryBuilder(fileHandler)
      try builder.build()
      
//      let generator = HTMLGenerator(path: inputJSON)
//      generator.generate()
      
    }
}

LibraryParser.main(["/Users/vinayjain/personal/web/lc/swift.json"])
