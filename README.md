# scrhd-ja
Pimoroni の Scroll pHAT HD 用の日本語フォントとツール

## 使い方

Scroll pHAT HD を使うスクリプトと同じディレクトリに misaki_gothic.py を置いて `import misaki_gothic` するだけです。

明朝体の場合は misaki_mincho.py を置いて `import misaki_mincho` します。

## 高度な使い方

`/usr/lib/python2.7/dist-packages/scrollphathd/fonts/` に misaki_gothic.py や misaki_mincho.py を置きます。
すると、スクリプトの置き場によらず 
`from scrollphathd.fonts import misaki_gothic.py`
`from scrollphathd.fonts import misaki_minchoc.py`
で日本語フォントが呼び出せます。


## 使用例

* koedo.py
    * 「小江戸らぐ」という文字列が無限スクロールします。
* unicode-ja.py
    * 引数として与えた文字列（引数なしの場合は「かいぞくロボにんじゃさる」）という文字列が無限スクロールします。
* startup-koedo.sh
    * Scroll pHAT HD が接続されていたら koedo.py を呼び出す Shell Script です。cron で @reboot 指定で呼ぶなどの利用が便利でしょう。
    
## 上級者向けツール
* bdfuni2pyfont.pl
    * [モナーフォント](http://monafont.sourceforge.net)付属の `jis2unicode` で文字コードを変換した美咲フォントBDFファイルを食わせて `misaki_(gothic|mincho).py` を作成するPerlスクリプトです。
* bdfjis2pyfont.pl
    * 素の美咲フォントBDFファイルを食わせて `misaki_(gothic|mincho).py` を作成するPerlスクリプトです。
    * JIS X 0208 から外れる文字列（丸付き数字①や組み文字㍼など）は存在しない文字として 0x0000FFFD に変換されてしまいます。
    * 美咲フォントは JIS X 0213 からも外れる文字があるため、Encode::JIS2K を使っても完全には変換できません。

## 制限事項

U+3001 以降の文字しか収録していません。つまり1バイト英数字がありません。これらの文字列を食わせても表示が出ません。

## VS.

[Raspberry PiのScroll pHat HDで、日本語のメッセージを流すやつ](https://github.com/moguno/scroll_phat_hd-japanese-ticker)
も美咲フォントによる日本語表示ですが、もっと高度なサンプルがあること、フォントは毎回PNG形式から生成している点が異なります。

## Licence

[MIT](https://github.com/tcnksm/tool/blob/master/LICENCE)です。

なお、misaki_gothic.py は美咲フォントを変換したものです。
美咲フォントのライセンスは (http://www.geocities.jp/littlimi/font.htm#license) を参照してください。 

## Author

[lilyfan](https://github.com/lilyfan)
