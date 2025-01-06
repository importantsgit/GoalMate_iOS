//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/3/25.
//

import TuistExtensions
import ProjectDescription

let data = Project.framework(
    name: Module.Data.name,
    dependencies: [
        Module.Utils.project
    ]
)
