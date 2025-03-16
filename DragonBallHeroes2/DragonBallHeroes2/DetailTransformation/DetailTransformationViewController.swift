//
//  DetailTransformationViewController.swift
//  DragonBallHeroes2
//
//  Created by Ana on 16/3/25.
//

import UIKit

class DetailTransformationViewController: UIViewController {
    
    var transformation: Transformation
        
        // MARK: - Outlets
        
        @IBOutlet var transformationImageView: UIImageView!
        @IBOutlet var nameTransformationLabel: UILabel!
        @IBOutlet var descriptionTransformationLabel: UILabel!
        
        
        // Initializer
        
        init(transformation: Transformation){
            
            self.transformation = transformation
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            
            guard let url = URL(string: transformation.photo) else {
                return
            }
            
            transformationImageView.setImage(url: url)
            nameTransformationLabel.text = transformation.name
            descriptionTransformationLabel.text = transformation.description
        }
        
    }

