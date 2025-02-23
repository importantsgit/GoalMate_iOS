//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 2/22/25.
//

import TuistExtensions
import ProjectDescription

let commentGoal = Project.framework(
    name: "Feature" + Module.feature(.Comment).name,
    dependencies: [
        Module.feature(.Common).project
    ]
)

