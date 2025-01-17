//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/3/25.
//

import TuistExtensions
import ProjectDescription

let domain = Project.framework(
    name: Module.Domain.name,
    dependencies: [
        Module.Utils.project
    ]
)
