//
//  FileManager+contentsOfFolder.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 13/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation

extension FileManager {
    func isFolder(_ url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        guard fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            return false
        }
        return isDirectory.boolValue
    }
    
    func contents(of folderURL: URL) throws -> [URL] {
        guard isFolder(folderURL) else {
            return []
        }
        
        let contents = try contentsOfDirectory(atPath: folderURL.path)
        return contents.map { file in
            return folderURL.appendingPathComponent(file)
        }
    }
    
    func contents(of folderURL: URL, withExtensions extensions: [String]) throws -> [URL] {
        let allowedExtensions = extensions.map { $0.lowercased() }
        return try contents(of: folderURL).filter { allowedExtensions.contains($0.pathExtension.lowercased())
        }
    }
}

