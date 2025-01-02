//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/3/25.
//

import TuistExtensions
import ProjectDescription

let utils = Project.framework(
    name: Module.Utils.name,
    dependencies: [
        Module.Resources.project
    ]
)
