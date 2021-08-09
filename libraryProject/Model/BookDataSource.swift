//
//  BookDataSource.swift
//  libraryProject
//
//  Created by Buse Şentürk on 26.07.2021.
//

import Foundation

protocol BookDataSourceDelegate {
    func BookListLoaded(bookList: [Book])
}

class BookDataSource {

    var delegate : BookDataSourceDelegate?
    let baseURL = "https://rss.itunes.apple.com/api/v1/us/books/top-free/all/100/non-explicit.json"
    var pageInterval:Int=20
    func loadListOfBooks(currentPage : Int){
        var bookList : [Book] = []
        let session = URLSession.shared
        
        if let url = URL(string: baseURL){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = session.dataTask(with: request){
                (data, response, error) in
                let decoder = JSONDecoder()
                let feed = try! decoder.decode(Feed.self, from: data!)
                let page:Int=currentPage-1
                print("içerde")
                print(feed.feed.results.count)
                if page*self.pageInterval<feed.feed.results.count{
                    for index in page*self.pageInterval...min(currentPage*self.pageInterval,feed.feed.results.count)-1{
                        bookList.append(feed.feed.results[index])
                    }
                }

                /*for item in feed.feed.results{
                    
                    bookList.append(item)
                }*/
                
                DispatchQueue.main.async {
                    self.delegate?.BookListLoaded(bookList: bookList)
                }
            }
            dataTask.resume()
        }
    }
}

