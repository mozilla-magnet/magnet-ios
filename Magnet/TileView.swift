//
//  TileView.swift
//  Magnet
//
//  Created by Etienne Segonzac on 21/03/16.
//  Copyright © 2016 Mozilla. All rights reserved.
//

import UIKit
import WebKit

class TileView: UIView, WKNavigationDelegate {
    let browser = WKWebView()

    convenience init(url: NSURL) {
        self.init()

        browser.translatesAutoresizingMaskIntoConstraints = false
        browser.navigationDelegate = self
        browser.alpha = 0
        self.addSubview(browser)

        let xConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|[browser]|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["browser": browser])
        let yConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[browser]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["browser": browser])
        self.addConstraints(xConstraints)
        self.addConstraints(yConstraints)

        let req = NSURLRequest(URL: url)
        self.browser.loadRequest(req)
    }

    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation) {
        browser.scrollView.scrollEnabled = false

        for subview in browser.subviews {
            if subview.isKindOfClass(UIScrollView.self) {
                if let sv = subview as? UIScrollView {
                    sv.scrollEnabled = false
                }
            }
        }
        UIView.animateWithDuration(0.3) {
            self.browser.alpha = 1.0
        }
    }

    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation, withError error: NSError) {
        UIView.animateWithDuration(0.3) {
            self.browser.alpha = 0.0
        }

    }
}