//
//  HeroListTableViewCell.swift
//  DragonBallHeroes
//
//  Created by Ana on 11/3/25.
//

import UIKit

final class HeroListTableViewCell: UITableViewCell {
    
    // MARK: - Identifier
    
    static let identifier = String(describing: HeroListTableViewCell.self)
    
    // MARK: - Outlets

    @IBOutlet var heroImage: UIImageView!
    @IBOutlet var heroNameLabel: UILabel!
    @IBOutlet var heroDescriptionLabel: UILabel!
    
    // MARK: - Configuration
    
    func configure(whith hero: Hero){
        guard let url = URL(string: hero.photo) else {
            return
        }
        
        heroImage.setImage(url: url)
        heroNameLabel.text = hero.name
        heroDescriptionLabel.text = hero.description
    }
}
