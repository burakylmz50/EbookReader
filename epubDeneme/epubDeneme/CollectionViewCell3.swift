//
//  CollectionViewCell3.swift
//  epubDeneme
//
//  Created by Burak Yılmaz on 10.10.2019.
//  Copyright © 2019 Burak Yılmaz. All rights reserved.
//

import UIKit

class CollectionViewCell3: UICollectionViewCell {
    @IBOutlet weak var image3: UIImageView!
    
    override func awakeFromNib() {
        self.image3.layer.cornerRadius = 15
    }
    
}
