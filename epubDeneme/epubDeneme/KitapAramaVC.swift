//
//  KitapAramaVC.swift
//  epubDeneme
//
//  Created by Burak Yılmaz on 15.10.2019.
//  Copyright © 2019 Burak Yılmaz. All rights reserved.
//

import UIKit
import FolioReaderKit

struct Data3 : Codable {
    let id : Int?
    let ad : String?
    let aciklama : String?
    let isbn : String?
    let kategoriId : Int?
    let yazarId : Int?
    let sayfaSayisi : String?
    let epub : String?
    let pdf : String?
    let kategoriAdi : String?
    let yazarAdi : String?
    let path : String?
}
struct searchBarJson : Codable {
    let isSuccess : Bool?
    let resultCode : String?
    let exception : String?
    // let messages : String?
    let data : [Data3]?
}

class KitapAramaVC: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource , UITextFieldDelegate{
    
    @IBOutlet weak var arananKelime: UITextField!
    @IBOutlet weak var cViewSearch: UICollectionView!
    
    //textfield içine her karakter girildiğinde arama yapmak. *EditingChanged*
    @IBAction func arananKelime(_ sender: Any) {
        if(arananKelime.text!.count > 2){
            arama(aranacakKelime: arananKelime.text!)
        }
    }
    
    
    let kitapApi : String = "http://e-kitaplik.net/api/kitap/epub/"
    var data1 = [Data3]()
    let folioReader = FolioReader()
    
    //Search Bar sayfasına girildiği zaman klavyenin otomatik olarak açılması.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arananKelime.becomeFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        arananKelime.delegate = self
        self.hidesKeyboard()
        configureTapGesture()
        arananKelime.clearButtonMode = .always
        arananKelime.clearButtonMode = .whileEditing
        
        let emailImage = UIImage(named: "search")
        
        addLeftImage(txtField: arananKelime, andImage: emailImage!)
    }
    
    //Textfield'ların başına şifre ve mail iconları eklemek için
    func addLeftImage(txtField:UITextField , andImage img : UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    }
    
    //Text field klavye açıkken boşluğa tıklanınca klavyenin kapanması.
    private func configureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(KitapAramaVC.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap(){
        view.endEditing(true)
    }
    func kitapArama(){
        arama(aranacakKelime: arananKelime.text!)
    }
    func arama(aranacakKelime : String){
        //textfield içine girilen boşlukları siliyor.
        let aranacakKelime2 = String(arananKelime.text!.filter {![" ", "\t", "\n"].contains($0)})
        URLSession.shared.dataTask(with: URL(string: "http://e-kitaplik.net/api/kitap/search?keyword=" + aranacakKelime2)!) { (data, res, err) in
            if let _ = err {
                return
            }
            if let data = data {
                do {
                    let res = try JSONDecoder().decode(searchBarJson.self, from: data)
                    if(res.isSuccess == true){
                        self.data1 = res.data!
                        
                        DispatchQueue.main.async {
                            self.cViewSearch.reloadData()
                        }
                    }
                    else{
                        DispatchQueue.main.async(){
                            let alert = UIAlertController(title: "Uyarı", message: "Aradığınız kitap/yazar bulunamadı.", preferredStyle: .alert)
                            let okButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                    
                } catch let error {
                    print(error)
                }
            }
        }.resume()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data1.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cViewSearch.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
        
        
        //path : Resmin url'si
        let url = URL(string: data1[indexPath.row].path!)
        URLSession.shared.dataTask(with: url!){
            (data,response,error) in
            if error != nil{
                print("error")
                return
            }
            DispatchQueue.main.async {
                cell.searchImage.image = UIImage(data : data!)
            }
        }.resume()
        
        
        return cell
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        doubleTapped(abc: (data1[indexPath.row].id!))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        kitapArama()
        return true
    }
    
    
}

//Boşluğa tıklayınca klavye kapanması.
extension UIViewController{
    func hidesKeyboard(){
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dissmissKeyboard(){
        view.endEditing(true)
    }
}
