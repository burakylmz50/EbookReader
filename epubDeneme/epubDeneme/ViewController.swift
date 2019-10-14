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
    let folioReader = FolioReader()
    
    var burak : [String] = ["https://cdn.pastemagazine.com/www/system/images/photo_albums/best-book-covers-2019-so-far/large/bbc19holdstill.png?1384968217","https://www.booktopia.com.au/blog/wp-content/uploads/2018/12/the-arsonist.jpg","https://s26162.pcdn.co/wp-content/uploads/2019/01/9781616208882.jpg","https://cdn.pastemagazine.com/www/system/images/photo_albums/best-book-covers-2019-so-far/large/bbc19holdstill.png?1384968217","https://s26162.pcdn.co/wp-content/uploads/2019/01/9781616208882.jpg","https://cdn.pastemagazine.com/www/system/images/photo_albums/best-book-covers-2019-so-far/large/bbc19holdstill.png?1384968217","https://s26162.pcdn.co/wp-content/uploads/2019/01/9781616208882.jpg","https://cdn.pastemagazine.com/www/system/images/photo_albums/best-book-covers-2019-so-far/large/bbc19holdstill.png?1384968217"]
    
    let kitapApi : String = "http://e-kitaplik.net/api/kitap/epub/"
    let kitapResim : String = "http://e-kitaplik.net/api/kitap/cover/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //    Her bir collection View içinde kaçar tane veri olduğunu belirtiyor.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == cView2){
            return burak.count
        }
        if (collectionView == cView3){
            return burak.count
        }
        return burak.count
    }
    func showSavedEpub( fileName:String) {
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains(fileName) {
                        // its your file! do what you want with it!
                        self.open(bookPath: url.path)
                        break
                    }
                }
            } catch {
                print("could not locate epub file !!!!!!!")
            }
        }
    }
    func open(bookPath:String) {
        let config = FolioReaderConfig()
        config.shouldHideNavigationOnTap = true
        config.scrollDirection = .horizontal
        let folioReader = FolioReader()
        folioReader.presentReader(parentViewController: self, withEpubPath: bookPath, andConfig: config)
    }
    
    
    //    Download
    func doubleTapped(abc : Int) {
        
        let abcd = String(abc) // indexPath.item ' ı kitapApi'sinin sonuna ekliyorum. URL olarak veriyorum.
        if let fileUrl = URL(string: kitapApi + abcd) {
            
            //    self.indicatorView?.startAnimating()
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileUrl.lastPathComponent+".epub")
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                //       self.indicatorView?.stopAnimating()
                print("The file already exists at path")
                // if the file doesn't exist
                DispatchQueue.main.async {
                    self.showSavedEpub(fileName:destinationUrl.lastPathComponent)
                }
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: fileUrl) { location, response, error in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("DOWNLOAD COMPLETED: File moved to documents folder")
                        
                        DispatchQueue.main.async {
                            //              self.indicatorView?.stopAnimating()
                            self.showSavedEpub(fileName:destinationUrl.lastPathComponent)
                        }
                        
                    } catch {
                        print(error)
                    }
                }.resume()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor.white
        
        //URL Üzerinden image açmak.
        let abcd = String((indexPath.row*2) + 1)  // Veriler 1-3-5.. diye gittiği için böyle yapıyorum.
        let url = URL(string: kitapResim + abcd)
        URLSession.shared.dataTask(with: url!){
            (data,response,error) in
            if error != nil{
                print("error")
                return
            }
            DispatchQueue.main.async {
                cell.image1.image = UIImage(data : data!)
            }
        }.resume()
        
        if (collectionView == cView2){
            let cell2 = cView2.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CollectionViewCell2
            cell2.backgroundColor = UIColor.white
            
            //URL Üzerinden image açmak.
            let abcd = String((indexPath.row*2) + 1)  // Veriler 1-3-5.. diye gittiği için böyle yapıyorum.
            let url = URL(string: kitapResim + abcd)
            URLSession.shared.dataTask(with: url!){
                (data,response,error) in
                if error != nil{
                    print("error")
                    return
                }
                DispatchQueue.main.async {
                    cell2.image2.image = UIImage(data : data!)
                }
            }.resume()
            return cell2
        }
        
        if (collectionView == cView3){
            let cell3 = cView3.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! CollectionViewCell3
            cell3.backgroundColor = UIColor.white
            
            //URL Üzerinden image açmak.
            let abcd = String((indexPath.row*2) + 1)  // Veriler 1-3-5.. diye gittiği için böyle yapıyorum.
            let url = URL(string: kitapResim + abcd)
            URLSession.shared.dataTask(with: url!){
                (data,response,error) in
                if error != nil{
                    print("error")
                    return
                }
                DispatchQueue.main.async {
                    cell3.image3.image = UIImage(data : data!)
                }
            }.resume()
            return cell3
            
        }
        
        return cell
    }
    
    //    Seçili hücreye tıklandığında olacaklar.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == cView){
            if (indexPath.item == 0){  //Veriler 0'dan başlamıyor ama indexPath.item 0'dan başlıyor.
                doubleTapped(abc: indexPath.item + 1)
            }
            else{
                doubleTapped(abc: (indexPath.item*2)+1)
            }
        }
        
        if (collectionView == cView2){
            if (indexPath.item == 0){  //Veriler 0'dan başlamıyor ama indexPath.item 0'dan başlıyor.
                doubleTapped(abc: indexPath.item + 1)
            }
            else{
                doubleTapped(abc: (indexPath.item*2)+1)
            }
            
            
        }
        
        if (collectionView == cView3){
            if (indexPath.item == 0){  //Veriler 0'dan başlamıyor ama indexPath.item 0'dan başlıyor.
                doubleTapped(abc: indexPath.item + 1)
            }
            else{
                doubleTapped(abc: (indexPath.item*2)+1)
            }
        }
    }
    
}
