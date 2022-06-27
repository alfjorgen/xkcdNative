//
//  ComicOverviewView.swift
//  xkcd Native
//
//  Created by Alf Jørgen Bråtane on 26/06/2022.
//

import SwiftUI

let comics: [XkcdComic] = []

struct ComicOverviewView: View {
    var body: some View {
        NavigationView {
            List(comics.indices) { index in
                Text(comics[index].title)
            }
        }
    }
}

struct ComicOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        ComicOverviewView()
    }
}
