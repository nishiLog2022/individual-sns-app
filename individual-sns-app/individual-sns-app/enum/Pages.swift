//
//  Untitled.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/20.
//
import Foundation

enum Pages {
    case home
    case favorite
    case post
    case profile
    case setting
    
    var title: String {
        switch self {
        case .home:
            return "ホーム"
        case .favorite:
            return "お気に入り"
        case .post:
            return "投稿"
        case .profile:
            return "プロフィール"
        case .setting:
            return "設定"
        }
    }
    
    var image: String {
        switch self {
        case .home:
            return "house"
        case .favorite:
            return "heart"
        case .post:
            return "plus.app.fill"
        case .profile:
            return "square.grid.3x3"
        case .setting:
            return "gearshape"
        }
    }
}
