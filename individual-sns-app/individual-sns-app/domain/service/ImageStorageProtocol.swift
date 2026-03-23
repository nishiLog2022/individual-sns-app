//
//  ImageStorageProtocol.swift
//  individual-sns-app
//
import UIKit

protocol ImageStorageProtocol {
    func saveImage(_ image: UIImage) -> String?
    func loadImage(fileName: String) -> UIImage?
    func deleteImage(fileName: String)
}
