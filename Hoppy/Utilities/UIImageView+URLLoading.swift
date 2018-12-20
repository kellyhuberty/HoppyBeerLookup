//
//  UIImageView+URLLoading.swift
//  Hoppy
//
//  Created by Kelly Huberty on 12/19/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

import UIKit


/**
 This extension is used to retrieve data off of the network and create a UIImage to use for the UIImageView's view.
 
 Note: This is a extension I originally wrote in objective-c many years ago and have re-written very similarly many different ways.
 I've also seen different implementations of this with the same basic premise. I decided now was a good time to re-write this
 in swift.
 
 Because I wanted to re-use this again I decided to forego using Alamofire to not create a dependence on it.
 */
@objc extension UIImageView{
    
    private struct Constants{
        static var UrlKey:String = "UIImageView+URLLoading.URLKey"
    }
    
    /**
     Sets the load URL and kicks off the data task to retreive and parse the image data.
     */
    @objc(setImageFromURL:) public func setImage(from url:URL){
        
        self.url = url

        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            DispatchQueue.main.async {
  
                guard let strongSelf = self else{
                    return
                }
                
                guard let data = data, error == nil else{
                    strongSelf.resetURLLoadedImage()
                    return
                }
                
                let image = UIImage(data: data)
                
                if strongSelf.url == url {
                    strongSelf.image = image
                }else{
                    strongSelf.resetURLLoadedImage()
                }
  
            }
        
        }
        
        dataTask.resume()
        
        
    }
    
    /**
    The source URL for the loading or loaded image. This is readonly and can only be set by the
    `setImage(from url:URL)` method.
     */
    public private(set) var url:URL?{
        set{
            image = nil
            objc_setAssociatedObject(self, &Constants.UrlKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &Constants.UrlKey) as? URL
        }
    }
    
    /**
     Resets the image view to nil, and nils the url so that incoming requests.
     */
    @objc(resetURLLoadedImage) public func resetURLLoadedImage(){
        image = nil
        url = nil
    }
    
    
    
}
