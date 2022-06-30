//
//  ComicService.swift
//  xkcd Native
//
//  Created by Alf Jørgen Bråtane on 27/06/2022.
//

import Foundation
import SwiftSoup

private actor ComicServiceStore {
    private var nextComic = XkcdComic()
    private var comicUrl: URL {
        comicUrlComponents.url!
    }

    private var _comicNum: String = ""
    private var comicNum: String {
        get{
            return _comicNum.count > 0 ? "/\(_comicNum)" : ""
        }
        set {
            self._comicNum = newValue
        }
    }
    private var comicUrlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "xkcd.com"
        components.path = "\(comicNum)/info.0.json"
        return components
    }

    func load(comicNo: Int?) async throws -> XkcdComic {
        if let comicNo = comicNo {
            comicNum = String(comicNo)
        }
        else {
            comicNum = ""
        }
        
        let (data, response) = try await URLSession.shared.data(from: comicUrl)
        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw ComicError.connectionError
        }
        guard let decodedResponse = try? JSONDecoder().decode(XkcdComic.self, from: data)
        else { throw ComicError.parsingError }
        nextComic = decodedResponse
        
        return nextComic
      }
}

class ComicService: ObservableObject {
    @Published private(set) var comics = [XkcdComic]()
    @Published private(set) var isFetching = false
    private let store = ComicServiceStore()
    private var lastComic: Int?
    private var fetchedComic: XkcdComic?

    public init() { }
}

extension ComicService {
    @MainActor
    func fetchComics() async throws {
        isFetching = true
        defer { isFetching = false }
        
        
        if lastComic == nil {
            fetchedComic = try await store.load(comicNo: nil)
            comics.append(fetchedComic!)
            
        }
        lastComic = comics[comics.count - 1].num
        for i in stride(from: lastComic! - 1, to: max(lastComic! - 20,1), by: -1) {
            fetchedComic = try await store.load(comicNo: i)
            comics.append(fetchedComic!)
        }
        lastComic = comics[comics.count - 1].num
        
    }
}

extension ComicService {
    static func explain(comic: Int) -> String {
        var explanation: String = ""
        let urlBase = "https://www.explainxkcd.com/wiki/index.php/\(comic)"
        do {
            let html = try! String(contentsOf: URL(string: urlBase)!, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html)
            let output: Element = try doc.getElementsByClass("mw-parser-output").first()!
            for node in output.children() {
                let h2 = try node.getElementsByTag("h2")
                let h2String = try h2.html()
                let h2Doc: Document = try SwiftSoup.parse(h2String)
                let h2Content = try h2Doc.text()
                if h2Content == "Transcript[edit]" {
                    break
                }
                
                let pTag = try node.getElementsByTag("p")
                let htmlString = try pTag.html()
                let doc: Document = try SwiftSoup.parse(htmlString)
                let content = try doc.text()
                explanation += "<p>\(content)</p>"
            }
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
        return explanation
    }
}

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
                return NSLocalizedString("Something went wrong. Please check your connection", comment: "Error connecting to service")
            case .parsingError:
                return NSLocalizedString("An error occured while parsing data", comment: "Parsing error")
        }
    }
}
