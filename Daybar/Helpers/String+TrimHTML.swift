//
//  String+TrimHTML.swift
//  Daybar
//
//  Created by Jay Stakelon on 8/20/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import Foundation

extension String {

    public func trimHTML() -> String? {
        guard let htmlStringData = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let attributedString = try? NSAttributedString(data: htmlStringData, options: options, documentAttributes: nil)
        
        let string = attributedString?.string
        let trimmed = string?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return trimmed
    }
    
}
