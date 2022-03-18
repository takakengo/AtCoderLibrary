//
//  Permutation.swift
//  Created by Kengo on 2021/09/09.
//

extension Sequence {
    func permutations() -> [[Element]] {
        func _permutations<T>(of values: [T], indices: Range<Int>, result: inout [[T]]) {
            if indices.isEmpty {
                result.append(values)
                return
            }
            var values = values
            for i in indices {
                values.swapAt(indices.lowerBound, i)
                _permutations(of: values, indices: (indices.lowerBound + 1) ..< indices.upperBound, result: &result)
            }
        }
        
        var result: [[Element]] = []
        let values = Array(self)
        _permutations(of: values, indices: values.indices, result: &result)
        return result
    }
}


extension Array {
    // もとの配列要素を順列組み合わせで全パターンを配列として返す
    public func permutation() -> [Self] {
        guard self.count > 0 else {
            return []
        }
        var result = [Self]()
        subPermutation(self, after: 0, &result)
        return result
    }

    // target: 順列並び替えの元になる配列
    // after:　Targetのうち、Afterで指定されたIndex以降の要素を順列並び替えしたパターンを作成して返す
    private func subPermutation(_ target: Self, after startIndex: Int, _ result: inout [Self]) {
        
        if startIndex >= target.count-1 {
            result.append(target)
            return
        }

        var target = target
        // startIndexの位置で、残る文字列の全パターンを網羅する
        for i in startIndex..<target.count {
            target.swapAt(startIndex, i)
            subPermutation(target, after: startIndex+1, &result)
        }
        return
    }
}
