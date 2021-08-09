//
//  DetailViewController.swift
//  libraryProject
//
//  Created by Buse Şentürk on 31.07.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var backToSearchPageButton: UIBarButtonItem!
    @IBAction func backToSearchPageButton(_ sender: Any) {
        performSegue(withIdentifier: "BackToSearchPage", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "BackToSearchPage" {
              let vc : SearchableViewController = segue.destination as! SearchableViewController
              vc.favBookArray = favBookArray
              vc.modalPresentationStyle = .fullScreen

              present(vc, animated: true)

          }

      }
    @IBOutlet weak var bookPoster: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookArtistName: UILabel!
    @IBOutlet weak var likedButton: UIBarButtonItem!
    @IBOutlet weak var bookReleaseDate: UILabel!
    @IBAction func likedButton(_ sender: Any) {
        if favBookArray.contains(book) {
            favBookArray.remove(book)
            likedButton.image = UIImage(systemName: "star")

    } else {

        favBookArray.insert(book)
        likedButton.image = UIImage(systemName: "star.fill")
        likedButton.tintColor = .systemYellow


    }

}
    var image = UIImage()
    var name = ""
    var authorName = ""
    var date = ""
    var favBookArray = Set<Book>()
    var book : Book!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hey")

         bookName.text = name
         bookArtistName.text = authorName
         bookReleaseDate.text = convertDateFormater(date)
         bookPoster.image = image

        
           if favBookArray.contains(book) {
              likedButton.image = UIImage(systemName: "star.fill")
              likedButton.tintColor = .systemYellow


          }else {
              likedButton.image = UIImage(systemName: "star")
              
          }

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
     
}
