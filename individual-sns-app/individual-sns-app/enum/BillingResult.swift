//
//  BillingResult.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/05/25.
//
import Foundation

/// 課金処理の結果
enum BillingResult {
    case success
    case userCancelled
    case pending
    case failed(Error)
}
