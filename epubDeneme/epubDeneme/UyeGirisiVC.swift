//
//  UyeGirisiVC.swift
//  epubDeneme
//
//  Created by Burak Yılmaz on 14.10.2019.
//  Copyright © 2019 Burak Yılmaz. All rights reserved.
//

import UIKit

class UyeGirisiVC: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var epostaAdresi: UITextField!
    @IBOutlet weak var parola: UITextField!
    @IBOutlet weak var oturumAc: UIButton!
    
    @IBAction func oturumAc(_ sender: AnyObject) {
        
        if(epostaAdresi.text!.count < 1){
            let alert = UIAlertController(title: "Uyarı", message: "Mail adresi giriniz.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        else if(epostaAdresi.text!.count > 1){
            let isEmailAddressValid =  isValidEmail(testStr: epostaAdresi.text!)
            if ( !isEmailAddressValid ){
                let alert = UIAlertController(title: "Mail Adresi", message: "Else Geçersiniz mail", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
                
            else if (parola.text!.count < 1){
                let alert = UIAlertController(title: "Uyarı", message: "Lütfen parolayı giriniz", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        let parameters = ["email": epostaAdresi.text as Any, "sifre": parola.text as Any] as [String : Any]
        
        //create the url with URL
        let url = URL(string: "http://e-kitaplik.net/api/kullanici/gettoken")! //change the url
        
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
                            self.performSegue(withIdentifier: "girisYaptin", sender: self)
                        }
                    }
                    else{
                        DispatchQueue.main.async(){
                            let alert = UIAlertController(title: "Uyarı", message: gitData.formMessage, preferredStyle: .alert)
                            let okButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    //Email adresinin uyumlu olup olmadığını denetleyen fonksiyon
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        epostaAdresi.delegate = self
        parola.delegate = self
        
        parola.layer.cornerRadius = 15
        parola.layer.borderColor = UIColor.lightGray.cgColor
        parola.layer.borderWidth = 1.0
        
        epostaAdresi.layer.cornerRadius = 15
        epostaAdresi.layer.borderColor = UIColor.lightGray.cgColor
        epostaAdresi.layer.borderWidth = 1.0
        
        oturumAc.layer.cornerRadius = 15
        
        let emailImage = UIImage(named: "mail")
        addLeftImage(txtField: epostaAdresi, andImage: emailImage!)
        
        let passwordImage = UIImage(named : "password")
        addLeftImage(txtField: parola, andImage: passwordImage!)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Textfield'ların başına şifre ve mail iconları eklemek için
    func addLeftImage(txtField:UITextField , andImage img : UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    }
}
