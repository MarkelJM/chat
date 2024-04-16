//
//  ImageType.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 12/3/24.
//

import Foundation
import UIKit

enum ImageType: String {
    case jpg, png
    
    var mimeType: String {
        switch self {
        case .jpg:
            return "image/jpeg"
        case .png:
            return "image/png"
        }
    }
    
    var fileExtension: String {
        switch self {
        case .jpg:
            return "jpg"
        case .png:
            return "png"
        }
    }
    
    init?(with data: Data) {
        if UIImage(data: data)?.jpegData(compressionQuality: 1.0) != nil {
            self = .jpg
        } else if UIImage(data: data)?.pngData() != nil {
            self = .png
        } else {
            return nil
        }
    }
}
