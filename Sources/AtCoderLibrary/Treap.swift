import Foundation

// 平衡二分木を実装
final public class Treap<T: Comparable>{
    var root: TreapNode<T>?

    public init(){
        root = nil
    }

    // arrayの内容でTreapを初期化
    public init(by array: [T]) {
        root = nil
        for t in array {
            _ = insert(val: t)
        }
    }

    // 子要素の数を更新する
    func update(_ node: TreapNode<T>?) -> TreapNode<T>? {
        if let node = node  {
            node.childNodeCount = 1 + (node.left?.childNodeCount ?? 0) + (node.right?.childNodeCount ?? 0)
        }
        return node
    }

    // Treeから最大の要素のNodeを返す
    public func maxValue()-> T? {
        if var node = root {
            while node.right != nil {
                node = node.right!
            }
            return node.value
        }else {
            return nil
        }
    }

    // 複数のTreap部分木を優先度を考慮してマージする。
    // LeftのValue < RightのValueとなるのが前提条件
    public func merge(_ l: TreapNode<T>?, _ r: TreapNode<T>?) -> TreapNode<T>? {
        guard let left = l, let right = r else{
            if root == nil { root = l ?? r}
            return l ?? r
        }

        // leftのPriorityが高い場合は RootをLeftに、 RightのPriorityが高い場合はRoot を rightにする
        let newRoot =  left.priority > right.priority ? left : right
        let child =  left.priority > right.priority ? right : left
        if child === root {
            root = newRoot
        }
        // leftのPriorityが高い場合は Rootの右側にマージした結果を設定
        if left.priority > right.priority {
            newRoot.right = merge(newRoot.right, child)
        }else {
            // rightのPriorityの方が高い場合、Rootの左側にマージした結果を設定
            newRoot.left = merge(child, newRoot.left)
        }
        return update(newRoot)
    }

    // at: 引数で渡される2分木を、1..k-1番目までの部分木と k番目以降の2つの部分木に分割して返す
    public func split(_ node: TreapNode<T>?, at k: Int) -> (TreapNode<T>?, TreapNode<T>?) {
        guard let node = node else {
            return (nil,nil)
        }
        // 左部分木+自分自身のNode数
        let count = (node.left?.childNodeCount ?? 0)
        var result : (TreapNode<T>?, TreapNode<T>?)

        // k番目のターゲットが左の部分木にある場合、左の部分木のうちkよりも大きいものの集合をLeftに設定する
        if k < count {
            result = split(node.left, at: k)
            node.left = result.1
            return (update(result.0), update(node))
        }
        else if k == count{
            // k番目のターゲットがRootだった場合、左の部分木とRoot+右の部分木に分割
            let left = node.left
            node.left = nil
            return (update(left), update(node))
        }else {
            //k番目のターゲットが右の部分木にある場合、右の部分木のうちkよりも小さいものの集合をRightに設定する
            let newTarget = k - count - 1
            result = split(node.right, at: newTarget)
            node.right = result.0
            return (update(node), update(result.1))
        }
    }

    // by: 引数で渡される2分木を、valより小さい値までのの部分木と val以上の部分木の2つに分割して返す
    public func split(_ node: TreapNode<T>?,by val: T) -> (TreapNode<T>?, TreapNode<T>?) {
        guard let node = node else {
            return (nil,nil)
        }
        var result : (TreapNode<T>?, TreapNode<T>?)

        // ターゲットのvalが左の部分木にある場合、左の部分木のうちkよりも大きいものの集合をLeftに設定する
        if val < node.value {
            result = split(node.left, by: val)
            node.left = result.1
            return (update(result.0), update(node))
        }else {
            //k番目のターゲットが右の部分木にある場合、右の部分木のうちkよりも小さいものの集合をRightに設定する
            result = split(node.right, by: val)
            node.right = result.0
            return (update(node), update(result.1))
        }
    }

    // 全体の木の小さいほうから数えてK番目の要素を探す。最小の要素はK=1。
    public func findKth(K: Int) -> T? {
        return findKth(root, K: K)?.value
    }

    // 指定したノードからK番目の要素を探す
    private func findKth(_ from: TreapNode<T>?, K: Int) -> TreapNode<T>? {
        guard let from = from else{
            return nil
        }

        let NthOfRoot = 1 + (from.left?.childNodeCount ?? 0)
        if K < NthOfRoot {
            return findKth(from.left, K: K)
        }
        else if K > NthOfRoot {
            let newK = K - NthOfRoot
            return findKth(from.right, K: newK)
        }else{
            return from
        }
    }

    // 2分木から引数Value以上の値を検索し、2分木中で小さい方から何番目の要素かと合わせて返す
    public func lowerBound(_ value: T) -> (value: T?, position: Int?) {
        let target = _lowerBound(from: root, value: value, at: 0)
        return (target.node?.value, target.position)
    }

    // 部分木から検索する場合は fromに部分木のRoot, atに0を指定して呼び出し
    private func _lowerBound(from: TreapNode<T>?, value: T, at k: Int ) -> (node: TreapNode<T>?, position: Int?) {
        guard let from = from else{
            return (nil,nil)
        }
        var childSearchResult: (TreapNode<T>?, Int?)
        var resultOnThisNode:(TreapNode<T>?, Int?) = (nil,nil)

        // 対象要素がFrom自体のValueに一致、もしくはまたは左の部分木に存在する場合、左の部分木を検索する
        if value <= from.value {
            childSearchResult = _lowerBound(from: from.left, value: value, at: k)
            let sum = k + 1 + (from.left?.childNodeCount ?? 0)
            resultOnThisNode = (from, sum)
        } else {
            // 対象要素が右の部分木に存在する場合、左部分木の数 + 1を加える
            let newPosition = k + 1 + (from.left?.childNodeCount ?? 0)
            childSearchResult = _lowerBound(from: from.right, value: value, at: newPosition)
        }
        // 左右いずれかの部分木でLowerBoundの条件を満たすNodeがある場合はそちらを返す
        if childSearchResult.0 != nil {
            return childSearchResult
        }else {
            return resultOnThisNode
        }
    }
    
    // 2分木から引数Valueよりも大きい値を検索し、2分木中で小さい方から何番目の要素かと合わせて返す
    public func upperBound(_ value: T) -> (value: T?, position: Int?) {
        let target = _upperBound(from: root, value: value, at: 0)
        return (target.node?.value, target.position)
    }

    // 部分木から検索する場合は fromに部分木のRoot, atに0を指定して呼び出し
    private func _upperBound(from: TreapNode<T>?, value: T, at k: Int ) -> (node: TreapNode<T>?, position: Int?) {
        guard let from = from else{
            return (nil,nil)
        }
        var childSearchResult: (TreapNode<T>?, Int?)
        var resultOnThisNode:(TreapNode<T>?, Int?) = (nil,nil)

        // 対象要素がFrom自体のValueに一致、もしくはまたは左の部分木に存在する場合、左の部分木を検索する
        if value < from.value {
            childSearchResult = _upperBound(from: from.left, value: value, at: k)
            let sum = k + 1 + (from.left?.childNodeCount ?? 0)
            resultOnThisNode = (from, sum)
        } else {
            // 対象要素が右の部分木に存在する場合、左部分木の数 + 1を加える
            let newPosition = k + 1 + (from.left?.childNodeCount ?? 0)
            childSearchResult = _upperBound(from: from.right, value: value, at: newPosition)
        }
        // 左右いずれかの部分木でLowerBoundの条件を満たすNodeがある場合はそちらを返す
        if childSearchResult.0 != nil {
            return childSearchResult
        }else {
            return resultOnThisNode
        }
    }

    // 2分木で指定されたValueのひとつ前の値を取得する
    public func previous(of value: T) -> T? {
        let node = lowerBound(value)
        var Kth: Int

        // lowerBoundで検索されたNodeが何番目かを取得。Nilの場合はノード全体
        if let pos = node.position {
            Kth = pos-1
        }else{
            // LowerBoundが値を探せなかった場合は、最も大きい値を返す
            Kth = root?.childNodeCount ?? 0
        }
        // Lowerboundで見つけた値のひとつ前を検索する
        return findKth(root, K: Kth)?.value
    }

    // val TをInsertする。
    public func insert(val: T) -> TreapNode<T>? {
        let newNode = TreapNode<T>(val:val)
        let (left,right) = split(root, by: val)

        let leftnew = update(merge(left,newNode))
        let all = update(merge(leftnew,right))
        return all
    }

    // 2分木のk番目に要素をinsertする.
    public func insert(_ node: TreapNode<T>?, val: T, at k: Int) -> TreapNode<T>? {
        let newNode = TreapNode<T>(val:val)
        let (left,right) = split(node, at: k)

        let leftnew = update(merge(left,newNode))
        let all = merge(leftnew,right)
        return update(all)
    }

    // k番目の要素を削除し、削除された要素の値を返す。(要素は1始まり)
    public func delete(_ node: TreapNode<T>?, at k: Int) -> T? {
        let (leftDel, right) = split(node, at: k+1)
        let (left, del) = split(leftDel, at: k)
        // 削除対象がrootだった場合は固定でRightをRootにする.LeftとのMergeで最大PriorityがRootになることは担保できる
        if del === root {
            root = right
        }
        _ = merge(left, right)
        return del?.value
    }

    // valueを指定して削除す、削除された要素の値を返す。指定したvalueが存在しない場合はnilを返す。
    public func delete(_ node: TreapNode<T>?, val: T) -> T? {
        let result = lowerBound(val)
        if result.value == val {
            // valがTreap内で見つかった場合
            return delete(root, at: result.position!)
        }else {
            //指定された値が存在しない場合
            return nil
        }
    }

    // 全要素を昇順に並べたArrayに変換して返す
    public func toArray(node: TreapNode<T>?) -> [T] {
gi        var array = [T]()
        guard let node = node else {
            return array
        }

        if let left = node.left {
            array += toArray(node: left)
        }
        array.append(node.value)
        if let right = node.right {
            array += toArray(node: right)
        }
        return array
    }
}

// 2分木の要素にあたるクラス
final public class TreapNode<T: Comparable>:Equatable {
    var priority: Double // Priorityが高いものほどRootに近い
    var value: T // 値
    var childNodeCount: Int // 自身を含めた部分木の要素の合計

    var left: TreapNode?
    var right: TreapNode?

    init(val: T) {
        value = val
        childNodeCount = 1
        priority = drand48()
    }

    public static func == (l: TreapNode, r: TreapNode) -> Bool {
        return l.priority == r.priority && l.value == r.value
    }
}
