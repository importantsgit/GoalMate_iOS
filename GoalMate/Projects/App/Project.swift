//
//  Projects.swift
//  TuistManifests
//
//  Created by 이재훈 on 12/24/24.
//

import TuistExtensions
import ProjectDescription

let dependencies: [TargetDependency] = Module.featureModules.map(\.project)

let rootProject = Project.app(
    name: "GoalMate",
    dependencies: dependencies
)

