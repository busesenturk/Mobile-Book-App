//
//  HomeCollectionViewCell.swift
//  libraryProject
//
//  Created by Buse Şentürk on 26.07.2021.
//

import UIKit
protocol FavBookDelegate {
    func bookFaved(book: Book)
    func bookUnfaved(book:Book)
}
class HomeCollectionViewCell: UICollectionViewCell {
    var book : Book!
    var delegate : FavBookDelegate?

    @IBOutlet weak var likedButton: UIButton!
    @IBAction func likedButton(_ sender: UIButton) {
        if let tmp=self.book {
            if !likedButton.isSelected{
                print("fav")
                DispatchQueue.main.async {
                    self.delegate?.bookFaved(book: tmp)
                }
            } else {
                print("unfav")
                DispatchQueue.main.async {
                    self.delegate?.bookUnfaved(book: tmp)
                }
            }
        }
          likedButton.isSelected = !likedButton.isSelected
          likedButton.tintColor = .systemYellow

          likedButton.setImage(UIImage(systemName: "star.fill"), for: .selected)

    }
    @IBOutlet weak var bookPoster: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    
}
