//
//  EventView.swift
//  TodayTest
//
//  Created by Jay Stakelon on 8/16/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import SwiftUI

struct EventView: View {
    @ObservedObject var eventViewModel: EventViewModel
    var body: some View {
        
        VStack {
            HStack(alignment: .top, spacing: 0) {
                AttendanceIndicator(responseStatus: eventViewModel.event.responseStatus)
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 3) {
                            /// event start time
                            if (eventViewModel.event.start.dateTime != nil) {
                                Text("\(Dates().internetTimeToHumanTime(eventViewModel.event.start.dateTime!))")
                                    .font(Font.system(size: 13, weight: .medium, design: .default))
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, 6)
                            } else {
                                Text("ALL DAY")
                                    .font(Font.system(size: 13, weight: .medium, design: .default))
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, 6)
                            }
                            /// event title
                            if (eventViewModel.event.summary != nil) {
                                Button(action: {
                                    if let url = URL(string: self.eventViewModel.event.calendarEventLink!) {
                                        NSWorkspace.shared.open(url)
                                    }
                                }) {
                                    Text(eventViewModel.event.summary!)
                                        .font(Font.system(size: 16, weight: .semibold, design: .default))
                                        .foregroundColor(.primary)
                                        .padding(.top, -4)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        Spacer()
                        /// event time length
                        if (eventViewModel.event.start.dateTime != nil && eventViewModel.event.end.dateTime != nil) {
                            Text("\(Dates().timeDifferenceInWords(from: eventViewModel.event.start.dateTime!, to: eventViewModel.event.end.dateTime!))")
                                .font(Font.system(size: 12, weight: .regular, design: .default))
                                .foregroundColor(.secondary)
                                .padding(.bottom, 1)
                        }
                    }
                    /// event description
                    if (eventViewModel.event.description != nil) {
                        Text(eventViewModel.event.description!)
                            .font(Font.system(size: 13, weight: .regular, design: .default))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    /// event location
    //                if (eventViewModel.event.location != nil) {
    //                    Text(eventViewModel.event.location!)
    //                        .font(Font.system(size: 11, weight: .regular, design: .default))
    //                        .foregroundColor(.secondary)
    //                }
                    /// meeting link
                    if (eventViewModel.event.zoomLink != nil) {
                        Button(action: {
                            if let url = URL(string: self.eventViewModel.event.zoomLink!) {
                                NSWorkspace.shared.open(url)
                                print(url)
                            }
                        }) {
                            HStack(alignment: .center, spacing: 4)  {
                                Image("zoom-icon")
                                Text("Join Zoom")
                                    .font(Font.system(size: 15, weight: .semibold, design: .default))
                                    .foregroundColor(Color("ZoomBlue"))
                            }
                            
                        }.buttonStyle(PlainButtonStyle())
                    } else if (eventViewModel.event.hangoutLink != nil) {
                        Button(action: {
                            if let url = URL(string: self.eventViewModel.event.hangoutLink!) {
                                NSWorkspace.shared.open(url)
                            }
                        }) {
                            HStack(alignment: .center, spacing: 4) {
                                Image("meet-icon")
                                Text("Join Google Meet")
                                    .font(Font.system(size: 15, weight: .semibold, design: .default))
                                    .foregroundColor(Color("GoogleGreen"))
                            }
                        }.buttonStyle(PlainButtonStyle())
                    } 
                    
                }
                
        //            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .padding(.trailing, 12).padding(.bottom, 4).padding(.top, 4)
            Divider()
        }
    }
}

struct AttendanceIndicator: View {
    @State var responseStatus:String?
    
    var body: some View {
        Group {
            Circle()
                .fill(self.colorForStatus(responseStatus))
                .frame(width: 9, height: 9)
                .padding(.leading, 10)
                .padding(.trailing, 8)
                .padding(.top, 4)
        }
    }
    
    func colorForStatus(_ responseStatus: String?) -> Color {
        switch responseStatus {
        case "accepted": return Color("AcceptedGreen")
        case "tentative": return Color("TentativeYellow")
        case "declined": return Color.red // I don't show declined events anyway
        case "needsAction": return Color.gray
        default: return Color("AcceptedGreen") // pretty sure I get nil for self-created events
        }
    }
}


//struct EventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventView()
//    }
//}

