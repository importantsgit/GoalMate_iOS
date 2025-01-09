//
//  Demo.swift
//  TuistExtensions
//
//  Created by Importants on 1/8/25.
//

import ProjectDescription

public enum Demo: String, CaseIterable {
    case Intro
    case SignUp
    case Home
    
    public var path: ProjectDescription.Path {
        .relativeToRoot("Projects/Demos/\(self.rawValue)FeatureDemo")
    }
}
