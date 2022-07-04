//
//  AcuantObj.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/12/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class AcuantObj: NSObject, NSCoding {
    public var data:[String]? = nil
    public var frontImageUrl : String? = nil
    public var backImageUrl : String? = nil
    public var faceImageUrl : String? = nil
    public var signImageUrl : String? = nil
       
    public var front : UIImage? = nil
    public var back : UIImage? = nil
       
    public var username : String? = nil
    public var password : String? = nil
    override init() {
    }
    required init?(coder decoder: NSCoder) {
        
        self.data = decoder.decodeObject(forKey: "data") as? [String]
        self.frontImageUrl = decoder.decodeObject(forKey: "frontImageUrl") as? String
        self.backImageUrl = decoder.decodeObject(forKey: "backImageUrl") as? String
        self.faceImageUrl = decoder.decodeObject(forKey: "faceImageUrl") as? String
        self.signImageUrl = decoder.decodeObject(forKey: "signImageUrl") as? String
        self.front = decoder.decodeObject(forKey: "front") as? UIImage
        self.back = decoder.decodeObject(forKey: "back") as? UIImage
        self.username = decoder.decodeObject(forKey: "username") as? String
        self.frontImageUrl = decoder.decodeObject(forKey: "frontImageUrl") as? String
        self.password = decoder.decodeObject(forKey: "password") as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.data, forKey: "data")
        coder.encode(self.frontImageUrl, forKey: "frontImageUrl")
        coder.encode(self.backImageUrl, forKey: "backImageUrl")
        coder.encode(self.faceImageUrl, forKey: "faceImageUrl")
        coder.encode(self.signImageUrl, forKey: "signImageUrl")
        coder.encode(self.front, forKey: "front")
        coder.encode(self.back, forKey: "back")
        coder.encode(self.username, forKey: "username")
        coder.encode(self.password, forKey: "password")
    }
}

class  MyTrandObj {
    var dict = NSDictionary.init()
    var is_applicant = false
    var isNetwork = false
    var isConnect = false
    var isPending = false
    var sentRqs = false
}
