//
//  HeaderView.swift
//  MacTodayTest
//
//  Created by Jay Stakelon on 8/21/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var googleLoader: GoogleLoader
    @ObservedObject var eventListViewModel: EventListViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button(action: {
                    self.eventListViewModel.fetchForPrevDay()
                }) {
                    Image(nsImage: NSImage(named: NSImage.goLeftTemplateName)!)
                }.buttonStyle(PlainButtonStyle())
                Text(Dates().dayInWords(eventListViewModel.date)).font(Font.system(size: 18, weight: .bold, design: .default))
                Button(action: {
                    self.eventListViewModel.fetchForNextDay()
                }) {
                    Image(nsImage: NSImage(named: NSImage.goRightTemplateName)!)
                }.buttonStyle(PlainButtonStyle())
                
                Spacer()
                DropdownMenuView(profile: googleLoader.profile ?? nil).frame(width: 48, height: 24)
            }.padding(12)
            Divider().background(Color.gray.opacity(0.1))
        }.background(Color.gray.opacity(0.1))
    }
}

//
//struct HeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderView()
//    }
//}
