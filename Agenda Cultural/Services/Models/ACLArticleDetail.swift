//
//  ACLArticleDetail.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 08/12/2021.
//

import Foundation

struct ACLArticleDetail: Codable {
    let id: Int?
    let date, dateGmt: String?
    let guid: ACLGUID?
    let modified, modifiedGmt, slug, status: String?
    let type: String?
    let link: String?
    let title: ACLGUID?
    let content, excerpt: ACLGUID?
    let author: Int?
    let featuredMedia: String?
    let commentStatus, pingStatus: String?
    let sticky: Bool?
    let template, format: String?
    let meta: ACLMeta?
    let categories: [Int]?
    let tags: [String: ACLGenericObject]?
    let subtitle, subject: String?
    let venue: Bool?
    let aclArticleDetailDescription: [String]?
    let categoriesNameList: ACLCategories?
    let tagsNameList: [String: ACLGenericObject]?
    let targetAudience, accessibility: [JSONAny]?
    let extraInfo: String?
    let links: ACLLinks?
    
    enum CodingKeys: String, CodingKey {
        case id, date
        case dateGmt = "date_gmt"
        case guid, modified
        case modifiedGmt = "modified_gmt"
        case slug, status, type, link, title, content, excerpt, author
        case featuredMedia = "featured_media"
        case commentStatus = "comment_status"
        case pingStatus = "ping_status"
        case sticky, template, format, meta, categories, tags, subtitle, subject, venue
        case aclArticleDetailDescription = "description"
        case categoriesNameList = "categories_name_list"
        case tagsNameList = "tags_name_list"
        case targetAudience = "target_audience"
        case accessibility
        case extraInfo = "extra_info"
        case links = "_links"
    }
    
    var imageURL: String {
        
        guard let featuredMedia = featuredMedia else { return String() }
        return featuredMedia.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? String()
    }
}
