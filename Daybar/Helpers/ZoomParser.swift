//
//  ZoomParser.swift
//  Daybar
//
//  Created by Jay Stakelon on 8/16/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import Foundation

class ZoomParser {
    func parseForZoomLink(_ str: String) -> String? {
        let text = str
        let types: NSTextCheckingResult.CheckingType = .link

        let detector = try? NSDataDetector(types: types.rawValue)

        guard let detect = detector else {
            return nil
        }

        let matches = detect.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count))

        var lastZoomMatch: String?
        for match in matches {
            if ((match.url?.absoluteString.contains("zoom.us")) == true) {
                lastZoomMatch = match.url?.absoluteString
            }
        }
        
        if (lastZoomMatch != nil) {
            return lastZoomMatch
        } else {
            return nil
        }
    }
    
    func convertToZoomURLScheme(_ str: String) {
        
        // TODO: use the actual zoom client url scheme
        // so i don't need to go this thing -> browser -> zoom
        // https://marketplace.zoom.us/docs/guides/guides/client-url-schemes
        
    }
}
