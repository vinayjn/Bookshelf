//
//  String.swift
//  Library
//
//  Created by Vinay Jain on 17/04/21.
//

import Foundation
import Crypto

public extension String {
  
  /// - Returns: an MD5 secure hash representation for the string
  func MD5() -> String {
    let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
    
    return digest.map {
      String(format: "%02hhx", $0)
    }.joined()
  }
  
}
