//
//  Storyboarded.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 14/03/2023.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let name = NSStringFromClass(self)
        let className = name.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }

}
