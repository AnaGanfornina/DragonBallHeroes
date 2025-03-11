//
//  Hero.swift
//  DragonBallHeroes
//
//  Created by Ana on 11/3/25.
//

import Foundation

struct Hero: Codable , Hashable{
    let id, name: String
    let favorite: Bool
    let photo: String
    let description: String
}
