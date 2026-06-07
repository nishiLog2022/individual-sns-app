//
//  AppUpdateType.swift
//  individual-sns-app
//
import Foundation

enum AppUpdateType {
    case none
    /// アップデート推奨（「後で」で閉じられる）
    case optional
    /// アップデート必須（閉じられない）
    case forced
}
