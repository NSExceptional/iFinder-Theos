//
//  FileBrowser.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 14/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import UIKit

/// File browser containing navigation controller.
public class FileBrowser: UINavigationController {
    
    let parser = FileParser.sharedInstance
    
    var fileList: FileListViewController?

    /// File types to exclude from the file browser.
    public var excludedFileExtensions: [String]? {
        didSet {
            self.parser.excludedFileExtensions = excludedFileExtensions
        }
    }
    
    /// File paths to exclude from the file browser.
    public var excludedFilepaths: [NSURL]? {
        didSet {
            self.parser.excludedFilepaths = excludedFilepaths
        }
    }
    
    /// Override default preview and actionsheet behavior in favor of custom file handling.
    public var didSelectFile: ((FBFile) -> ())? {
        didSet {
            self.fileList?.didSelectFile = didSelectFile
        }
    }
    
    /// Starts in the documents directory
    public convenience init() {
        let path = FileParser.sharedInstance.documentsURL()
        self.init(initialPath: path)
    }
    
    /// Starts in a custom directory
    public convenience init(initialPath: NSURL) {
        let fileListViewController = FileListViewController(initialPath: initialPath)
        self.init(rootViewController: fileListViewController)
        self.view.backgroundColor = UIColor.whiteColor()
        self.fileList = fileListViewController
    }
    
}