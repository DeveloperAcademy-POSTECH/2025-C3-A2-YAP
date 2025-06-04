//
//  CGImagePropertyOrientation.swift
//  YAP
//
//  Created by Hong on 6/4/25.
//

import ImageIO
import UIKit

extension CGImagePropertyOrientation {
  init(_ uiOrientation: UIImage.Orientation) {
    switch uiOrientation {
    case .up: self = .up
    case .down: self = .down
    case .left: self = .left
    case .right: self = .right
    case .upMirrored: self = .upMirrored
    case .downMirrored: self = .downMirrored
    case .leftMirrored: self = .leftMirrored
    case .rightMirrored: self = .rightMirrored
    @unknown default:
      self = .up
    }
  }
}
