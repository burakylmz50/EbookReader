//
//  ViewController.swift
//  epubDeneme
//
//  Created by Burak Yılmaz on 10.10.2019.
//  Copyright © 2019 Burak Yılmaz. All rights reserved.
//

import UIKit
import FolioReaderKit

class ViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var cView: UICollectionView!
    @IBOutlet weak var cView2: UICollectionView!
    @IBOutlet weak var cView3: UICollectionView!
    
        var burak = ["https://cdn.pastemagazine.com/www/system/images/photo_albums/best-book-covers-2019-so-far/large/bbc19holdstill.png?1384968217","https://www.booktopia.com.au/blog/wp-content/uploads/2018/12/the-arsonist.jpg","https://s26162.pcdn.co/wp-content/uploads/2019/01/9781616208882.jpg","https://cdn.pastemagazine.com/www/system/images/photo_albums/best-book-covers-2019-so-far/large/bbc19holdstill.png?1384968217","https://s26162.pcdn.co/wp-content/uploads/2019/01/9781616208882.jpg","https://cdn.pastemagazine.com/www/system/images/photo_albums/best-book-covers-2019-so-far/large/bbc19holdstill.png?1384968217","https://s26162.pcdn.co/wp-content/uploads/2019/01/9781616208882.jpg","https://cdn.pastemagazine.com/www/system/images/photo_albums/best-book-covers-2019-so-far/large/bbc19holdstill.png?1384968217"]
        override func viewDidLoad() {
            
            super.viewDidLoad()

        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            if (collectionView == cView2){
                return burak.count
            }
            if (collectionView == cView3){
                return burak.count
            }
            return burak.count
        }
        @objc func doubleTapped(_ sender: AnyObject) {
                   if let url = URL(string: "https://www.hackingwithswift.com") {
                       UIApplication.shared.open(url)
                   }
               }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let tap =  UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_:)))
            cView.addGestureRecognizer(tap)
           
            
            let cell = cView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            cell.backgroundColor = UIColor.white
            
            //  cell.img.image = UIImage(named: burak[indexPath.row])
            //URL Üzerinden image açmak.
            do {
                let url = URL(string: burak[indexPath.row])
                let data = try Data(contentsOf: url!)
                cell.image1.image = UIImage(data: data)
            }
            catch{
                print("URL'den resim get edilemedi")
            }
            
            if (collectionView == cView2){
                let cell2 = cView2.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CollectionViewCell2
                cell2.backgroundColor = UIColor.white
                do {
                    let url = URL(string: burak[indexPath.row])
                    let data = try Data(contentsOf: url!)
                    cell2.image2.image = UIImage(data: data)
                }
                catch{
                    print("URL'den resim get edilemedi")
                }
                return cell2
            }
            
            if (collectionView == cView3){
                let cell3 = cView3.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! CollectionViewCell3
                cell3.backgroundColor = UIColor.white
                do {
                    let url = URL(string: burak[indexPath.row])
                    let data = try Data(contentsOf: url!)
                    cell3.image3.image = UIImage(data: data)
                }
                catch{
                    print("URL'den resim get edilemedi")
                }
                return cell3
                
            }
            
            return cell
        }
        
    }
