//
//  Workspace.swift
//  NFC_BLE_SPMManifests
//
//  Created by 이재훈 on 12/18/24.
//

import TuistExtensions
import ProjectDescription
import Foundation

let projects: [Path] = {
    var paths = Module.defaultModules.map(\.path) + [Project.appPath]
//
//    switch demoType {
//    case "INTRO":
//        paths += [
//            Demo.Intro.path,
//            Module.feature(.Intro).path,
//            Module.feature(.Common).path
//        ]
//    case "SIGNUP":
//        paths += [
//            Demo.SignUp.path,
//            Module.feature(.SignUp).path,
//            Module.feature(.Common).path
//        ]
//    case "HOME":
//        paths += [
//            Demo.Home.path,
//            Module.feature(.Home).path,
//            Module.feature(.Common).path
//        ]
//    case "ALL":
//        paths += (Module.featureModules).map(\.path) + [
//            Project.appPath
//        ]
//        paths += Demo.allCases.map(\.path)
//    default:
//        paths += (Module.featureModules).map(\.path) + [
//            Project.appPath
//        ]
//    }
    return paths
}()

let workspace = Workspace(name: "GoalMateWorkspace", projects: projects)
