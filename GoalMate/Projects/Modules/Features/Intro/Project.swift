//
//  Project.swift
//  Config
//
//  Created by Importants on 1/2/25.
//

import TuistExtensions
import ProjectDescription

let featureIntro = Project.framework(
    name: Module.feature(.Intro).name,
    dependencies: [
        Module.feature(.Common).project,
        Module.Domain.project,
        Module.Utils.project,
        Module.Resources.project
    ]
)
