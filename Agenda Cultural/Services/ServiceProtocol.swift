//
//  ServiceProtocol.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 09/12/2021.
//

import Foundation

enum ServiceError: Error {
    case invalideResponseCode(code: Int)
    case failedToGetResponse
}

protocol Service {
    static func getData(forURL url: URL) async throws -> Data
}

extension Service {
    
    static func getData(forURL url: URL) async throws -> Data {
        
        let request = URLRequest(url: url)
        do {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            if let response = response as? HTTPURLResponse {
                
                switch response.statusCode {
                        
                    case 200...299: return data
                        // FIXME: - Log Errors
                    default: throw ServiceError.invalideResponseCode(code: response.statusCode)
                }
            }
            else {
                
                // FIXME: - Log Errors
                throw ServiceError.failedToGetResponse
            }
        }
        catch let error as NSError {
            
            // FIXME: - Log error
            print(error.userInfo)
            throw error
        }
    }
}
