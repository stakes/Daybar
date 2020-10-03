//
//  ContentView.swift
//  Daybar
//
//  Created by Jay Stakelon on 8/16/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var googleLoader: GoogleLoader
    let eventListViewModel = EventListViewModel()
    var body: some View {
        VStack {
            Spacer()
            Text("Daybar")
                .font(Font.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(Color.white)
            Spacer()
        }
            .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: []), startPoint: .top, endPoint: .bottom))
//        Group {
//            VStack(alignment: .leading, spacing: 0) {
//                if (googleLoader.signedIn) { // not logged in
//                    HStack {
//                        Spacer()
//                        HStack {
//                            Spacer()
//                            Text("Daybar")
//                                .font(Font.system(size: 15, weight: .medium, design: .default))
//                            Button(action: {
//                                self.googleLoader.signIn()
//                            }) {
//                                Text("Sign in with Google")
//                            }.buttonStyle(signInWithGoogleButtonStyle())
//                            Spacer()
//                        }
//                        Spacer()
//                    }
//                    .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .top, endPoint: .bottom))
//
//                } else { // logged in
//                    VStack(alignment: .leading, spacing: 0) {
//                        HeaderView(eventListViewModel: eventListViewModel)
//                        EventListView(eventListViewModel: eventListViewModel)
//                    }
//                }
//                Spacer()
//            }
//        }.onAppear {
//        }
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
