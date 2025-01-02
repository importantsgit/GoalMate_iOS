//
//  Workspace.swift
//  NFC_BLE_SPMManifests
//
//  Created by 이재훈 on 12/18/24.
//

import TuistExtensions
import ProjectDescription
import Foundation

// 명령어는 TUIST로 시작해야 함
let demoType = ProcessInfo.processInfo.environment["TUIST_TYPE"] ?? "APP"

let projects: [Path] = {
    var paths = Module.defaultModules.map(\.path)
    
    switch demoType {
    case "INTRO":
        paths += [
            .relativeToRoot("Projects/Demos/IntroFeatureDemo"),
            Module.feature(.Intro).path,
            Module.feature(.Common).path
        ]
    case "LOGIN":
        paths += [
            .relativeToRoot("Projects/Demos/LoginFeatureDemo"),
            Module.feature(.Login).path,
            Module.feature(.Common).path
        ]
    case "HOME":
        paths += [
            .relativeToRoot("Projects/Demos/HomeFeatureDemo"),
            Module.feature(.Home).path,
            Module.feature(.Common).path
        ]
    case "ALL":
        paths += (Module.featureModules).map(\.path) + [
            .relativeToRoot("Projects/App"),
            .relativeToRoot("Projects/Demos/LoginFeatureDemo"),
            .relativeToRoot("Projects/Demos/HomeFeatureDemo")
        ]
        
    default:
        paths += (Module.featureModules).map(\.path) + [
            .relativeToRoot("Projects/App")
        ]
    }
    return paths
}()

let workspace = Workspace(name: "GoalMateWorkspace", projects: projects)
