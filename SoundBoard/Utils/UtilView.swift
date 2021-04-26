//
//  UtilView.swift
//  SoundBoard
//
//  Created by mbtec22 on 22/04/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func hideKeyBoard(){
        let touch = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismmisKeyBoard))
        touch.cancelsTouchesInView = true
        view.addGestureRecognizer(touch)
    }
    
    @objc func dismmisKeyBoard(){
        view.endEditing(true)
    }
}
