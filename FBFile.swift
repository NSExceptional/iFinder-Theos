//
//  FBFile.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 14/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import UIKit

/// FBFile represents a file in FileBrowser
public class FBFile: NSObject {
    public let displayName: String
    public let isDirectory: Bool
    public let fileExtension: String?
    public let fileAttributes: NSDictionary?
    public let filePath: NSURL
    public let type: FBFileType
    
    init(filePath: NSURL) {
        self.filePath    = filePath
        let isDirectory  = IFCheckIsDirectory(filePath)
        self.isDirectory = isDirectory
        
        if self.isDirectory {
            self.fileAttributes = nil
            self.fileExtension  = nil
            self.type           = .Directory
        }
        else {
            self.fileAttributes = IFGetFileAttributes(self.filePath)
            self.fileExtension  = filePath.pathExtension
            
            if let fileExtension = fileExtension {
                self.type = FBFileType(rawValue: fileExtension) ?? .Default
            }
            else {
                self.type = .Default
            }
        }
        self.displayName = filePath.lastPathComponent ?? String()
    }
}

public enum FBFileType: String {
    case Default   = "file"
    case Directory = "directory"
    case PLIST     = "plist"
    case PNG       = "png"
    case ZIP       = "zip"
    case GIF       = "gif"
    case JPG       = "jpg"
    case JSON      = "json"
    case PDF       = "pdf"
    
    public func image() -> UIImage? {
        let bundle =  NSBundle(forClass: FileParser.self)
        var fileName = String()
        switch self {
        case Directory: fileName = "folder@2x.png"
        case JPG, PNG, GIF: fileName = "image@2x.png"
        case PDF: fileName = "pdf@2x.png"
        case ZIP: fileName = "zip@2x.png"
        default: fileName = "file@2x.png"
        }
        let file = UIImage(named: fileName, inBundle: bundle, compatibleWithTraitCollection: nil)
        return file
    }
}

func IFCheckIsDirectory(filePath: NSURL) -> Bool {
    var isDirectory = false
    do {
        var resourceValue: AnyObject?
        try filePath.getResourceValue(&resourceValue, forKey: NSURLIsDirectoryKey)
        if let number = resourceValue as? NSNumber where number == true {
            isDirectory = true
        }
    }
    catch { }
    return isDirectory
}

func IFGetFileAttributes(filePath: NSURL) -> NSDictionary? {
    guard let path = filePath.path else {
        return nil
    }
    
    return try? NSFileManager.defaultManager().attributesOfItemAtPath(path) as NSDictionary
}
