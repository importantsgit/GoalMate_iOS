//
//  Configuration+Extension.swift
//  AppExtensions
//
//  Created by Importants on 12/4/24.
//

import ProjectDescription

public extension Configuration {
    enum ConfigScheme: ConfigurationName, CaseIterable {
        case debug = "Debug"
        case stage = "Stage"
        case release = "Release"
        
        var URLscheme: String {
            switch self {
            case .release: return "\(Project.appName)"
            case .debug: return "\(Project.appName)-dev"
            case .stage: return "\(Project.appName)-stg"
            }
        }
        
        var schemes: Scheme {
            .scheme(
                name: self.rawValue.rawValue,
                shared: true,
                buildAction: .buildAction(targets: ["\(self.URLscheme)"]),
                testAction: .targets(["\(Project.appName)Tests"]),
                runAction: .runAction(configuration: self.rawValue)
            )
        }
    }
    
    static func createAppConfiguration(
        configurations: [ConfigScheme]
    ) -> [Configuration] {
        configurations.map { configScheme -> Configuration in
            let configName = configScheme.rawValue
            var settings: SettingsDictionary = [
                "URL_SCHEMES": .string(configScheme.URLscheme),
                "CODE_SIGN_STYLE": "Manual",
                "DEVELOPMENT_TEAM": "$(DEVELOPMENT_TEAM)",
                "PROVISIONING_PROFILE_SPECIFIER": "$(PROVISIONING_PROFILE_SPECIFIER)",
                "CODE_SIGN_IDENTITY": "$(CODE_SIGN_IDENTITY)"
            ]
            
            return configName == .release ?
                .release(
                    name: configName,
                    settings: settings,
                    xcconfig: .xcconfigPath(configName.rawValue)
                ) :
                .debug(
                    name: configName,
                    settings: settings,
                    xcconfig: .xcconfigPath(configName.rawValue)
                )
        }
    }
    
    static func makeModuleConfiguration(
    ) -> [Configuration] {
        [
            .debug(
                name: "Debug",
                xcconfig: .xcconfigPath("Module")
            ),
            release(
                name: "Release",
                xcconfig: .xcconfigPath("Module")
            )
        ]

    }
}
