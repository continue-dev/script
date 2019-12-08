# script Rabbit
swift上で動かすscript言語のコンパイラを作るプロジェクトです。  
scriptの拡張子は.jumpにすることに仮決めしてます。  
Rabbitクラスにscript.jumpファイルを読み込ませてrunさせます。  
## 現状
・メソッド名を識別出来る  
・変数名を識別出来る  
・引数を識別出来る
・print()メソッドでデバッグ表示出来る  
・SwiftからonTouchDown()で値を送信  
・scriptからjumpToHostLanguage()で値を受信  
## 次の課題
・return命令の実装  
・メソッドの中身をパースするのと実行を分ける  
・クラスを作れるようにする  
## contributors募集中
一緒に作ってくれる人募集してます。Swiftが書ければ多分問題ないので気軽にプルリクエスト送ってみてください。ソースのプルリクするのはちょっとためらう、というような人は、このREADME.mdに「hello」とかを追記するだけでも意思確認出来ます。
