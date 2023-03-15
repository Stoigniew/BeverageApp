//
//  Coordinator.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 14/03/2023.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}
