//
//  Event.swift
//  Daybar
//
//  Created by Jay Stakelon on 8/16/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import Foundation

struct Event: Decodable, Identifiable {
    let id: UUID = UUID()
    let created: String?
    let summary: String?
    var description: String?
    let hangoutLink: String?
    var zoomLink: String?
    let location: String?
    let calendarEventLink: String?
    let start: EventTime
    let end: EventTime
    let attendees: [Attendee]?
    let conferenceData: ConferenceData?
    var responseStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case created
        case summary
        case description
        case hangoutLink
        case zoomLink
        case location
        case start
        case end
        case attendees
        case conferenceData
        case responseStatus
        case calendarEventLink = "htmlLink"
    }
 
}

struct Attendee: Decodable {
    let email: String?
    let responseStatus: String?
    let `self`: Bool?
}

struct ConferenceData: Decodable {
    let entryPoints: [EntryPoint]?
    let conferenceSolution: ConferenceSolution?
}

struct EntryPoint: Decodable {
    let entryPointType: String?
    let uri: String?
}

struct ConferenceSolution: Decodable {
    let name: String?
}
