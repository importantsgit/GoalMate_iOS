//
//  Project.swift
//  Config
//
//  Created by Importants on 1/2/25.
//

import TuistExtensions
import ProjectDescription

let featureIntro = Project.framework(
    name: "Feature" + Module.feature(.Intro).name,
    dependencies: [
        Module.feature(.Common).project
    ]
)
