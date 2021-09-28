//
//  NestedSearchCell.swift
//  ios
//
//  Created by Nicolò Padovan on 27/08/21.
//

import UIKit

class NestedSearchCell: UICollectionViewCell {
    
    let iconView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let skillTitleLabel = UILabel(text: "Sviluppo frontend", font: .avenirFont(ofSize: 12, weight: .medium), textColor: .black, textAlignment: .center, numberOfLines: 2)
    fileprivate let innerShadow = UIView(backgroundColor: .clear)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 20
        
        backgroundColor = .white
        dropShadow(cornerRadius: 20)
        
        addSubview(iconView)
        iconView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5))
        iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor).isActive = true
        
        iconView.addSubview(innerShadow)
        innerShadow.anchor(top: iconView.topAnchor, leading: iconView.leadingAnchor, bottom: iconView.bottomAnchor, trailing: iconView.trailingAnchor)
        
        addSubview(skillTitleLabel)
        skillTitleLabel.anchor(top: iconView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        
        innerShadow.dropInnerShadow()
        
        subviews.forEach({ $0.isUserInteractionEnabled = true })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
