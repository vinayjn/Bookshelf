//
//  main.swift
//  Library
//
//  Created by Vinay Jain on 17/04/21.
//

import ArgumentParser

struct Bookshelf: ParsableCommand {
  @Argument(help: "The books json file path")
  var input: String
  
  @Argument(help: "The output md file in which HTML will be written")
  var output: String
  
  mutating func run() throws {
    
    let fileHandler = try FileHandler(path: input)
    let scrapper = Scrapper(fileHandler)
    try scrapper.scrap()
    
    let sections = try fileHandler.getSections()
    let html = HTMLGenerator.generate(sections: sections)
    
    try fileHandler.save(html: html, output: output)
    
    print("Finished")
  }
}

Bookshelf.main()
