//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/20/25.
//

import TuistExtensions
import ProjectDescription

let featureGoal = Project.framework(
    name: "Feature" + Module.feature(.Goal).name,
    dependencies: [
        Module.feature(.Common).project
    ]
)

