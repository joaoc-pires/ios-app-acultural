//
//  ACLFeaturedMedia.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 08/12/2021.
//

import Foundation

enum ACLFeaturedMedia: Codable {
    case bool(Bool)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ACLFeaturedMedia.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for FeaturedMediaLarge"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .bool(let x):
                try container.encode(x)
            case .string(let x):
                try container.encode(x)
        }
    }
}
