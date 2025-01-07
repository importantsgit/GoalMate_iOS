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
        case Login
        case Home
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
        .project(target: self.name, path: self.path)
    }
    
    public static var featureModules: [Module] {
        FeatureType.allCases.map { .feature($0) }
    }
    
    public static var defaultModules: [Module] {
        [.Data, .Domain, .Utils]
    }
}
