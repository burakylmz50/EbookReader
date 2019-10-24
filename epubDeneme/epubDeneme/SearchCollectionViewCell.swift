//
//  SearchCollectionViewCell.swift
//  epubDeneme
//
//  Created by Burak Yılmaz on 23.10.2019.
//  Copyright © 2019 Burak Yılmaz. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var searchImage: UIImageView!
    
    override func awakeFromNib() {
        self.searchImage.layer.cornerRadius = 50
    }

}
