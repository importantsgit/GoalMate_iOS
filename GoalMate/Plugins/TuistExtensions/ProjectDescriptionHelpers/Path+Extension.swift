//
//  Path+Extension.swift
//  AppExtensions
//
//  Created by Importants on 12/4/24.
//

import ProjectDescription

extension Path {
    public static func plistPath(_ plistName: String) -> Path {
         .relativeToRoot("SupportFiles/InfoPlist/\(plistName).plist")
    }
    
    public static func xcconfigPath(_ xcconfigName: String) -> Path {
        .relativeToRoot("SupportFiles/XCConfigs/\(xcconfigName).xcconfig")
    }
    
    public static func entitlementPath(_ entitle: String) -> Path {
      return .relativeToRoot("SupportFiles/Entitlements/\(entitle).entitlements")
    }
    
    public static func scriptPath(_ scriptName: String) -> Path {
      return .relativeToRoot("SupportFiles/Tools/\(scriptName)")
    }
}
