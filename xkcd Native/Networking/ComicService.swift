//
//  ComicService.swift
//  xkcd Native
//
//  Created by Alf Jørgen Bråtane on 27/06/2022.
//

import Foundation

enum ComicError: Error {
    case urlError
    case connectionError
    case parsingError
}

extension ComicError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlError:
            return NSLocalizedString("An invalid URL was encountered", comment: "Error in URL")
        case .connectionError:
            return NSLocalizedString("Please check your connection", comment: "Error connecting to service")
        case .parsingError:
            return NSLocalizedString("An error occured while parsing data", comment: "Parsing error")
        }
    }
}
class ComicService {
    static let shared: ComicService = ComicService()
    func fetchComic(num: Int?, completion: @escaping (Result<Comic,ComicError>) -> Void) {
        var comicUrl: String
        if let comicNum = num {
            comicUrl = "https://xkcd.com/\(comicNum)/info.0.json" // specified comic
        }
        else {
            comicUrl = "https://xkcd.com/info.0.json"  // current comic
        }
        
        guard let url = URL(string: comicUrl) else {
            completion(.failure(ComicError.urlError))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil {
                completion(.failure(ComicError.connectionError))
            }
            if let data = data {
                do {
                    let comic = try JSONDecoder().decode(XkcdComic.self, from: data)
                    
                    let retComic: Comic = Comic(xkcdComic: comic, comicImg: nil, favorite: false, explanation: nil)
                    completion(.success(retComic))
                    //print(comic.title)
                } catch let error {
                    completion(.failure(ComicError.parsingError))
                    print(error.localizedDescription)
                }
            }
            
        }.resume()
    }
}

