//
//  UyeOlVC.swift
//  epubDeneme
//
//  Created by Burak Yılmaz on 15.10.2019.
//  Copyright © 2019 Burak Yılmaz. All rights reserved.
//

import UIKit

struct Data : Codable {
let id : Int?
let ad : String?
let soyad : String?
let sifre : String?
let email : String?
let grupId : String?
let premium : String?
let kurumsalAd : String?
let token : String?
}
struct myData : Codable {
let data : Data?
let isSuccess : Bool?
let resultCode : String?
let messages : [String]?
let formMessage : String?
let exception : String?
}

class UyeOlVC: UIViewController {

    @IBOutlet weak var isimSoyisim: UITextField!
    @IBOutlet weak var mailAdresi: UITextField!
    @IBOutlet weak var parola: UITextField!
    @IBOutlet weak var parolaTekrari: UITextField!
    
    @IBAction func UyeOl(_ sender: Any) {
        let parameters = ["email": mailAdresi.text as Any, "sifre": parola.text as Any] as [String : Any]

           //create the url with URL
           let url = URL(string: "http://e-kitaplik.net/api/kullanici")! //change the url

           //create the session object
           let session = URLSession.shared

           //now create the URLRequest object using the url object
           var request = URLRequest(url: url)
           request.httpMethod = "POST" //set http method as POST

           do {
               request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
           } catch let error {
               print(error.localizedDescription)
           }

           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           request.addValue("application/json", forHTTPHeaderField: "Accept")

           //create dataTask using the session object to send data to the server
           let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

               guard error == nil else {
                   return
               }

               guard let data = data else {
                   return
               }

               do {
                   //create json object from data
                   if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                       print(json)
                       // handle json...
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(myData.self, from: data)
                    if(gitData.isSuccess! == true){
                      DispatchQueue.main.async(){
                           self.performSegue(withIdentifier: "uyeOldun", sender: self)
                        }
                    }
                   }
               } catch let error {
                   print(error.localizedDescription)
               }
           })
           task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      

    }
    
}
