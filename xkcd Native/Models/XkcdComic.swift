//
//  Comic.swift
//  xkcd Native
//
//  Created by Alf Jørgen Bråtane on 26/06/2022.
//

import Foundation


struct XkcdComic: Codable {
    let month: String
    let num: Int
    let link: String
    let year: String
    let news: String
    let safe_title: String
    let transcript: String
    let alt: String
    let img: String
    let title: String
    let day: String
    
    init() {
        
    }
}
