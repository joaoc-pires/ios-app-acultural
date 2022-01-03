//
//  ACLArticle.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 08/12/2021.
//

import Foundation

struct ACLArticle: Codable {
    let id: Int?
    let type: String?
    let title: ACLGUID?
    let subtitle: String?
    let aclArticleDescription: [String]?
    var year, month: String?
    let featuredMediaLarge: ACLFeaturedMedia?
    let contentType: String?
    let categoriesNameList: ACLCategories?
    let tagsNameList: ACLNames?
    let link: String?
    
    enum CodingKeys: String, CodingKey {
        case id, type, title, subtitle
        case aclArticleDescription = "description"
        case year, month
        case featuredMediaLarge = "featured_media_large"
        case contentType = "content_type"
        case categoriesNameList = "categories_name_list"
        case tagsNameList = "tags_name_list"
        case link
    }
    
    var isInterview: Bool {
        contentType?.contains("entrevista") ?? false
    }
    
    var imageURL: String {
        
        guard let featuredMedia = featuredMediaLarge else { return String() }
        switch featuredMedia {
                
            case .bool(_): return String()
            case .string(let value): return value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? String()
        }
    }
}

extension ACLArticle: Hashable {
    
    static func == (lhs: ACLArticle, rhs: ACLArticle) -> Bool {
        
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(id)
    }
}
