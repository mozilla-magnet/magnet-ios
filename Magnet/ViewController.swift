//
//  ViewController.swift
//  Magnet
//
//  Created by Etienne Segonzac on 21/03/16.
//  Copyright © 2016 Mozilla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BeaconScannerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!

    let cellIdentifier = "cellBeaconURL"
    var beaconScanner: BeaconScanner!

    var tilesData = [NSURL: CGFloat]()
    var tiles = [NSURL: TileView]()

    let margin:CGFloat = 15

    override func viewDidLoad() {
        super.viewDidLoad()
        let z: CGFloat = 0
        self.scrollView.contentInset = UIEdgeInsets(top: UIApplication.sharedApplication().statusBarFrame.height, left: z, bottom: z, right: z)

        self.beaconScanner = BeaconScanner()
        self.beaconScanner.delegate = self
        self.beaconScanner.startScanning()

        layoutTiles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // TODO: unload web views outside of the viewport
    }

    func urlContextChanged(beaconScanner: BeaconScanner) {
        print("---------URLs------------")
        for url in beaconScanner.urlFound {
            print("\(url)")
        }
        print("--------------------------")

        for url in beaconScanner.urlFound {
            self.tilesData.updateValue(250, forKey: url) // default height
        }

        dispatch_async(dispatch_get_main_queue()) {
            self.layoutTiles()
        }
    }

    func layoutTiles() {
        var y: CGFloat = self.margin
        let height = self.margin + tilesData.values.reduce(0, combine: { (acc, requestedHeight) -> CGFloat in
            return acc + requestedHeight                                                                                                                                                                                                                         + self.margin
        })

        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.scrollView.bounds.width, height: height))
        contentView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.scrollView.addSubview(contentView)

        for (url, requestedHeight) in tilesData {
            let tile: TileView
            if let t = self.tiles[url] {
                tile = t
                self.scrollView.removeConstraints(t.constraints)
            } else {
                tile = TileView(url: url)
                tile.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(tile)
            }

            let xConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-margin-[tile]-margin-|",
                options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
                metrics: ["margin": self.margin],
                views: ["tile": tile])

            let yConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-y-[tile(==height)]",
                options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
                metrics: ["height": requestedHeight, "y": y],
                views: ["tile": tile])

            self.scrollView.addConstraints(xConstraints)
            self.scrollView.addConstraints(yConstraints)

            y += requestedHeight + self.margin
        }

        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: height)
    }
}

