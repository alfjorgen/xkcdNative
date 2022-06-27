//
//  Comic.swift
//  xkcd Native
//
//  Created by Alf Jørgen Bråtane on 26/06/2022.
//

import Foundation
import UIKit

struct Comic {
    let xkcdComic: XkcdComic
    var comicImg: UIImage?
    var favorite: Bool = false
    var explanation: String?
}
