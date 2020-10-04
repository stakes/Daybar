//
//  GoogleLoader.swift
//  Daybar
//
//  Created by Jay Stakelon on 8/17/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import Foundation
import OAuth2
import AppKit

class GoogleLoader: OAuth2DataLoader, ObservableObject {
    
    @Published var signedIn: Bool = false
    @Published var profile: Profile?
    
    let baseURL = URL(string: "https://www.googleapis.com")!
    
    // MARK: - Properties

    static let shared = GoogleLoader()

    private init() {
        let oauth = OAuth2CodeGrant(settings: [
            "client_id": keys?.googleOauthClientId,
            "client_secret": keys?.googleOauthClientSecret,
            "authorize_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://www.googleapis.com/oauth2/v3/token",
            "scope": "https://www.googleapis.com/auth/calendar.events.readonly profile email",
            "redirect_uris": ["urn:ietf:wg:oauth:2.0:oob"],
        ])
        oauth.authConfig.authorizeEmbedded = true
//        oauth.logger = OAuth2DebugLogger(.debug)
        super.init(oauth2: oauth, host: "https://www.googleapis.com")
        alsoIntercept403 = true
        signIn()
    }
    
    /** Perform a request against the API and return decoded JSON or an Error. */
    func request(path: String, callback: @escaping ((Error?) -> Void)) {
        let url = baseURL.appendingPathComponent(path)
        let req = oauth2.request(forURL: url)
        
        perform(request: req) { response in
            do {
                let dict = try response.responseJSON()
                print(dict)
                if let error = (dict["error"] as? OAuth2JSON)?["message"] as? String {
                    DispatchQueue.main.async {
                        callback(OAuth2Error.generic(error))
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.profile = Profile(
                            email: dict["email"] as! String,
                            name: dict["name"] as! String, picture:
                            dict["picture"] as! String
                        )
                        self.signedIn = true
                        callback(nil)
                    }
                }
            }
            catch let error {
                DispatchQueue.main.async {
                    callback(error)
                }
            }
        }
    }
    
    func requestUserdata(callback: @escaping ((_ error: Error?) -> Void)) {
        request(path: "oauth2/v1/userinfo", callback: callback)
    }
    
    func signIn() {
        signedIn = false
        NotificationCenter.default.removeObserver(self, name: OAuth2AppDidReceiveCallbackNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleRedirect(_:)), name: OAuth2AppDidReceiveCallbackNotification, object: nil)
        self.requestUserdata() { error in
            if let error = error {
                print(error) // probably should handle this better huh
            }
        }
    }
    
    @objc func signOutFromMenu(_ :NSMenuItem) {
        self.oauth2.forgetTokens()
        signedIn = false
    }
    

    @objc func handleRedirect(_ notification: Notification) {
        if let url = notification.object as? URL {
//            label?.stringValue = "Handling redirect..."
            do {
                try self.oauth2.handleRedirectURL(url)
            }
            catch let error {
                print(error)
            }
        }
        else {
            print(NSError(domain: NSCocoaErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid notification: did not contain a URL"]))
        }
    }

}

