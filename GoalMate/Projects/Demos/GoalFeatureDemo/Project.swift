//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/3/25.
//

import TuistExtensions
import ProjectDescription

let goalListDependencies: [TargetDependency] = [
    Module.feature(.Goal).project,
    Module.feature(.Common).project
]

let goalListFeatureDemo = Project.app(
    name: "DemoGoalListFeature",
    dependencies: goalListDependencies,
    resources: [
        .glob(
            pattern: .relativeToRoot("SupportFiles/AppResources/**"),
            excluding: [],
            tags: [],
            inclusionCondition: nil
        )
    ]
)
