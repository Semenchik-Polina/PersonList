//
//  UserPhotoHandler.swift
//  PersonList
//
//  Created by Polina on 2/24/19.
//  Copyright © 2019 Polina. All rights reserved.
//

import Foundation
import UIKit

enum UserPhotoError: Error{
    case noImage(String)
}


class UserPhotoHandler{
    
    static let directoryName = "usersPhoto"
    static let fileManager = FileManager.default
    
    class func getDirectoryPath() ->NSURL{
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(directoryName)
        let url = NSURL(string: path)
        return url!
    }
    
    class func saveImageDocumentDirectory(image: UIImage, imageName: String){
	        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(directoryName)
        
        if !fileManager.fileExists(atPath: path){
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        
        let url = NSURL(string: path)
        let imagePath = url!.appendingPathComponent("\(imageName).jpg")
        let urlString: String = imagePath!.absoluteString
        let imageData = image.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
    
    }
    
    class func getImageFromDocumentDirectory(imageName: String) throws -> UIImage?{
        let imagePath = (self.getDirectoryPath() as NSURL).appendingPathComponent("\(imageName).jpg")
        let urlString: String = imagePath!.absoluteString
        if fileManager.fileExists(atPath: urlString){
            let image = UIImage(contentsOfFile: urlString)
            return image
        }else{
            throw UserPhotoError.noImage("There is no such image")
        }
    }
    
    class func deleteImageFromDocumentDirectory(imageName: String){
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(imageName).jpg")
        
        if fileManager.fileExists(atPath: imagePath){
            try! fileManager.removeItem(atPath: imagePath)
        }else{
            print("Deleting failed")
        }
    }
}
