//
//  DetailHeroViewController.swift
//  DragonBallHeroes
//
//  Created by Ana on 12/3/25.
//

import UIKit

final class DetailHeroViewController: UIViewController {
    
    var hero: Hero
    
    // MARK: - Outlets
    
    @IBOutlet var heroImageView: UIImageView!
    @IBOutlet var nameHeroLabel: UILabel!
    @IBOutlet var descriptionHeroLabel: UILabel!
    
    
    // Initializer
    
    init(hero: Hero){
        
        self.hero = hero
        super.init(nibName: nil, bundle: nil)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: hero.photo) else {
            return
        }
        
        heroImageView.setImage(url: url)
        nameHeroLabel.text = hero.name
        descriptionHeroLabel.text = hero.description

        
    }



}
