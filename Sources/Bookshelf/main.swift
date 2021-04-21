//
//  main.swift
//  Library
//
//  Created by Vinay Jain on 17/04/21.
//

import ArgumentParser

struct Bookshelf: ParsableCommand {
  
  @Argument(help: "Path to the config file containing template details etc")
  var configPath: String
  
  mutating func run() throws {
    let fileHandler = try FileHandler(configPath)
    
    let scrapper = Scrapper(fileHandler)
    try scrapper.scrap()

    let sections = try fileHandler.getSections()
    let html = try HTMLGenerator(fileHandler: fileHandler).generate(sections: sections)

    try fileHandler.save(html: html)
  }
}

Bookshelf.main()
