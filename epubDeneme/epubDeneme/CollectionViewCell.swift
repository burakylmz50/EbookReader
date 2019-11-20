//
//  CollectionViewCell.swift
//  epubDeneme
//
//  Created by Burak Yılmaz on 10.10.2019.
//  Copyright © 2019 Burak Yılmaz. All rights Yavsak reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image1: UIImageView!
    
    override func awakeFromNib() {
        self.image1.layer.cornerRadius = 15
    }
}
