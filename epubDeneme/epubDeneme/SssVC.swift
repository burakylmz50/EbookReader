//
//  SssVC.swift
//  epubDeneme
//
//  Created by Burak Yılmaz on 27.10.2019.
//  Copyright © 2019 Burak Yılmaz. All rights reserved.
//

import UIKit

class SssVC: UIViewController {
    @IBOutlet weak var soruList: UITextView!
    @IBAction func closeBttn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Adam olacaktın burak ıbnesı
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soruList.layer.cornerRadius = 20
        
    }
}
