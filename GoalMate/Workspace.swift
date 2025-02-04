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
    return paths
}()

let workspace = Workspace(name: "GoalMateWorkspace", projects: projects)
