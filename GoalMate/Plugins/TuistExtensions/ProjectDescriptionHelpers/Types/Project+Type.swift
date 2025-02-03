//
//  Project+Type.swift
//  TuistExtensions
//
//  Created by 이재훈 on 1/9/25.
//

import ProjectDescription
import Foundation

public struct ProjectType {
    public struct Config {
        public let name: String
        public let dependencies: [TargetDependency]
        public let sources: SourceFilesList?
        public let testSources: SourceFilesList?
        
        init(
            name: String,
            dependencies: [TargetDependency],
            sources: SourceFilesList? = [],
            testSources: SourceFilesList? = []
        ) {
            self.name = name
            self.dependencies = dependencies
            self.sources = sources
            self.testSources = testSources
        }
    }
    
    private static let projectType = ProcessInfo.processInfo.environment["TUIST_TYPE"] ?? "APP"
    
    private static func getSourcePath(_ value: String) -> String {
        switch value {
        case "SIGNUP":
            return "../Demos/SignUpFeatureDemo/"
        case "INTRO":
            return "../Demos/IntroFeatureDemo/"
        case "HOME":
            return "../Demos/HomeFeatureDemo/"
        case "MYGOAL":
            return "../Demos/MyGoalFeatureDemo/"
        case "GOAL":
            return "../Demos/GoalFeatureDemo/"
        case "PROFILE":
            return "../Demos/ProfileFeatureDemo/"
        default:
            return ""
        }
    }
    
    public static func getConfig() -> Config {
        let value = projectType
        print(value)
        switch value {
        case "SIGNUP":
            return Config(
                name: "DemoSignUpFeature",
                dependencies: [
                    Module.feature(.SignUp).project,
                    Module.feature(.Common).project
                ],
                sources: [
                    "\(getSourcePath(value))Sources/**",
                ],
                testSources: [
                    "\(getSourcePath(value))Tests/**",
                ]
            )
        case "INTRO":
            return Config(
                name: "DemoIntroFeature",
                dependencies: [
                    Module.feature(.Intro).project,
                    Module.feature(.Common).project
                ],
                sources: [
                    "\(getSourcePath(value))Sources/**",
                ],
                testSources: [
                    "\(getSourcePath(value))Tests/**",
                ]
            )
        case "HOME":
            return Config(
                name: "DemoHomeFeature",
                dependencies: [
                    Module.feature(.Home).project,
                    Module.feature(.Common).project
                ],
                sources: [
                    "\(getSourcePath(value))Sources/**",
                ],
                testSources: [
                    "\(getSourcePath(value))Tests/**",
                ]
            )
        case "GOAL":
            return Config(
                name: "DemoGoalFeature",
                dependencies: [
                    Module.feature(.Goal).project,
                    Module.feature(.Common).project
                ],
                sources: [
                    "\(getSourcePath(value))Sources/**",
                ],
                testSources: [
                    "\(getSourcePath(value))Tests/**",
                ]
            )
        case "MYGOAL":
            return Config(
                name: "DemoMyGoalFeature",
                dependencies: [
                    Module.feature(.MyGoal).project,
                    Module.feature(.Common).project
                ],
                sources: [
                    "\(getSourcePath(value))Sources/**",
                ],
                testSources: [
                    "\(getSourcePath(value))Tests/**",
                ]
            )
        case "PROFILE":
            return Config(
                name: "DemoProfileFeature",
                dependencies: [
                    Module.feature(.Profile).project,
                    Module.feature(.Common).project
                ],
                sources: [
                    "\(getSourcePath(value))Sources/**",
                ],
                testSources: [
                    "\(getSourcePath(value))Tests/**",
                ]
            )
        default:
            return Config(
                name: "App",
                dependencies: Module.featureModules.map(\.project),
                sources: [
                    "\(getSourcePath(value))Sources/**",
                ],
                testSources: [
                    "\(getSourcePath(value))Tests/**",
                ]
            )
        }
    }
}
