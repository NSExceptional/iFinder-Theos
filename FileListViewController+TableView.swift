//
//  FlieListTableView.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 14/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import UIKit

extension FileListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.active ? filteredFiles.count : files.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FileCell"
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let file = fileForIndexPath(indexPath)
        cell.textLabel!.text  = file.displayName
        cell.imageView!.image = file.type.image()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Hide search bar, grab file
        searchController.active = false
        let selectedFile = fileForIndexPath(indexPath)
        
        // Push into new directory view, or perform the file tap action
        if selectedFile.isDirectory {
            let fileListViewController = FileListViewController(initialPath: selectedFile.filePath)
            fileListViewController.didSelectFile = didSelectFile
            self.navigationController!.pushViewController(fileListViewController, animated: true)
        }
        else {
            if let didSelectFile = didSelectFile {
                // Perform our overridden file selection action
                didSelectFile(selectedFile)
            }
            else {
                // Show file preview view controller
                let filePreview = previewManager.previewViewControllerForFile(selectedFile, fromNavigation: true)
                self.navigationController!.pushViewController(filePreview, animated: true)
            }
        }
    }
    
    func fileForIndexPath(indexPath: NSIndexPath) -> FBFile {
        if searchController.active {
            return filteredFiles[indexPath.row]
        }
        else {
            return files[indexPath.row]
        }
    }
}