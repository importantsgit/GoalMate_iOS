//
//  Project.swift
//  AppManifests
//
//  Created by Importants on 2/22/25.
//

import TuistExtensions
import ProjectDescription

let CommentDependencies: [TargetDependency] = [
    Module.feature(.Comment).project,
    Module.feature(.Common).project
]

let commentFeatureDemo = Project.app(
    name: "CommentFeatureDemo",
    dependencies: CommentDependencies,
    resources: [
        .glob(
            pattern: .relativeToRoot("SupportFiles/AppResources/**"),
            excluding: [],
            tags: [],
            inclusionCondition: nil
        )
    ]
)

