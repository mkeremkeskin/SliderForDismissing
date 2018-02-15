//
//  InitialViewController.swift
//  KKVerticalSlider
//
//  Created by mkeremkeskin on 13.02.2018.
//  Copyright © 2018 mkeremkeskin. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openDismissingViewController(_ sender: Any) {
        let dismissingVC = self.storyboard?.instantiateViewController(withIdentifier: "DismissingViewController")
        dismissingVC?.modalPresentationStyle = .overCurrentContext
        self.present(dismissingVC!, animated: true, completion: nil)
    }

}
