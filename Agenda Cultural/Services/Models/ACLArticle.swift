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
    
    var articleSortId: String {
        var month = self.month
        if (month ?? String()).count == 1 {
        
            month = "0\(month ?? String())"
        }
        return "\(year ?? String())\(month ?? String())\(String(id ?? 0))"
    }
    
    static func testArticle() -> ACLArticle {
        let result = ACLArticle(
            id: -1,
            type: "post",
            title: ACLGUID(rendered: "João Canijo"),
            subtitle: "\"Na minha vida fui sempre encontrando atrizes disponíveis para se entregarem e para me darem coisas interessantes. Muito mais do que atores.\"",
            aclArticleDescription: [],
            featuredMediaLarge: ACLFeaturedMedia.string("https://www.agendalx.pt/content/uploads/2023/04/HMM_8422-934x1400.jpg"),
            contentType: "entrevista",
            categoriesNameList: ACLCategories(literature: nil, cinema: ACLGenericObject(id: 38, slug: "cinema", name: "cinema"), music: nil, theatre: nil, arts: nil, guidedTours: nil, dance: nil, science: nil, fair: nil),
            tagsNameList: nil,
            link: "https://www.agendalx.pt/?post_type=post&p=90032")
        return result
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
