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
        Group {
            if (!googleLoader.signedIn) {
                LandingView()
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    HeaderView(eventListViewModel: eventListViewModel)
                    EventListView(eventListViewModel: eventListViewModel)
                }
            }
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
                .foregroundColor(.black)
                .padding(.leading, 36)
        }.frame(width: 208, height: 48).background(
            configuration.isPressed ? Image("white-google-signin-pressed") : Image("white-google-signin-normal")
        )
    }
}

struct LandingView: View {
    @EnvironmentObject var googleLoader: GoogleLoader
    var body: some View {
        VStack {
            Spacer()
            Text("Daybar")
                .font(Font.system(size: 36, weight: .bold, design: .default))
                .foregroundColor(Color.white)
                .padding(.bottom, 6)
            Text("Meetings in your Mac menubar")
                .font(Font.system(size: 18, weight: .regular, design: .default))
                .foregroundColor(Color.white)
                .padding(.bottom, 64)
                            
            LandingSubheadText()
                .landingSubhead()
                
            Button(action: {
                    self.googleLoader.signIn()
                }) {
                    Text("Sign in with Google")
                }.buttonStyle(signInWithGoogleButtonStyle())
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("LandingGradientStart"), Color("LandingGradientEnd")]), startPoint: .top, endPoint: .bottom)
        )
    }
}

struct LandingSubhead: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 13, weight: .regular, design: .default))
            .multilineTextAlignment(.center)
            .foregroundColor(Color.white.opacity(0.8))
            .padding(.horizontal, 36)
            .padding(.bottom, 12)
    }
}

extension View {
    func landingSubhead() -> some View {
        self.modifier(LandingSubhead())
    }
}

struct LandingSubheadText: View {
    var body: some View {
        Text("Connect your ") +
        Text("Google Calendar").bold() +
        Text(" to easily launch ") +
        Text("Google Meet").bold() +
        Text(" and ") +
        Text("Zoom meetings").bold()
    }
}
