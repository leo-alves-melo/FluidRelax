//
//  ShapeType.swift
//  FluidRelax
//
//  Created by Leonardo Alves de Melo on 07/06/17.
//  Copyright © 2017 Leonardo Alves de Melo. All rights reserved.
//

import Foundation

enum ShapeType:Int {
    case box = 0
    case sphere
    case pyramid
    case torus
    case capsule
    case cylinder
    case cone
    case tube
    
    // 2
    static func random() -> ShapeType {
        let maxValue = tube.rawValue
        let rand = arc4random_uniform(UInt32(maxValue+1))
        return ShapeType(rawValue: Int(rand))!
    }
}
