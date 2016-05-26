//
//  FileParser.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 13/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

class FileParser {
    
    static let sharedInstance = FileParser()
    
    var _excludedFileExtensions = [String]()
    var excludedFilepaths: [NSURL]?
    let fileManager = NSFileManager.defaultManager()
    
    var _fileOptions = NSDirectoryEnumerationOptions.SkipsHiddenFiles
    var skipsHiddenFiles = true {
        didSet {
            if skipsHiddenFiles {
                _fileOptions = [.SkipsHiddenFiles]
            } else {
                _fileOptions = []
            }
        }
    }
    
    /// Mapped for case insensitivity
    var excludedFileExtensions: [String]? {
        get {
            return _excludedFileExtensions
        }
        set {
            if let newValue = newValue {
                _excludedFileExtensions = newValue.map({$0.lowercaseString})
            }
        }
    }
    
    func documentsURL() -> NSURL {
        return fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
    }
    
    func filesInDirectory(directoryPath: NSURL) throws -> [FBFile]  {
        var files = [FBFile]()
        let filePaths = try self.fileManager.contentsOfDirectoryAtURL(directoryPath, includingPropertiesForKeys: [], options: _fileOptions)
        
        // Parse
        for filePath in filePaths {
            let file = FBFile(filePath: filePath)
            if excludedFileExtensions != nil, let fileExtension = file.fileExtension where excludedFileExtensions!.contains(fileExtension) {
                continue
            }
            if excludedFilepaths != nil && excludedFilepaths!.contains(file.filePath) {
                continue
            }
            if !file.displayName.isEmpty {
                files.append(file)
            }
        }
        
        return files.sort({$0.displayName < $1.displayName})
    }
    
}
