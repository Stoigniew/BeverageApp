//
//  DrinkDetailsCell.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 14/03/2023.
//

import Foundation
import UIKit

class DrinkDetailsCell: UICollectionViewCell {
    
    var drink: Drink? {
        didSet {
            guard let drink = drink else {
                return
            }
            title.text = drink.name
            //image.image = drink.image
        }
    }
    
    private let title: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 5
        sv.alignment = .center
        
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(image)
        contentView.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
