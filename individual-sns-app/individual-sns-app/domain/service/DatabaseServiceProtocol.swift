//
//  DatabaseServiceProtocol.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/21.
//
import Foundation

protocol DatabaseServiceProtocol {
    var databaseURL: URL { get }
    func copyUrl()
}

