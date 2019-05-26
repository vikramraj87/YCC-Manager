//
//  Priceable.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 20/05/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation

protocol Priceable {
    var quantity: Int { get }
    
    var dealerPrice: Double { get }
    var profitExpected: Double { get }
    
    var shippingExpected: Double { get }
    var shippingIncurred: Double? { get }
    
    var retailPrice: Double { get }
    
    var totalPrice: Double { get }
    var totalProfitExpected: Double { get }
    
    var totalProfitActual: Double { get }
}

extension Priceable {
    var retailPrice: Double {
        return dealerPrice + profitExpected
    }
    
    var totalPrice: Double {
        guard quantity > 0 else { return 0 }
        
        return (retailPrice * Double(quantity)) + shippingExpected
    }
    
    var totalProfitExpected: Double {
        guard quantity > 0 else { return 0 }
        
        return profitExpected * Double(quantity)
    }
    
    var totalProfitActual: Double {
        guard let actualShipping = shippingIncurred else { return totalProfitExpected }
        
        return totalProfitExpected + shippingExpected - actualShipping
    }
}
