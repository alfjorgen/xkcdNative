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
        NavigationView{
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(comic.title)")
                        .font(.title)
                        .bold()
                    
                    AsyncImage(url: URL(string: comic.img),
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: UIScreen.main.bounds.width)
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )
                     
                    Spacer()
                    
                    Text(comic.alt)
                        
                    Spacer()
                    
                    Text("Date: \(comic.year)-\(comic.month)-\(comic.day)")
                        .font(.footnote)
                }
            }
        }
        .navigationTitle("\(String(comic.num))")
        .padding()
        .toolbar{ Button(action: shareSheet){
            Image(systemName: "square.and.arrow.up")
        }}
        
        Button("Get explanation") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            let expl = ComicService.explain(comic: comic.num)
            ComicExplainationSheetView(explanation: expl)
        }
        
    }
    func shareSheet() {
        let url = URL(string: "https://xkcd.com/\(String(comic.num))")
        let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
    }
}
