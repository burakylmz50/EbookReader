//
//  SifremiUnuttumVC.swift
//  epubDeneme
//
//  Created by Burak Yılmaz on 27.10.2019.
//  Copyright © 2019 Burak Yılmaz. All rights reserved.
//

import UIKit

struct Response : Codable {
    let isSuccess : Bool?
    let resultCode : String?
    let exception : String?
    let messages : [String]?
    let data : String?
}
class SifremiUnuttumVC: UIViewController {
    @IBOutlet weak var gonderBttn: UIButton!
    @IBAction func closeBttn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var epostaAdresi: UITextField!
    @IBAction func gonderBttn(_ sender: Any) {
        print("burak")
        sifremiUnuttum()
    }
    
    
    override func viewDidLoad() {
        epostaAdresi.layer.cornerRadius = 20
        gonderBttn.layer.cornerRadius = 20
        super.viewDidLoad()
        
    }
    func ekraniKapat(){
        self.dismiss(animated: true, completion: nil)
    }
    func sifremiUnuttum(){
        //textfield içine boşluk bırakılırsa boşlukları siliyor.
        let unutulanSifre = String(epostaAdresi.text!.filter {![" ", "\t", "\n"].contains($0)})
        if let url = URL(string: "http://e-kitaplik.net/ForgotPassword?email=" + unutulanSifre ) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(Response.self, from: data)
                        if(res.isSuccess == true){
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Başarılı", message: "Şifreniz e-posta ile gönderildi.", preferredStyle: .alert)
                                let okButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
                                alert.addAction(okButton)
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                        }
                        else{
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Sorun", message: "Yanlış veya eksik bir e-posta girdiniz.", preferredStyle: .alert)
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
    }
    
}
