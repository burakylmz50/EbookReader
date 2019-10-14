//
//  DataParse.swift
//  epubDeneme
//
//  Created by Burak Yılmaz on 10.10.2019.
//  Copyright © 2019 Burak Yılmaz. All rights reserved.
//

import Foundation

struct Data2: Decodable {
    let id:Int?
    let ad:String?
    let aciklama:String?
    let isbn:String?
    let kategoriId:Int?
    let resim1:String?
    let resim2:String?
    let resim3:String?
    let resim4:String?
    let resim5:String?
    let yazarId:Int?
    let sayfaSayisi:Int?
    let epub:String
}

struct JsonResponse: Decodable {
    let data: [Data2]
}

var dizi : [String] = []
    public func bookAddress(){
          URLSession.shared.dataTask(with: URL(string: "http://e-kitaplik.net/api/kitap?page=0&pagesize=150")!) { (data, res, err) in
            if let _ = err{
                return
            }
            if let data = data {
                    do {
                        let res = try JSONDecoder().decode(JsonResponse.self, from: data)
                        
                        res.data.forEach({
                            dizi.append($0.epub)
                            print($0.epub)
                        })
                        print(dizi[20])
                    } catch let error {
                        print(error)
                    }
                }
            }
    }

 


