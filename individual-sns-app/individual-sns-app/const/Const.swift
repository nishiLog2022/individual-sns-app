//
//  Const.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/21.
//
import Foundation

class Const {
    // ホーム画面で取得するデータ数
    static let getDataLimitForList: Int = 10
    // プロフィール画面で取得するデータ数
    static let getDataLimitForProfile: Int = 10
}
extension DateFormatter {
    /// yyyy/MM/dd 形式のフォーマッター
    static let postDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
}

