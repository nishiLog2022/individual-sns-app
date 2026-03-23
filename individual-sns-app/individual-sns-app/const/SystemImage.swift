//
//  SystemImage.swift
//  individual-sns-app
//
import Foundation

/// SF Symbols のアイコン名定数
enum SystemImage {

    // MARK: - タブバー
    enum Tab {
        static let home     = "house"
        static let favorite = "heart"
        static let post     = "plus.app.fill"
        static let profile  = "square.grid.3x3"
        static let setting  = "gearshape"
    }

    // MARK: - 投稿アクション
    enum Post {
        static let like        = "heart"
        static let liked       = "heart.fill"
        static let edit        = "square.and.pencil"
        static let delete      = "trash"
        static let noImage     = "photo"
        static let multiImage  = "square.on.square"
        static let close       = "xmark.circle.fill"
        static let addImage    = "plus"
        static let noText      = "text.alignleft"
    }

    // MARK: - ツールバー
    enum Toolbar {
        static let addPost = "plus"
    }

    // MARK: - 空状態
    enum Empty {
        static let noPosts     = "square.and.pencil"
        static let noFavorites = "heart.slash"
        static let noProfile   = "photo.on.rectangle.angled"
    }

    // MARK: - プロフィール
    enum Profile {
        static let editButton    = "pencil"
        static let defaultPhoto  = "person.circle.fill"
        static let camera        = "camera"
    }

    // MARK: - スプラッシュ
    enum Splash {
        static let appIcon = "camera.fill"
    }
}
