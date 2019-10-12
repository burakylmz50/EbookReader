//
//  CollectionViewCell2.swift
//  epubDeneme
//
//  Created by Burak Yılmaz on 10.10.2019.
//  Copyright © 2019 Burak Yılmaz. All rights reserved.
//

import UIKit

class CollectionViewCell2: UICollectionViewCell {
    @IBOutlet weak var image2: UIImageView!
    
    override func awakeFromNib() {
        self.image2.layer.cornerRadius = 20
    }
}
