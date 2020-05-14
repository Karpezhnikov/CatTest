//
//  CatCVC.swift
//  CatTest
//
//  Created by kam_team on 14.05.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit

class CatCVC: UICollectionViewCell {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundViewCell: UIView!
    @IBOutlet weak var imageCat: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //indicator.startAnimating()
        indicator.isHidden = true
        
        imageCat.image = UIImage()
        imageCat.contentMode = .scaleAspectFill
        imageCat.layer.cornerRadius = 10
        
        backgroundViewCell.layer.shadowColor = UIColor.black.cgColor
        backgroundViewCell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        backgroundViewCell.layer.shadowRadius = 5.0
        backgroundViewCell.layer.shadowOpacity = 0.5
        backgroundViewCell.layer.masksToBounds = false
        backgroundViewCell.backgroundColor = .clear
        
        self.backgroundColor = .clear
    }
    
}
