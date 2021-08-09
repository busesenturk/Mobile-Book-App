//
//  SearchableViewController.swift
//  libraryProject
//
//  Created by Buse Şentürk on 28.07.2021.
//

import UIKit
private let reuseIdentifier = "Cell"

class SearchableViewController: UIViewController, BookDataSourceDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func BookListLoaded(bookList: [Book]) {
        self.bookArray = bookList
        self.filteredData = bookList
        self.searchTableView.reloadData()
    }
    
    var favBookArray = Set<Book>()
    let bookDataSource = BookDataSource()
    var bookArray : [Book] = []
    var filteredData: [Book]!
    var selectedIndex = Int()
    
    @IBOutlet weak var backToHomeScreen: UIButton!
    @IBAction func backToHomeScreen(_ sender: Any) {
        performSegue(withIdentifier: "backToHomeScreen", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "backToHomeScreen" {
                let vc : HomeViewController = segue.destination as! HomeViewController
                vc.favBookArray = favBookArray
                vc.modalPresentationStyle = .fullScreen

                present(vc, animated: true)

            }
            if segue.identifier == "DetailScreen" {
                let vc = segue.destination as! DetailViewController
                vc.name = filteredData[selectedIndex].name
                vc.authorName = filteredData[selectedIndex].artistName
                vc.date = filteredData[selectedIndex].releaseDate
                vc.image = HomeViewController().getPosters(book: filteredData[selectedIndex])
                vc.book = filteredData[selectedIndex]
                vc.favBookArray = favBookArray
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filteredData = bookArray

        searchBar.delegate = self
        searchTableView.dataSource = self
        searchTableView.delegate = self
        bookDataSource.delegate = self
        bookDataSource.loadListOfBooks(currentPage:1)
        
        searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
      
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchTableViewCell
        
        let  book = filteredData[indexPath.row]
        let  bookPoster = getPosters(book: book)
        cell.bookName?.text = book.name
        cell.bookArtistName?.text = book.artistName
        cell.bookReleaseDate?.text = convertDateFormater(book.releaseDate)
        cell.bookPoster?.image = bookPoster
        return cell

    }
    
    // MARK: - To reach the book detail page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {     
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: "DetailScreen", sender: self)
    }
    
    
    // MARK: - Get images from api
    func getPosters(book: Book) -> UIImage {
        var image : UIImage!
        if let posterURL = URL(string: book.artworkUrl100) {
            do {
                let data = try Data(contentsOf: posterURL)
                image = UIImage(data: data) ?? UIImage()
            }   catch {}
        }
            return image
            
            }
    // MARK: - Convert date format
    func convertDateFormater(_ date: String?) -> String {
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let originalDate = date {
            if let newDate = dateFormatter.date(from: originalDate) {
                dateFormatter.dateFormat = "dd.MM.yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }
    
    // MARK: - Search Bar Config
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
      filteredData = []
        
        if searchText == "" {
            filteredData = bookArray
        }
        else{
        for book in bookArray {
     
            if book.name.lowercased().contains(searchText.lowercased()){
                filteredData.append(book)
                }
            }
        }
        self.searchTableView.reloadData()
    }
    
}


