//
//  WebViewController.swift
//  Slot Machine
//
//  Created by Alex Pirog on 09.05.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private let test = "https://i.i-bbva.com/click.php?key=sv2n47z3n770fyx7tmjb&p=partner&c=creative&l=lander&off=offer&link=link"

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let url = URL(string: test)!
        let request = URLRequest(url: url)
        webView.load(request)
    }

}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url?.absoluteString else { return }
        if url.contains("google") {
            performSegue(withIdentifier: "toGames", sender: nil)
        } else {
            webView.isHidden = false
        }
    }
}
