//
//  ComicDetailView.swift
//  xkcd Native
//
//  Created by Alf Jørgen Bråtane on 23/06/2022.
//

import SwiftUI

struct ComicDetailView: View {
    
    @State private var showingSheet = false
    let comic: XkcdComic
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("\(String(comic.num)): \(comic.title)")
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
        //Button("Get explanation", action: getExplanation)
        Button("Get explaination") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            let expl = ComicService.explain(comic: comic.num)
            ComicExplainationSheetView(explanation: expl)
        }
    }
    
    /*private func getExplanation() {
        let expl = ComicService.explain(comic: comic.num)
    }*/
}
/*
struct ComicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ComicDetailView()
    }
}*/
