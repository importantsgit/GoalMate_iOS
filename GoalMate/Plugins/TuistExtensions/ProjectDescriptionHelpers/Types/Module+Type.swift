//
//  Module.swift
//  TuistExtensions
//
//  Created by Importants on 12/4/24.
//

import ProjectDescription

public enum Module {
    case feature(FeatureType)
    case Domain
    case Data
    case Utils
    
    public enum FeatureType: String, CaseIterable {
        case Intro
        case SignUp
        case Home
        case Goal
        case MyGoal
        case Profile
        case Common
    }
    
    public var name: String {
        switch self {
        case let .feature(feat):
            return feat.rawValue
        case .Domain:
            return "Domain"
        case .Data:
            return "Data"
        case .Utils:
            return "Utils"
        }
    }
    
    public var path: ProjectDescription.Path {
        let path = if case .feature = self { "Features/" } else { "" }
        return .relativeToRoot("Projects/Modules/\(path)" + self.name)
    }
    
    public var project: TargetDependency {
        let targetName: String
        switch self {
        case let .feature(feat):
            targetName = "Feature" + self.name
        default:
            targetName = self.name
        }
        return .project(
            target: targetName,
            path: self.path
        )
    }
    
    public static var featureModules: [Module] {
        FeatureType.allCases.map { .feature($0) }
    }
    
    public static var defaultModules: [Module] {
        [.Data, .Domain, .Utils]
    }
}
