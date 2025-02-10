//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 1/3/25.
//

import TuistExtensions
import ProjectDescription

let myGoalDependencies: [TargetDependency] = [
    Module.feature(.MyGoal).project,
    Module.feature(.Common).project
]

let myGoalFeatureDemo = Project.app(
    name: "DemoMyGoalFeature",
    dependencies: myGoalDependencies,
    resources: [
        .glob(
            pattern: .relativeToRoot("SupportFiles/AppResources/**"),
            excluding: [],
            tags: [],
            inclusionCondition: nil
        )
    ]
)
