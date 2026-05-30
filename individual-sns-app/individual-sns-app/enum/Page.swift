//
//  Untitled.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/20.
//
import Foundation

enum Page {
    case home
    case favorite
    case saved
    case post
    case profile
    case setting
    
    var title: String {
        switch self {
        case .home:     return Message.Title.home
        case .favorite: return Message.Title.favorite
        case .saved:    return Message.Title.saved
        case .post:     return Message.Title.post
        case .profile:  return Message.Title.profile
        case .setting:  return Message.Title.other
        }
    }

    var image: String {
        switch self {
        case .home:     return SystemImage.Tab.home
        case .favorite: return SystemImage.Tab.favorite
        case .saved:    return SystemImage.Tab.saved
        case .post:     return SystemImage.Tab.post
        case .profile:  return SystemImage.Tab.profile
        case .setting:  return SystemImage.Tab.setting
        }
    }
}
