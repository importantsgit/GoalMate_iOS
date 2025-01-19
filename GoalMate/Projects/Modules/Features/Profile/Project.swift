//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/20/25.
//

import TuistExtensions
import ProjectDescription

let featureProfile = Project.framework(
    name: "Feature" + Module.feature(.Profile).name,
    dependencies: [
        Module.feature(.Common).project
    ]
)


