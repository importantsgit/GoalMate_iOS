//
//  TargetScript.swift
//  TuistExtensions
//
//  Created by 이재훈 on 1/6/25.
//

import ProjectDescription
import Foundation

public extension TargetScript {
    enum UtilityTool {
        
        case swiftLint
        
        var scriptCommand: String {
            switch self {
            case .swiftLint:
                return """
ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
echo "PROJECT_DIR: ${ROOT_DIR}"
${ROOT_DIR}/SupportFiles/Tools/swiftlint --config "${ROOT_DIR}/Projects/Modules/Resources/Resources/swiftlint.yml"
"""
            }
        }
    }
    
    static func prebuildScript(utility: UtilityTool, name: String) -> TargetScript {
        return .pre(
            script: utility.scriptCommand,
            name: name,
            basedOnDependencyAnalysis: false
        )
    }
    
}
