//
//  EventListViewModel.swift
//  Daybar
//
//  Created by Jay Stakelon on 8/16/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import Foundation
import Combine
import OAuth2
import AppKit

class EventListViewModel: NSObject, ObservableObject {
    
    @Published var events = [EventViewModel]()
    @Published var date = Date()
    @Published var isFirstFetchForDay: Bool = true
    @Published var isReallyEmpty: Bool = false
    @Published var errorCode: Int?
    
    var testMode = true
    
    func testTime() -> Date {
        return ISO8601DateFormatter().date(from: "2020-10-02T13:32:00-07:00")!
    }
    
//    var timer: Timer?
    
    func clear() {
        self.events = []
    }

    @objc func fetch() {
        let mainCalendarId = GoogleLoader.shared.profile?.email
        let apiKey = keys?.googleApiKey
        if let token = GoogleLoader.shared.oauth2.accessToken {
            self.errorCode = nil
            let timeMin = Dates().timeMinForDay(self.date)
            let timeMax = Dates().timeMaxForDay(self.date)
            
            if (mainCalendarId == nil) {
                return
            }
           
            let url = URL(string: "https://www.googleapis.com/calendar/v3/calendars/\(mainCalendarId!)/events?timeMax=\(timeMax)&timeMin=\(timeMin)&key=\(apiKey!)&singleEvents=true")
            var request = URLRequest(url: url!)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    let eventList = try JSONDecoder().decode(EventList.self, from: data!)
                    DispatchQueue.main.async {
                        if (self.isFirstFetchForDay) {
                            self.clear()
                            self.isFirstFetchForDay = false
                        }
                        var arr = [EventViewModel]()
                        for e in eventList.items {
                            arr.append(EventViewModel(event: e))
                        }
                        arr.removeAll(where: { $0.event.responseStatus == "declined" })
                        self.isReallyEmpty = (arr.count == 0) ? true : false
                        self.events = self.sortByStartTime(arr)
                        if (self.testMode) {
                            let calendar = Calendar.current
                            let testTime = calendar.date(byAdding: .minute, value: -15, to: self.testTime())
                            self.events.removeAll(where: { testTime! > ISO8601DateFormatter().date(from: $0.event.start.dateTime!)! })
//                            for e in self.events {
//                                if (self.makeTestDateTime() > ISO8601DateFormatter().date(from: e.event.start.dateTime!)!) {
//
//                                }
//                            }
                        }
                    }

                } catch _ as NSError {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: [String: Any]] {
                        let errorMsg = json["error"]
                        DispatchQueue.main.async {
                            if (self.isFirstFetchForDay) {
                                self.clear()
                                self.isFirstFetchForDay = false
                            }
                            self.errorCode = errorMsg?["code"] as? Int
                            if self.errorCode == 401 {
                                self.refreshAndRefetch()
                            }
                        }
                    }
                    
                }
            }.resume()
            
        } else {
            print("access token error") // probably should deal w this
        }
    }
    
    func onAppear() {
        fetch()
//        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
//            self.fetch()
//        }
//        timer?.tolerance = 1
    }
    
    func refreshAndRefetch() {
        self.isFirstFetchForDay = true
        GoogleLoader.shared.requestUserdata() { error in
            if let e = error {
                print(e) // another one to deal with
            } else {
                self.fetch()
            }
        }
    }
    
    func fetchForNextDay() {
        DispatchQueue.main.async {
            self.date = Dates().incrementDay(self.date)
            self.isFirstFetchForDay = true
            self.clear()
            self.fetch()
        }
    }
    
    func fetchForPrevDay() {
        DispatchQueue.main.async {
            self.date = Dates().decrementDay(self.date)
            self.isFirstFetchForDay = true
            self.clear()
            self.fetch()
        }
    }
    
    func sortByStartTime(_ arr: [EventViewModel]) -> [EventViewModel] {
        var allDayEvents = [EventViewModel]()
        var sortedEvents = arr
        for (i, evm) in arr.enumerated() {
            if (evm.event.start.dateTime == nil) {
                allDayEvents.append(evm)
                sortedEvents.remove(at: i)
            }
        }
        var sorted = sortedEvents.sorted {
            let d1 = ISO8601DateFormatter().date(from: $0.event.start.dateTime!)
            let d2 = ISO8601DateFormatter().date(from: $1.event.start.dateTime!)
            return d1!.compare(d2!) == .orderedAscending
        }
        sorted.insert(contentsOf: allDayEvents, at: 0)
        return sorted
    }
    
    func printResponse(_ data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
            print(json)
        }
    }
}


struct ApiError {
    var code: Int
    var message: String
    var status: String
}
