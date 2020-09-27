//
//  EventViewModel.swift
//  TodayTest
//
//  Created by Jay Stakelon on 8/16/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import Foundation
import Combine

class EventViewModel: ObservableObject, Identifiable {
    
    @Published var event: Event
//    @Published var formattedDescripton: String
    
    init(event: Event) {
        self.event = event
        if (self.event.description != nil) {
            self.event.zoomLink = ZoomParser().parseForZoomLink(self.event.description!)
            self.event.description = self.event.description!.trimHTML()
        }
        if (self.event.location != nil) {
            self.event.zoomLink = ZoomParser().parseForZoomLink(self.event.location!)
        }
        if (self.event.conferenceData?.conferenceSolution?.name == "Zoom Meeting") {
            for entryPoint in self.event.conferenceData?.entryPoints ?? [] {
                if (entryPoint.entryPointType! == "video") {
                    self.event.zoomLink = entryPoint.uri
                }
            }
        }
        for attendee in event.attendees ?? [] {
            if (attendee.`self` != nil) {
                self.event.responseStatus = attendee.responseStatus
            }
        }
    }
    
    
    
}
