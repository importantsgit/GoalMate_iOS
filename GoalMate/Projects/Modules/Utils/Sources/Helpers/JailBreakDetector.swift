//
//  JailBreakDetector.swift
//  Utils
//
//  Created by 이재훈 on 2/19/25.
//

import Foundation
import UIKit

public struct JailbreakDetector {
    public static func checkJailBreak() -> Bool {
        hasSuspiciousFiles() ||
        canOpenSuspiciousURLSchemes() ||
        canWriteToPrivateDirectories() ||
        hasRestrictedPermissions()
    }

    private static func hasSuspiciousFiles() -> Bool {
        let suspiciousFiles = [
            "/Applications/Cydia.app",
            "/Applications/FakeCarrier.app",
            "/Applications/Sileo.app",
            "/Applications/Zebra.app",
            "/usr/sbin/frida-server",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/etc/apt",
            "/usr/sbin/sshd",
            "/bin/bash",
            "/usr/bin/ssh",
            "/usr/libexec/ssh-keysign",
            "/Library/PreferenceLoader",
            "/var/lib/cydia"
        ]

        return suspiciousFiles.contains {
            FileManager.default.fileExists(atPath: $0)
        }
    }

    private static func canOpenSuspiciousURLSchemes() -> Bool {
        let suspiciousURLSchemes = [
            "cydia://",
            "sileo://",
            "zebra://"
        ]

        return suspiciousURLSchemes.contains {
            guard let url = URL(string: $0) else { return false }
            return UIApplication.shared.canOpenURL(url)
        }
    }

    private static func canWriteToPrivateDirectories() -> Bool {
        let testPath = "/private/jailbreak_test.txt"
        do {
            try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return true
        } catch {
            return false
        }
    }

    private static func hasRestrictedPermissions() -> Bool {
        let fm = FileManager.default
        return fm.fileExists(atPath: "/var/mobile/Library/Preferences") &&
               fm.isWritableFile(atPath: "/var/mobile/Library/Preferences")
    }
}
