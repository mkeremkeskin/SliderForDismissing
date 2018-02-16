//
//  KKVerticalSlider.swift
//
//  Created by mkeremkeskin on 13.02.2018.
//  Copyright © 2018 mkeremkeskin. All rights reserved.
//
//

import UIKit

protocol KKVerticalSliderDelegate {
    func thumbReachedDestination()
    func thumbCurrentPosition(_ position:CGFloat)
}

@IBDesignable
class KKVerticalSlider: UIView  {

    var delegate: KKVerticalSliderDelegate?

    @IBOutlet weak fileprivate var sliderPath: UIView!
    @IBOutlet weak fileprivate var thumb: UIView!
    @IBOutlet weak fileprivate var destination: UIView!
    @IBOutlet weak fileprivate var thumbTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var panGesture: UIPanGestureRecognizer!

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    var contentView: UIView?
    var initialTopConstraint: CGFloat = 0.0

    var isDestinationReached: Bool {
        get {
            let distanceFromDestination: CGFloat = self.destination.center.y - self.thumb.center.y
            return distanceFromDestination < 1
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        arrangeView()
    }

    func arrangeView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        contentView = view
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: KKVerticalSlider.self), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    override func didMoveToWindow() {
        //ensure thumb always starts from top
        self.thumbTopConstraint.constant = 0
        self.initialTopConstraint = self.thumbTopConstraint.constant;
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        arrangeView()
        contentView?.prepareForInterfaceBuilder()
    }

    //pan action defined in xib
    @IBAction func panAction() {
        if panGesture.state == .changed {
            slideThumb()
            delegate?.thumbCurrentPosition(self.thumb.center.y)
        }
        else if panGesture.state == .ended {
            if isDestinationReached {
                delegate?.thumbReachedDestination()
            }
            else {
                returnInitialLocationAnimated(true)
            }
        }
    }
    
    func slideThumb() {
        
        let minY = CGFloat(0)
        let maxY = sliderPath.bounds.size.height - thumb.bounds.size.height
        
        var translation =  panGesture.translation(in: sliderPath)
        var draggedDistance = thumbTopConstraint.constant + translation.y

        // to prevent going up from path bounds
        if draggedDistance < 0 {
            draggedDistance = minY
            translation.y += thumbTopConstraint.constant - minY
        }
        // to prevent going down from path bounds
        else if draggedDistance > maxY {
            draggedDistance = maxY
            translation.y += thumbTopConstraint.constant - maxY
        }
        else {
            translation.y = 0
        }
        
        self.thumbTopConstraint.constant = draggedDistance
        self.panGesture.setTranslation(translation, in: sliderPath)
        
        UIView.animate( withDuration: 0.05, delay: 0, options: .beginFromCurrentState, animations: {
                self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func returnInitialLocationAnimated(_ animated: Bool) {
        thumbTopConstraint.constant = initialTopConstraint
        
        if (animated) {
            UIView.animate( withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
                    self.layoutIfNeeded()
                    self.delegate?.thumbCurrentPosition(self.thumb.center.y)
            }, completion: nil)
        }
    }
}
