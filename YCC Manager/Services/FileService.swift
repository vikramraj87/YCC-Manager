//
//  FileService.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 02/09/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation

class FileService {
    static let shared = FileService()
    
    private let fileManager = FileManager.default
    
    private lazy var appName: String = {
        let infoDict = Bundle.main.infoDictionary!
        let key = kCFBundleNameKey as String
        return infoDict[key] as! String
    }()
    
    lazy var appDirectory: URL = {
        let picturesURL = fileManager.urls(for: .picturesDirectory,
                                           in: .userDomainMask).first!
        
        let url = picturesURL.appendingPathComponent(appName)
        
        try? fileManager.createDirectory(at: url,
                                         withIntermediateDirectories: true,
                                         attributes: nil)
        
        return url
    }()
    
    lazy var dbURL: URL = {
        return appDirectory.appendingPathComponent("db")
            .appendingPathExtension("sqlite")
    }()
    
    private init() {}
}
