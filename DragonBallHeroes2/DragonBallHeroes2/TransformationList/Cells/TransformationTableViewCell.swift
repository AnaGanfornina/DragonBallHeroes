//
//  TransformationTableViewCell.swift
//  DragonBallHeroes
//
//  Created by Ana on 13/3/25.
//

import UIKit

final class TransformationTableViewCell: UITableViewCell {

  // MARK: - Identifier
    
    static let identifier = String(describing: TransformationTableViewCell.self)
    
    // MARK: - Outlets
        
    @IBOutlet var transformationImage: UIImageView!
    @IBOutlet var transformationNameLabel: UILabel!
    @IBOutlet var transformationDescriptionLabel: UILabel!
    
    // MARK: - Configuration
    
    func configure(whith transformation: Transformation){
        guard let url = URL(string: transformation.photo) else {
            return
        }
        
        transformationImage.setImage(url: url)
        transformationNameLabel.text = transformation.name
        transformationDescriptionLabel.text = transformation.description
    }
}

