//
//  UIAnimation.swift
//  DollarCalculator
//
//  Created by YANA on 08/03/2022.
//

import Foundation
import MBProgressHUD

protocol UiAnimatable where Self: UIViewController {
    func showLoadingAnimation()
    func hideLoadingAnimation()
    
}


extension UiAnimatable {
    func showLoadingAnimation(){
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func hideLoadingAnimation(){
        DispatchQueue.main.async{
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
}
