//
//  Treap Test
//  Created by Kengo on 2022/02/25.
//

import XCTest
@testable import AtCoderLibrary

class TreapTest: XCTestCase {
    struct TreeInfo<T: Comparable>{
        var isHealthy: Bool
        var maxValue: T
        var minValue: T
        var maxPriority: Double
    }
    
    // TreapはNodeが持つ優先度だけ見るとヒープ（親が常に子よりも大きい）、Nodeが持つ値だけ見ると2分木になるので、それを再起的に検証する
    func validateHealth<T: Comparable>(of node: TreapNode<T>) -> TreeInfo<T> {
        var nodeInfo = TreeInfo<T>(isHealthy: true, maxValue: node.value, minValue: node.value, maxPriority: node.priority)
        
        if let l = node.left {
            let left = validateHealth(of: l)
            nodeInfo.isHealthy = nodeInfo.isHealthy && left.isHealthy
            nodeInfo.isHealthy = nodeInfo.isHealthy && (left.maxPriority <= node.priority)
            nodeInfo.isHealthy = nodeInfo.isHealthy && (left.maxValue <= node.value)
            nodeInfo.minValue = left.minValue
        }
        
        if let r = node.right{
            let right = validateHealth(of: r)
            nodeInfo.isHealthy = nodeInfo.isHealthy && right.isHealthy
            nodeInfo.isHealthy = nodeInfo.isHealthy && (right.maxPriority <= node.priority)
            nodeInfo.isHealthy = nodeInfo.isHealthy && (right.minValue >= node.value)
            nodeInfo.maxValue = right.maxValue
        }
        return nodeInfo
    }

    
    func testMerge(){
        let SIZE = 200
 
        var input = Array(1...SIZE)
        input.shuffle()
        let treap1 = Treap.init(by: input)

        var input2 = Array(SIZE+1...SIZE*2)
        input2.shuffle()
        let treap2 = Treap.init(by: input2)

        _ = treap1.merge(treap1.root, treap2.root)
        XCTAssertTrue(validateHealth(of: treap1.root!).isHealthy)
    }

    func testSplit(){
        let SIZE = 200
        var input = Array(1...SIZE)
        input.shuffle()
        let treap = Treap.init(by: input)
        
        let (treap1,treap2) = treap.split(treap.root, at: 100)
        XCTAssertTrue(validateHealth(of: treap1!).isHealthy)
        XCTAssertTrue(validateHealth(of: treap2!).isHealthy)
    }

    // 2分木から引数で与えられた数値より小さい値を返す
    func testPrevious(){
        var input = Array(stride(from: 10, to: 10001, by: 10))
        input.shuffle()
        let treap = Treap<Int>(by: input)
        
        XCTAssertEqual(treap.previous(of: 10001), 10000)
        XCTAssertEqual(treap.previous(of: 10000), 9990)
        XCTAssertEqual(treap.previous(of: 1000), 990)
        XCTAssertEqual(treap.previous(of: 10), nil)
        XCTAssertEqual(treap.previous(of: 1), nil)
    }

    func testToArray(){
        var input = Array(stride(from: 10, to: 10001, by: 10))
        input.shuffle()
        let treap = Treap<Int>(by: input)
        let result = treap.toArray()
        
        XCTAssertEqual(result, input.sorted(by: <))
    }

    // Valの大小で比較してTreapを構築する
    func testValueBasedOperations(){
        var input = Array(stride(from: 10, to: 10001, by: 10))
        input.shuffle()
        let treap = Treap<Int>(by: input)
        XCTAssertTrue(validateHealth(of: treap.root!).isHealthy)

        // 初期状態
        XCTAssertEqual(treap.findKth(K: 1), 10)
        XCTAssertEqual(treap.findKth(K: 100), 1000)
        XCTAssertEqual(treap.findKth(K: 1000), 10000)
        XCTAssertEqual(treap.lowerBound(5001).value, 5010)
        XCTAssertEqual(treap.lowerBound(5001).position, 501)
        XCTAssertEqual(treap.lowerBound(4999).value, 5000)
        XCTAssertEqual(treap.lowerBound(4999).position, 500)

        //　最小値を挿入
        treap.insert(val: 5)
        XCTAssertEqual(treap.lowerBound(2).value, 5)
        XCTAssertEqual(treap.upperBound(2).value, 5)
        XCTAssertEqual(treap.lowerBound(10).value, 10)
        XCTAssertEqual(treap.upperBound(10).value, 20)

        XCTAssertEqual(treap.findKth(K: 1), 5)
        XCTAssertEqual(treap.findKth(K: 2), 10)
        XCTAssertEqual(treap.findKth(K: 101), 1000)
        XCTAssertEqual(treap.findKth(K: 1001), 10000)
        
        //　最大値を挿入
        treap.insert(val: 99999)
        XCTAssertEqual(treap.findKth(K: 2), 10)
        XCTAssertEqual(treap.findKth(K: 101), 1000)
        XCTAssertEqual(treap.findKth(K: 1001), 10000)
        XCTAssertEqual(treap.findKth(K: 1002), 99999)

        //　中間値を挿入
        treap.insert(val: 1001)
        XCTAssertEqual(treap.findKth(K: 2), 10)
        XCTAssertEqual(treap.findKth(K: 101), 1000)
        XCTAssertEqual(treap.findKth(K: 102), 1001)
        XCTAssertEqual(treap.findKth(K: 103), 1010)
        XCTAssertEqual(treap.findKth(K: 1002), 10000)

       //　最小値を削除
        treap.delete(val: 5)
        XCTAssertEqual(treap.findKth(K: 1), 10)
        XCTAssertEqual(treap.findKth(K: 2), 20)
        XCTAssertEqual(treap.findKth(K: 100), 1000)
        XCTAssertEqual(treap.findKth(K: 1001), 10000)
        
        //　最大値を削除
        treap.delete(val: 99999)
        XCTAssertEqual(treap.findKth(K: 1), 10)
        XCTAssertEqual(treap.findKth(K: 100), 1000)
        XCTAssertEqual(treap.findKth(K: 1001), 10000)
        XCTAssertEqual(treap.findKth(K: 1002), nil)

        //　中間値を挿入
        treap.delete(val: 1001)
        XCTAssertEqual(treap.findKth(K: 1), 10)
        XCTAssertEqual(treap.findKth(K: 100), 1000)
        XCTAssertEqual(treap.findKth(K: 101), 1010)
        XCTAssertEqual(treap.findKth(K: 1000), 10000)
    }
    
    // Valの大小で比較するのではなく、Atで指定したx番目という数字だけでTreapを操作
    func testPositionBasedOperations(){
        let treap = Treap<String>()
        treap.insert(treap.root, val: "abc", at: 1)
        treap.insert(treap.root, val: "zzz", at: 2)
        treap.insert(treap.root, val: "yyy", at: 3)
        XCTAssertEqual(treap.findKth(K: 1), "abc")
        XCTAssertEqual(treap.findKth(K: 2), "zzz")
        XCTAssertEqual(treap.findKth(K: 3), "yyy")
        
        treap.insert(treap.root, val: "ddd", at: 2)
        XCTAssertEqual(treap.findKth(K: 1), "abc")
        XCTAssertEqual(treap.findKth(K: 2), "ddd")
        XCTAssertEqual(treap.findKth(K: 3), "zzz")
        XCTAssertEqual(treap.findKth(K: 4), "yyy")

        treap.delete(at: 1)
        XCTAssertEqual(treap.findKth(K: 1), "ddd")
        XCTAssertEqual(treap.findKth(K: 2), "zzz")
        XCTAssertEqual(treap.findKth(K: 3), "yyy")
        XCTAssertEqual(treap.findKth(K: 4), nil)

        treap.insert(treap.root, val: "fff", at: 1000000)
        XCTAssertEqual(treap.findKth(K: 1), "ddd")
        XCTAssertEqual(treap.findKth(K: 2), "zzz")
        XCTAssertEqual(treap.findKth(K: 3), "yyy")
        XCTAssertEqual(treap.findKth(K: 4), "fff")
        
        // Atで指定して操作する場合はValueは二分木とならないため、Falseとなる
        XCTAssertFalse(validateHealth(of: treap.root!).isHealthy)
    }
    
    // 子要素の数を更新する
    func testUpdate() {
        let treap = Treap<Int>()
        let SIZE = 100
        for i in 1...SIZE{
            treap.insert(val: i)
        }
        XCTAssertEqual(countChildren(treap.root!), SIZE)

        func countChildren(_ node: TreapNode<Int>) -> Int {
            var childCount = 1

            if let left = node.left {
                childCount += countChildren(left)
            }
            if let right = node.right{
                childCount += countChildren(right)
            }
            XCTAssertEqual(node.childNodeCount, childCount)
            return childCount
        }
    }


    
}


