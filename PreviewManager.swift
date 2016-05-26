//
//  PreviewManager.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 16/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import QuickLook

class PreviewManager: NSObject, QLPreviewControllerDataSource {
    
    var filePath: NSURL?
    
    // TODO nibs
    func previewViewControllerForFile(file: FBFile, fromNavigation: Bool) -> UIViewController {
        
        if file.type == .PLIST || file.type == .JSON {
            let webviewPreviewViewContoller = WebviewPreviewViewContoller(nibName: "WebviewPreviewViewContoller", bundle: nil)
            webviewPreviewViewContoller.file = file
            return webviewPreviewViewContoller
        }
        else {
            let previewTransitionViewController = PreviewTransitionViewController(nibName: "PreviewTransitionViewController", bundle: nil)
            previewTransitionViewController.quickLookPreviewController.dataSource = self

            self.filePath = file.filePath
            return fromNavigation ? previewTransitionViewController.quickLookPreviewController : previewTransitionViewController
        }
    }
    
    // MARK: QLPreviewControllerDataSource
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
        return PreviewItem(path: self.filePath)
    }
}

class PreviewItem: NSObject, QLPreviewItem {
    private let filePath: NSURL
    
    init(path: NSURL?) {
        self.filePath = path ?? NSURL()
    }
    
    internal var previewItemURL: NSURL {
        return self.filePath
    }
    
}
