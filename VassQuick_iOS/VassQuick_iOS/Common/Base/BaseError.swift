//
//  BaseError.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 5/3/24.
//

import Foundation

enum BaseError: Error {
    case generic
    case network(description: String)
    case noInternetConnection

    func description() -> String {
        switch self {
        case .generic:
            return "Error genérico"
        case .network(let description):
            return "Error de red: \(description)"
        case .noInternetConnection:
            return "No hay conexión a internet"
        }
    }
}
