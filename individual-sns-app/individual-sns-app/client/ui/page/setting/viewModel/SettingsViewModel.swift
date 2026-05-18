//
//  SettingsViewModel.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/04/01.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    var dispCurrentVersion: String {
        return "Version: \(getCurrentVersion())"
    }
    
    func getCurrentVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
    }
}
