//
//  MagazineService.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 08/12/2021.
//

import Foundation

struct MagazineService: Service {
    
    static func getAllArticles() async throws -> [ACLArticle] {
        
        let url = URL(string: "https://www.agendalx.pt/wp-json/agendalx/v1/articles/all")!
        do {
            
            let data = try await getData(forURL: url)
            let articles = try JSONDecoder().decode([ACLArticle].self, from: data)
            return articles
        }
        catch let error as NSError {
            
            // FIXME: - Log error
            print(error.userInfo)
            throw error
        }
    }
    
    static func getArticle(byId articleId: Int) async throws -> ACLArticleDetail {
        
        let url = URL(string: "https://www.agendalx.pt/wp-json/wp/v2/posts/\(articleId)")!
        do {
            
            let data = try await getData(forURL: url)
            let article = try JSONDecoder().decode(ACLArticleDetail.self, from: data)
            return article
        }
        catch let error as NSError {
            
            // FIXME: - Log error
            print(error.userInfo)
            throw error
        }
    }
    
    static func getAuthor(byId authorId: Int) async throws -> ACLAuthor {
        
        let url = URL(string: "https://www.agendalx.pt/wp-json/wp/v2/users/\(authorId)")!
        do {
            
            let data = try await getData(forURL: url)
            let author = try JSONDecoder().decode(ACLAuthor.self, from: data)
            return author
        }
        catch let error as NSError {
            
            // FIXME: - Log error
            print(error.userInfo)
            throw error
        }
    }
}
