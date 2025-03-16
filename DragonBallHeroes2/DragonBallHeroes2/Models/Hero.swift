//
//  Hero.swift
//  DragonBallHeroes2
//
//  Created by Ana on 16/3/25.
//

import Foundation

struct Hero: Codable , Hashable{
    let id, name: String
    let favorite: Bool
    let photo: String
    let description: String
}
