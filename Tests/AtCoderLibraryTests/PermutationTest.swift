//
//  PermutationTest.swift
//  
//
//  Created by Kengo on 2022/02/23.
//

import XCTest
@testable import AtCoderLibrary

class PermutationTest: XCTestCase {
    var small : [Int]!
    var large : [Int]!
    
    override func setUp() {
        super.setUp()
        small = [3,2,1,5,4]
        large = [10,20,30,40,50,60,70,80,90]
    }

    func testPermutation_small() {
        let result: [[Int]] = small.permutation()
        let set = Set<[Int]>(result)
        var lengthCheck = true
        for r in result {
            lengthCheck = lengthCheck && r.count == 5
        }
        XCTAssertTrue(lengthCheck)
        XCTAssertEqual(set.count, 5*4*3*2)
    }

    func testPermutation_large() {
        let result: [[Int]] = large.permutation()
        let set = Set<[Int]>(result)
        var lengthCheck = true
        for r in result {
            lengthCheck = lengthCheck && r.count == 9
        }
        XCTAssertTrue(lengthCheck)
        let expectedPatternCount = 1*2*3*4*5*6*7*8*9
        XCTAssertEqual(set.count, expectedPatternCount)
    }

    func testPerformance() throws {
        self.measure {
            _ = large.permutation()
        }
    }

}
