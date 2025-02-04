//
//  Project.swift
//  Config
//
//  Created by Importants on 1/2/25.
//

import TuistExtensions
import ProjectDescription

let featureCommon = Project.framework(
    name: "Feature" + Module.feature(.Common).name,
    dependencies: [
        Module.Data.project,
        Module.Utils.project
    ],
    resources: .default
)
