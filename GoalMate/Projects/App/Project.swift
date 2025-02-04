//
//  Projects.swift
//  TuistManifests
//
//  Created by 이재훈 on 12/24/24.
//

import TuistExtensions
import ProjectDescription
import Foundation

//let dependencies: [TargetDependency] = Module.featureModules.map(\.project)

/*
 해당 방식은 Demo Project를 따로 실행시키지 않고 App Project로 진행하는 방식입니다.
 */
nonisolated(unsafe) let projectConfig = ProjectType.getConfig()

let rootProject = Project.app(
    name: projectConfig.name,
    dependencies: projectConfig.dependencies,
    sources: projectConfig.sources,
    testSources: projectConfig.testSources
)

