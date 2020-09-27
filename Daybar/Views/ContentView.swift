//
//  ContentView.swift
//  MacTodayTest
//
//  Created by Jay Stakelon on 8/16/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var googleLoader: GoogleLoader
    let eventListViewModel = EventListViewModel()
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 0) {
                if (!googleLoader.signedIn) { // not logged in
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Daybar")
                            .font(Font.system(size: 15, weight: .medium, design: .default))
                        Button(action: {
                            self.googleLoader.signIn()
                        }) {
                            Text("Sign in with Google")
                        }.buttonStyle(signInWithGoogleButtonStyle())
                        Spacer()
                    }
                    Spacer()
                } else { // logged in
                    VStack(alignment: .leading, spacing: 0) {
                        HeaderView(eventListViewModel: eventListViewModel)
                        EventListView(eventListViewModel: eventListViewModel)
                    }
                }
                Spacer()
            }
        }.onAppear {
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct signInWithGoogleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(Font.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(.white)
                .padding(.leading, 36)
        }.frame(width: 208, height: 48).background(
            configuration.isPressed ? Image("google-signin-pressed") : Image("google-signin-normal")
        )
    }
}
