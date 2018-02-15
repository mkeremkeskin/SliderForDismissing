//
//  ViewController.swift
//  KKVerticalSlider
//
//  Created by mkeremkeskin on 13.02.2018.
//  Copyright © 2018 mkeremkeskin. All rights reserved.
//

import UIKit

class DismissingViewController: UIViewController {

    @IBOutlet weak var viewToSlide: UIView!
    @IBOutlet weak var kkVerticalSlider: KKVerticalSlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        kkVerticalSlider.delegate = self
    }
}

extension DismissingViewController : KKVerticalSliderDelegate {
    func thumbReachedDestination() {
        UIView.animate(withDuration: 1, animations: {
            self.viewToSlide.layer.cornerRadius = self.viewToSlide.frame.size.width / 20
            self.viewToSlide.frame = CGRect(x: 0 , y: self.kkVerticalSlider.frame.maxY, width: self.viewToSlide.frame.size.width, height: self.viewToSlide.frame.size.height)
            self.kkVerticalSlider.alpha = 0
        }, completion: { (isCompleted) in
            self.dismiss(animated: false, completion: nil)
        })
    }

    func thumbCurrentPosition(_ position: CGFloat) {
        let startedPoint : CGFloat = 35
        if position < kkVerticalSlider.frame.size.height {
            var frame = self.viewToSlide.frame
            frame.origin.y = position - startedPoint
            self.viewToSlide.frame = frame
        }
    }
}
