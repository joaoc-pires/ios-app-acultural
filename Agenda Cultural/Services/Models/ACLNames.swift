//
//  ACLNames.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 08/12/2021.
//

import Foundation

enum ACLNames: Codable {
    case anythingArray([JSONAny])
    case genericObjectMap([String: ACLGenericObject])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([JSONAny].self) {
            self = .anythingArray(x)
            return
        }
        if let x = try? container.decode([String: ACLGenericObject].self) {
            self = .genericObjectMap(x)
            return
        }
        throw DecodingError.typeMismatch(ACLNames.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TagsNameList"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .anythingArray(let x):
                try container.encode(x)
            case .genericObjectMap(let x):
                try container.encode(x)
        }
    }
}
