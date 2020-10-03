//
//  AvatarFromURLView.swift
//  Daybar
//
//  Created by Jay Stakelon on 8/21/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import Combine
import SwiftUI

struct AvatarFromURLView: View {
    
    @ObservedObject var imageLoader:ImageLoader
    @State var image:NSImage = NSImage()
    
    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
    
    var body: some View {
        VStack {
            Image(nsImage: image)
                .resizable()
                .clipShape(Circle())
                .aspectRatio(contentMode: .fit)
                .frame(width:24, height:24)
        }.onReceive(imageLoader.dataPublisher) { data in
            self.image = NSImage(data: data) ?? NSImage()
        }
    }
}

struct AvatarFromURLView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarFromURLView(withURL: "")
    }
}
