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

class UyeOlVC: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var isimSoyisim: UITextField!
    @IBOutlet weak var mailAdresi: UITextField!
    @IBOutlet weak var parola: UITextField!
    @IBOutlet weak var parolaTekrari: UITextField!
    @IBOutlet weak var uyeOl: UIButton!
    
    @IBAction func UyeOl(_ sender: Any) {
        self.showSpinner(onView: self.view)
        if(isimSoyisim.text!.count < 4){
            self.removeSpinner()
            let alert = UIAlertController(title: "Uyarı", message: "İsim soyisim alanı boş bırakılmamalıdır.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        else if(mailAdresi.text!.count < 1){
             self.removeSpinner()
            let alert = UIAlertController(title: "Uyarı", message: "Mail adresi giriniz.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
            
        else if(mailAdresi.text!.count > 1){
            let isEmailAddressValid =  isValidEmail(testStr: mailAdresi.text!)
            if ( !isEmailAddressValid ){
                 self.removeSpinner()
                let alert = UIAlertController(title: "Mail Adresi", message: "Else Geçersiniz mail", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                if(parola.text!.count < 6){
                     self.removeSpinner()
                    let alert = UIAlertController(title: "Parola", message: "Parola en az 6 karakter içermelidir.", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
                    
                else if(parola.text != parolaTekrari.text){
                     self.removeSpinner()
                    let alert = UIAlertController(title: "Parola", message: "Parolalar uyuşmamaktadır.", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
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
                                         self.removeSpinner()
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
            }
        }
        
    }
    
    
    //Email adresinin uyumlu olup olmadığını denetleyen fonksiyon
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isimSoyisim.delegate = self
        mailAdresi.delegate = self
        parola.delegate = self
        parolaTekrari.delegate = self
        
        isimSoyisim.layer.cornerRadius = 15
        mailAdresi.layer.cornerRadius = 15
        parola.layer.cornerRadius = 15
        parolaTekrari.layer.cornerRadius = 15
        uyeOl.layer.cornerRadius = 15
        
        isimSoyisim.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        mailAdresi.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        parola.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        parolaTekrari.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        uyeOl.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 10)
        
        
        
    }
    
}
