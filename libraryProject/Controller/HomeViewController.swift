//
//  ViewController.swift
//  libraryProject
//
//  Created by Buse Şentürk on 15.07.2021.
//

import UIKit
private let reuseIdentifier = "Cell"
class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, BookDataSourceDelegate,FavBookDelegate{
    func bookFaved(book: Book) {
        favBookArray.insert(book)
    }
    
    func bookUnfaved(book: Book) {
        favBookArray.remove(book)
    }
   
    func BookListLoaded(bookList: [Book]) {
        self.bookArray.append(contentsOf: bookList)
        self.bookArrayTmp.append(contentsOf: bookList)
        self.homeCollectionView.reloadData()
    }
    
    @IBAction func sortbutton(_ sender: Any) {
           // 1
           let optionMenu = UIAlertController(title: nil, message: "Sort by Release Date", preferredStyle: .actionSheet)
               
           // 2
          optionMenu.addAction(UIAlertAction(title: "All of books", style: .default, handler: self.allOfBookHandler))
                               
          optionMenu.addAction(UIAlertAction(title: "Newest to oldest", style: .default, handler: self.newToOldHandler))
          
          optionMenu.addAction(UIAlertAction(title: "Oldest to newest", style: .default, handler: self.oldToNewHandler))
          
          optionMenu.addAction(UIAlertAction(title: "Only favorites", style: .default, handler: self.FavoriteHandler))
        
          optionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
           // 3
           self.present(optionMenu, animated: true, completion: nil)
       }
    
    func allOfBookHandler(alert:UIAlertAction!) {
        bookArray=bookArrayTmp
        homeCollectionView.reloadData()
    }
    func newToOldHandler(alert:UIAlertAction!) {
        bookArray=bookArrayTmp
        bookArray.sort(by: sorterForReleaseDateNewToOld(this:that:))
        homeCollectionView.reloadData()
    }
    func oldToNewHandler(alert:UIAlertAction!) {
        bookArray=bookArrayTmp
        bookArray.sort(by: sorterForReleaseDateOldToNew(this:that:))
        homeCollectionView.reloadData()
    }
    func FavoriteHandler(alert:UIAlertAction!) {
        bookArray = Array(favBookArray)
        homeCollectionView.reloadData()
    }
    
    func sorterForReleaseDateNewToOld(this:Book, that:Book) -> Bool {
        return this.releaseDate > that.releaseDate
    }
    
    func sorterForReleaseDateOldToNew(this:Book, that:Book) -> Bool {
        return this.releaseDate < that.releaseDate
    }
    
    @IBOutlet weak var searchbutton: UIBarButtonItem!
    @IBAction func searchbutton(_ sender: Any) {
        performSegue(withIdentifier: "SearchScreen", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

          if segue.identifier == "SearchScreen" {

              let vc = segue.destination as! SearchableViewController
              vc.favBookArray = favBookArray
              vc.modalPresentationStyle = .fullScreen
              present(vc, animated: true)

          }

    }
    
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
   
    let bookDataSource = BookDataSource()
    var bookArray : [Book] = []
    var bookArrayTmp : [Book] = []
    var favBookArray = Set<Book>()
    var currentPage: Int=1
    var raceCond: Bool=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        bookDataSource.delegate = self
        bookDataSource.loadListOfBooks(currentPage:1)
        homeCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        homeCollectionView.collectionViewLayout = ColumnFlowLayout(sutunSayisi: 2, minSutunAraligi: 10, minSatirAraligi: 20)
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        cell.delegate=self
        let  book = bookArray[indexPath.row]
        let  bookPoster = getPosters(book: book)
        cell.bookName?.text = book.name
        cell.bookPoster?.image = bookPoster
        cell.book=book
        if favBookArray.contains(book) {
            cell.likedButton?.isSelected=true
            cell.likedButton.tintColor = .systemYellow

        }else{
            cell.likedButton?.isSelected=false
        }
        cell.likedButton?.setImage(UIImage(systemName: "star.fill"), for: .selected)

        return cell
    }
    // MARK: - Create pagination with collectionView
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       // raceCond=(!raceCond)
        if raceCond {
            let endScrolling = (scrollView.contentOffset.y + scrollView.frame.size.height)
            
            if endScrolling >= scrollView.contentSize.height {
                currentPage+=1
                bookDataSource.loadListOfBooks(currentPage: currentPage)
                
                //Manage Pagination
                //from_Post = from_Data + Page_Number; //Like 10, 20 as you define
                //to_Post = to_Data + Page_Number; //Like 10, 20 as you define

                //Called Function for You Performing action
                //[self GetDataFrom:from_Post To:to_Post];
            }
        }
        raceCond=(!raceCond)

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
    }

    



    
