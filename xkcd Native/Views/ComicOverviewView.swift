//
//  ComicOverviewView.swift
//  xkcd Native
//
//  Created by Alf Jørgen Bråtane on 26/06/2022.
//

import SwiftUI

struct ComicOverviewView: View {
    @StateObject var comicService = ComicService()
    
    @State private var comics = [XkcdComic]()
    var body: some View {
        NavigationView {
            List(comicService.comics, id: \.num) { item in
                NavigationLink(destination: ComicDetailView(comic: item)) {
                    ComicListItemListView(comic: item)
                        .task {
                            if !comicService.isFetching {
                                try? await comicService.fetchComics()
                            }
                        }
                }
                        
            }
            .task {
                if !comicService.isFetching {
                    try? await comicService.fetchComics()
                }
            }             
        }
    }
    
}

struct ComicListItemListView: View {
    let comic: XkcdComic
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(comic.title)
                .font(.headline)
            Text("\(comic.year)-\(comic.month)-\(comic.day)")
                .font(.subheadline)
        }
    }
}

struct ComicOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        ComicOverviewView()
    }
}
