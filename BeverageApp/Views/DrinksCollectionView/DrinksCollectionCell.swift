//
//  DrinksCollectionCell.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 15/03/2023.
//

import Foundation
import UIKit

class DrinksCollectionCell: UICollectionViewCell {
    var drink: Drink? {
        didSet {
            guard let drink = drink else {
                return
            }
            title.text = drink.name
        }
    }
    
    var drinkImage: UIImage? {
        didSet {
            guard let image = drinkImage else {
                return
            }
            self.imageView.image = image
        }
    }
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.alignment = .center
        sv.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        sv.isLayoutMarginsRelativeArrangement = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(title)
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
