//
//  PriceableTests.swift
//  YCC ManagerTests
//
//  Created by Vikram Raj Gopinathan on 20/05/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import XCTest
@testable import YCC_Manager

struct FakePriceable: Priceable {
    var quantity: Int
    
    var dealerPrice: Double
    var profitExpected: Double
    
    var shippingExpected: Double
    var shippingIncurred: Double?
}

class PriceableTests: XCTestCase {
    func testRetailPriceCalculation() {
        let item1 = FakePriceable(quantity: 1,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: 180.00)
        XCTAssertEqual(item1.retailPrice, 349.0)
        
        let item2 = FakePriceable(quantity: 1,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: nil)
        XCTAssertEqual(item2.retailPrice, 349.0)
        
    }
    
    func testTotalPriceWithQuantityZero() {
        let item1 = FakePriceable(quantity: 0,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: 180.00)
        XCTAssertEqual(item1.totalPrice, 0)
    }
    
    func testTotalPriceWithQuantityNegative() {
        let item1 = FakePriceable(quantity: -3,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: 180.00)
        XCTAssertEqual(item1.totalPrice, 0)
    }
    
    func testTotalPriceWithQuantityOne() {
        let item1 = FakePriceable(quantity: 1,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: 180.00)
        XCTAssertEqual(item1.totalPrice, 499.0)
    }
    
    func testTotalPriceWithQuantityInMultiples() {
        let item1 = FakePriceable(quantity: 2,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: 180.00)
        XCTAssertEqual(item1.totalPrice, 848.0)
        
        let item2 = FakePriceable(quantity: 5,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: 180.00)
        XCTAssertEqual(item2.totalPrice, 1895.0)
    }
    
    func testTotalProfitExpectedWithQuantityZero() {
        let item1 = FakePriceable(quantity: 0,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: 180.00)
        XCTAssertEqual(item1.totalProfitExpected, 0)
    }
    
    func testTotalProfitExpectedWithQuantityInNegative() {
        let item1 = FakePriceable(quantity: -4,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: 180.00)
        XCTAssertEqual(item1.totalProfitExpected, 0)
    }
    
    func testTotalProfitExpectedWithQuantityInMultiples() {
        let item1 = FakePriceable(quantity: 4,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: 180.00)
        XCTAssertEqual(item1.totalProfitExpected, 196.0)
    }
    
    func testTotalProfitActualWithNilShippingIncurred() {
        let item1 = FakePriceable(quantity: 4,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: nil)
        XCTAssertEqual(item1.totalProfitActual, 196.0)
    }
    
    func testTotalProfitActualWithShippingIncurred() {
        let item1 = FakePriceable(quantity: 4,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: 120.0)
        XCTAssertEqual(item1.totalProfitActual, 226.0)
        
        let item2 = FakePriceable(quantity: 4,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: 150.0)
        XCTAssertEqual(item2.totalProfitActual, 196.0)
        
        let item3 = FakePriceable(quantity: 4,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: 180.00)
        XCTAssertEqual(item3.totalProfitActual, 166.0)
        
        let item4 = FakePriceable(quantity: 1,
                                  dealerPrice: 300.00,
                                  profitExpected: 49.00,
                                  shippingExpected: 150.00, shippingIncurred: 220.0)
        XCTAssertEqual(item4.totalProfitActual, -21.0)
    }
    
}
