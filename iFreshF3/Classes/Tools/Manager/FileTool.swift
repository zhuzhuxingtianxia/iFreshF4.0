//
//  FileTool.swift
//  iFreshF
//
//  Created by Jion on 16/5/24.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class FileTool: NSObject {

    static let fileManager = FileManager.default
    
    /// 计算单个文件的大小
    class func fileSize(path: String) -> Double {
        
        if fileManager.fileExists(atPath: path) {
            var dict = try? fileManager.attributesOfItem(atPath: path)
            if let fileSize = dict![FileAttributeKey.size] as? Int{
                return Double(fileSize) / 1024.0 / 1024.0
            }
        }
        
        return 0.0
    }

    /// 计算整个文件夹的大小
    class func folderSize(path: String) -> Double {
        var folderSize: Double = 0
        if fileManager.fileExists(atPath: path) {
            let chilerFiles = fileManager.subpaths(atPath: path)
            for fileName in chilerFiles! {
                let tmpPath = path as NSString
                let fileFullPathName = tmpPath.appendingPathComponent(fileName)
                folderSize += FileTool.fileSize(path: fileFullPathName)
            }
            return folderSize
        }
        return 0
    }

    /// 清除文件 同步
    class func cleanFolder(path: String, complete:() -> ()) {
        
        let chilerFiles = self.fileManager.subpaths(atPath: path)
        for fileName in chilerFiles! {
            let tmpPath = path as NSString
            let fileFullPathName = tmpPath.appendingPathComponent(fileName)
            if self.fileManager.fileExists(atPath: fileFullPathName) {
                do {
                    try self.fileManager.removeItem(atPath: fileFullPathName)
                } catch _ {
                    
                }
            }
        }
        
        complete()
    }

    /// 清除文件 异步
    class func cleanFolderAsync(path: String, complete:@escaping () -> ()) {
        let queue = DispatchQueue(label: "cleanQueue")
        queue.async(execute: {
            let chilerFiles = self.fileManager.subpaths(atPath: path)
            for fileName in chilerFiles! {
                let tmpPath = path as NSString
                let fileFullPathName = tmpPath.appendingPathComponent(fileName)
                if self.fileManager.fileExists(atPath: fileFullPathName) {
                    do {
                        try self.fileManager.removeItem(atPath: fileFullPathName)
                    } catch _ {
                    }
                }
            }
            
            complete()
        })
        /*
        let queue = dispatch_queue_create("cleanQueue", nil)
        dispatch_async(queue) { () -> Void in
            let chilerFiles = self.fileManager.subpathsAtPath(path)
            for fileName in chilerFiles! {
                let tmpPath = path as NSString
                let fileFullPathName = tmpPath.stringByAppendingPathComponent(fileName)
                if self.fileManager.fileExistsAtPath(fileFullPathName) {
                    do {
                        try self.fileManager.removeItemAtPath(fileFullPathName)
                    } catch _ {
                    }
                }
            }
            
            complete()
       }
 */
    }

}
