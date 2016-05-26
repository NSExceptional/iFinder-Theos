//
//  FileListTableFooterView.swift
//  iFinder
//
//  Created by Tanner on 5/25/16.
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

import UIKit

class FileListTableFooterView : UILabel {
    var fileCount = 0 {
        didSet {
            self.updateText()
        }
    }
    var directoryCount = 0 {
        didSet {
            self.updateText()
        }
    }
    
    private func updateText() {
        if self.directoryCount > 0 {
            if self.fileCount > 0 {
                self.text = "\(self.fileCount) files, \(self.directoryCount) folders"
            } else {
                self.text = "\(self.directoryCount) folders"
            }
        } else {
            if self.fileCount > 0 {
                self.text = "\(self.directoryCount) folders"
            } else {
                self.text = "No files or folders."
            }
        }
    }
}