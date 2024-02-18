//
//  Bundle+extension.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 19/02/24.
//

import Foundation

extension Bundle {
    /// The version number of the application
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// The build version of the application
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
