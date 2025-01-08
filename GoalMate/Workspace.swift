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
        [
            Demo.Intro.path,
            Module.feature(.Intro).path,
            Module.feature(.Common).path
        ]
    case "SIGNUP":
        paths += [
            Demo.SignUp.path,
            Module.feature(.SignUp).path,
            Module.feature(.Common).path
        ]
    case "HOME":
        paths += [
            Demo.Home.path,
            Module.feature(.Home).path,
            Module.feature(.Common).path
        ]
    case "ALL":
        paths += (Module.featureModules).map(\.path) + [
            Project.appPath
        ]
        paths += Demo.allCases.map(\.path)
    default:
        paths += (Module.featureModules).map(\.path) + [
            Project.appPath
        ]
    }
    return paths
}()

let workspace = Workspace(name: "GoalMateWorkspace", projects: projects)
