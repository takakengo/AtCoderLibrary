import Foundation
import AtCoderLibrary

//let MOD = 1000000007
let MOD = 998244353

//-------------------- Input読み込み用の関数の呼び出し --------------------//
//let Q = readInt() // "1" -> 1
//let (N,K) = read2Ints() // "1 2" -> (1,2)
//let (M,L,W) = read3Ints() // "1 2 3" -> (1,2,3)
//let (M,L,W,X) = read3Ints() // "1 2 3 4" -> (1,2,3,4)
//let T = readStringArray() // "abc" -> ["a","b","c"]
//let An = readIntArray() // "1 2 3 4" -> [1,2,3,4]

let N = readInt()
var s = "Less than 100"

if N >= 100 {
    print("not less than 100")
}else{
    print(s)
}
var t = Treap<Int>()

//--------------- Input読み込み用の関数 --------------------//
func readStringArray() -> [String] {
    return readLine()!.split(separator: " ").map {String($0) }
}

func readIntArray() -> [Int] {
    return readLine()!.split(separator: " ").map{ Int(String($0))! }
}

func readInt() -> Int {
    return Int(readLine()!)!
}

func read2Ints() -> (x: Int, y: Int) {
    let ints = readLine()!.split(separator: " ").map{ Int(String($0))!}
    return (x: ints[0], y: ints[1])
}

func read3Ints() -> (a: Int, b: Int, c: Int) {
    let ints = readLine()!.split(separator: " ").map{ Int(String($0))!}
    return (a: ints[0], b: ints[1], c: ints[2])
}

func read4Ints() -> (a: Int, b: Int, c: Int, d: Int) {
    let ints = readLine()!.split(separator: " ").map{ Int(String($0))!}
    return (a: ints[0], b: ints[1], c: ints[2], d:ints[3])
}

func readIntArrayMinus1() -> [Int] {
    return readLine()!.split(separator: " ").map{ Int(String($0))! - 1}}

func readIntMinus1() -> Int {
    return Int(readLine()!)! - 1
}

func read2IntsMinus1() -> (a: Int, b: Int) {
    let ints = readLine()!.split(separator: " ").map{ Int(String($0))!}
    return (a: ints[0]-1, b: ints[1]-1)
}

func read3IntsMinus1() -> (a: Int, b: Int, c: Int) {
    let ints = readLine()!.split(separator: " ").map{ Int(String($0))!}
    return (a: ints[0]-1, b: ints[1]-1, c: ints[2]-1)
}

func read4IntsMinus1() -> (a: Int, b: Int, c: Int, d: Int) {
    let ints = readLine()!.split(separator: " ").map{ Int(String($0))!}
    return (a: ints[0]-1, b: ints[1]-1, c: ints[2]-1, d:ints[3]-1)
}

