//
//  EventListView.swift
//  Daybar
//
//  Created by Jay Stakelon on 8/16/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import SwiftUI
import HotKey

struct EventListView: View {
    
    @ObservedObject var eventListViewModel: EventListViewModel
    
//    let hotKey = HotKey(key: .r, modifiers: [.command, .option])
    
    var body: some View {
        VStack {
            if (eventListViewModel.isFirstFetchForDay) { // loading
                VStack(alignment: .center) {
                    Spacer()
                    HStack {
                        Spacer()
                        SpinnerView()
                        Spacer()
                    }
                    Spacer()
                }
            } else { // complete
                List {
                    if (eventListViewModel.errorCode != nil) {
                        EmptyListView(els: EmptyListState.retriableError, evm: eventListViewModel)
                    } else if (eventListViewModel.isReallyEmpty) {
                        EmptyListView(els: EmptyListState.noEvents)
                    } else if (eventListViewModel.isDoneForDay) {
                        EmptyListView(els: EmptyListState.eventsDone)
                    } else if (eventListViewModel.isNoConnection) {
                        EmptyListView(els: EmptyListState.noConnection)
                    } else {
                        ForEach(eventListViewModel.events) { item in
                            EventView(eventViewModel: item)
                        }.padding(.horizontal, -8)
                    }
                }
                .padding(.bottom, -8)
                .animation(nil)
            }
        }
        .animation(Animation.default)
        .transition(.opacity)
        .onAppear() {
            self.eventListViewModel.onAppear()
            // listen for hot key and refresh
//            self.hotKey.keyDownHandler = {
//                self.eventListViewModel.fetch()
//            }
        }
    }
}


struct EmptyListView: View {
    @State var els: EmptyListState
    var evm: EventListViewModel?
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            HStack {
                Spacer()
                if (els == EmptyListState.noEvents) {
                    Text("🤙")
                        .font(.largeTitle)
                        .frame(width: 200, height: 300)
                } else if (els == EmptyListState.eventsDone) {
                    Text("👏")
                        .font(.largeTitle)
                        .frame(width: 200, height: 300)
                } else if (els == EmptyListState.retriableError || els == EmptyListState.noConnection) {
                    VStack {
                        Text("🧐")
                            .font(.largeTitle)
                        Text("Hmmm")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("Couldn't fetch meetings.")
                        Button(action: {
                            self.evm?.refreshAndRefetch()
                        }) {
                            Text("Try again")
                        }
                    }.frame(width: 200, height: 300)
                } else {
                    Text("🤕")
                        .font(.largeTitle)
                        .frame(width: 200, height: 300)
                }
                
                Spacer()
            }
            Spacer()
        }
    }
}

enum EmptyListState {
    case noEvents
    case noConnection
    case eventsDone
    case retriableError
    case genericError
}
