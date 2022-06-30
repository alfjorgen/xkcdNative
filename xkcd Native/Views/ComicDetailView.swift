//
//  ComicDetailView.swift
//  xkcd Native
//
//  Created by Alf Jørgen Bråtane on 23/06/2022.
//

import SwiftUI

struct ComicDetailView: View {
    
    let comic: XkcdComic
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(comic.title)
                    .font(.headline)
                
                AsyncImage(url: URL(string: comic.img),
                           content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: UIScreen.main.bounds.width)
                },
                           placeholder: {
                    ProgressView()
                })
                 
                Spacer()
                
                Text(comic.alt)
                    
                Spacer()
                
                Text("Date: \(comic.year)-\(comic.month)-\(comic.day)")
                    .font(.footnote)
            }
        }
        .padding()
        Button("Get explanation", action: getExplanation)
    }
    
    private func getExplanation() {
        let expl = ComicService.explain(comic: comic.num)
    }
}
/*
struct ComicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ComicDetailView()
    }
}*/
