//
//  Book.swift
//  libraryProject
//
//  Created by Buse Şentürk
//

import Foundation

struct Book: Codable,Hashable{
    var artistName: String
    var releaseDate: String
    var name: String
    var artworkUrl100: String
}
