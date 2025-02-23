//
//  Project.swift
//  Config
//
//  Created by Importants on 1/2/25.
//

import TuistExtensions
import ProjectDescription

let featureHome = Project.framework(
    name: "Feature" + Module.feature(.Home).name,
    dependencies: [
        Module.feature(.Goal).project,
        Module.feature(.MyGoal).project,
        Module.feature(.Profile).project,
        Module.feature(.Comment).project,
        Module.Utils.project
    ]
)
