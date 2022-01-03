//
//  ACLLinks.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 08/12/2021.
//

import Foundation

struct ACLLinks: Codable {
    let linksSelf, collection, about: [ACLRef]?
    let author, replies: [ACLRef]?
    let predecessorVersion: [ACLRef]?
    let wpFeaturedmedia: [ACLRef]?
    let wpAttachment: [ACLRef]?
    let curies: [ACLRef]?
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case collection, about, author, replies
        case predecessorVersion = "predecessor-version"
        case wpFeaturedmedia = "wp:featuredmedia"
        case wpAttachment = "wp:attachment"
        case curies
    }
}

struct ACLRef: Codable {
    let embeddable: Bool?
    let name: String?
    let href: String?
    let templated: Bool?
    let id: Int?

}
