//
//  VKLoginViewController.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import WebKit
import UIKit

class VKLoginViewController: UIViewController  {
    
    //MARK: - Outlets
    @IBOutlet weak var loginWebView: WKWebView! {
        didSet {
            loginWebView.navigationDelegate = self
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuth()
    }
}

//MARK: - Extension WKNavigationDelegate
extension VKLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        guard
            let token = params["access_token"],
            let userIDString = params["user_id"],
            let userID = Int(userIDString)
        else {
            return
        }
        
        Session.shared.token = token
        Session.shared.userID = userID
        
        decisionHandler(.cancel)
        
        performSegue(withIdentifier: "MessengerMenu", sender: self)
    }
}

//MARK: - PrivateExtension
private extension VKLoginViewController {

    func loadAuth() {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "8181164"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "friends, photos, groups"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "revoke", value: "1"),
            URLQueryItem(name: "v", value: "5.131")
        ]
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        loginWebView.load(request)
    }
}

