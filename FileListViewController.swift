//
//  FileListViewController.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 12/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import UIKit
import QuickLook

class FileListViewController: UIViewController, UIViewControllerPreviewingDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    // TableView
    var tableView: UITableView! {
        return self.view as! UITableView!
    }
    var footer: FileListTableFooterView! {
        return self.tableView.tableFooterView as! FileListTableFooterView!
    }
    
    /// Data
    var didSelectFile: ((FBFile) -> ())?
    var files          = [FBFile]()
    var initialPath    = NSURL(fileURLWithPath: "/")
    let parser         = FileParser.sharedInstance
    let previewManager = PreviewManager()
    
    // Search controller
    var filteredFiles = [FBFile]()
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle         = .Minimal
        searchController.searchBar.backgroundColor        = UIColor.whiteColor()
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    
    // MARK: Lifecycle
    
    convenience init(initialPath: NSURL) {
        // TODO nibs
        self.init()
        self.edgesForExtendedLayout = .None
        
        // Set initial path
        self.initialPath = initialPath
        self.title = initialPath.lastPathComponent
        
        // Set search controller delegates
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate   = self
        searchController.delegate             = self
    }
    
    deinit {
        if #available(iOS 9.0, *) {
            searchController.loadViewIfNeeded()
        } else {
            searchController.loadView()
        }
    }
    
    override func loadView() {
        self.view = UITableView(frame: CGRectMake(0, 0, 1, 1), style: .Plain)
        self.tableView.tableFooterView = FileListTableFooterView()
    }
    
    override func viewDidLoad() {
        // Set search bar, register for 3D touch, update footer
        tableView.tableHeaderView = searchController.searchBar
        self.registerFor3DTouch()
        self.countFoldersAndFiles()
        
        // Prepare data
        do {
            files = try parser.filesInDirectory(initialPath)
        } catch {
            files = []
            
            let alert = UIAlertController(title: "Error", message: (error as NSError).localizedDescription, preferredStyle: .ActionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.navigationController!.presentViewController(alert, animated: true, completion: nil)
        }
        
        // TableView stuff; don't need to reload data here
        self.tableView.delegate   = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure navigation bar is visible
        self.navigationController?.navigationBarHidden = false
    }
    
    // MARK: Data
    
    func filterContentForSearchText(searchText: String) {
        filteredFiles = files.filter({ (file: FBFile) -> Bool in
            return file.displayName.lowercaseString.containsString(searchText.lowercaseString)
        })
        tableView.reloadData()
    }
    
    func countFoldersAndFiles() {
        var files = 0, directories = 0
        for file in self.files {
            if file.isDirectory {
                directories += 1
            } else {
                files += 1
            }
        }
        
        self.footer.fileCount = files
        self.footer.directoryCount = directories
    }
    
    // MARK: UIViewControllerPreviewingDelegate
    
    func registerFor3DTouch() {
        if #available(iOS 9.0, *) {
            if self.traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
                registerForPreviewingWithDelegate(self, sourceView: tableView)
            }
        }
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if #available(iOS 9.0, *) {
            if let indexPath = tableView.indexPathForRowAtPoint(location) {
                let selectedFile = fileForIndexPath(indexPath)
                previewingContext.sourceRect = tableView.rectForRowAtIndexPath(indexPath)
                if selectedFile.isDirectory == false {
                    return previewManager.previewViewControllerForFile(selectedFile, fromNavigation: false)
                }
            }
        }
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        if let previewTransitionViewController = viewControllerToCommit as? PreviewTransitionViewController {
            self.navigationController?.pushViewController(previewTransitionViewController.quickLookPreviewController, animated: true)
        }
        else {
            self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
        }
        
    }
    
    // MARK: UISearchControllerDelegate
    
    func willPresentSearchController(searchController: UISearchController) {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContentForSearchText(searchBar.text!)
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filterContentForSearchText(searchController.searchBar.text!)
    }
}

