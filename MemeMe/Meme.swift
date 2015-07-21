//
//  Meme.swift
//  Created by Stevenson Michel on 07/19/2015.
//  Copyright (c) 2015 Stevenson Michel. All rights reserved.
//

import Foundation
import UIKit
class Meme{
    var topText:String!
    var bottomText:String!
    var image: UIImage! //Original Image
    var memedImage: UIImage! //The generated image with Top and bottom text.

    init(let topText:String,let bottomText:String, let image:UIImage, let memedImage:UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
    
}