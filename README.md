# AtCoderLibrary
ここでは競技プログラミング用のSwiftソースコードを公開しています。 

Swift AtCoder Library is a toolset which supports participants of competitive programming contest (e.g. AtCoder).  

## Installation 
```
git clone https://github.com/takakengo/Swift-AtCoder-Library.git
open Swift-AtCoder-Library/Package.swift
```

## Functions
1.  平衡二分木 (Treap) / Balanced Binary Tree 
Treapによる平衡二分木のSwift 実装です。
- 任意の要素の追加/検索/削除をO(logN)で実行します。
- 検索は"Xに一致するもの" 以外にも、要素中からX以上の最小値も利用可能です。(C++のStd::set が提供するlower_bound(X))

Treap offers Insert/Find/Delete of its elements by O(logN). It also offers splitting/merging of Treap trees. 

---- to be added  ---- 
2.  優先度付キュー / Priority Queue

3. 順列 (Permutation)
配列を渡すと、その配列の要素を並び替えて作れる全パターンの組み合わせ（順列組み合わせ）を返します。配列に複数同じ要素があっても、それぞれ別のものとして区別されます。
`[1,2,3] -> [ [1,2,3] , [1,3,2], [2,1,3], [2,3,1], [3,1,2] ,[3,2,1] ]`


##  Swift in a Competitive Programming 
競技プログラミングの参加者の多くは言語としてC++を選択していますが、 Swiftを使って競技に参加することは十分に可能だと考えています。

競技プログラミングでは各問題ごとに所定の実行時間以内で解答を出すことが求められるため、言語処理系の実行時間は非常に重要です。

Swiftは実行速度も早い部類に入りますし、Pythonなどのスクリプト言語とは違いコンパイラによる支援も得られますので、競プロを始める初級者には良い言語選択と言えるのではないのでしょうか。

一方、C++では標準ライブラリで提供される機能がSwiftには存在せず、自分で実装する必要があります。例えばstd::setのlower_boundを使うような問題では、Swift参加者では追加の実装を持っていなければ回答が難しいケースがあります。

このライブラリの実装が何かの参考になればと思います。もし実装の問題点やバグなどがあれば Twitter/@takakengo までお知らせいただけると幸いです。

公開されているソースコードは改変含めて自由に利用いただけますが、自己責任でご利用ください。

CC0
