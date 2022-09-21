//
//  SplashScreenViewController.swift
//  SoftxpertTask
//
//  Created by Mina Ezzat on 9/21/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import Lottie

class SplashScreenViewController: UIViewController {
    var animationView: AnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()

        animationView = .init(name: "recipes-animation")
        animationView?.frame = view.bounds
        animationView?.loopMode = .loop
        view.addSubview(animationView!)
        animationView?.play()
        navigationToNextView()
    }

    func navigationToNextView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }

}
