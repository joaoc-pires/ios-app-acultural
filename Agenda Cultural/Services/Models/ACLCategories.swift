//
//  ACLCategories.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 08/12/2021.
//

import Foundation

struct ACLCategories: Codable {
    let literature, cinema, music, theatre: ACLGenericObject?
    let arts, guidedTours, dance, science: ACLGenericObject?
    let fair: ACLGenericObject?
    
    enum CodingKeys: String, CodingKey {
        case literature = "literatura"
        case cinema
        case music = "musica"
        case theatre = "teatro"
        case arts = "artes"
        case guidedTours = "visitas-guiadas"
        case dance = "danca"
        case science = "ciencia"
        case fair = "feiras"
    }
}
