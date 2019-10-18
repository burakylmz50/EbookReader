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
