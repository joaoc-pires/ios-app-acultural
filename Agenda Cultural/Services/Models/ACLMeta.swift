//
//  ACLMeta.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 08/12/2021.
//

import Foundation

struct ACLMeta: Codable {
    let episodeType, audioFile, duration, filesize: String?
    let dateRecorded, explicit, block, filesizeRaw: String?
    
    enum CodingKeys: String, CodingKey {
        case episodeType = "episode_type"
        case audioFile = "audio_file"
        case duration, filesize
        case dateRecorded = "date_recorded"
        case explicit, block
        case filesizeRaw = "filesize_raw"
    }
}
