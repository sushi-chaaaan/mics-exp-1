
# MICS実験 J2

| 学籍番号 |    氏名    |
| :------: | :--------: |
| 22103421 | 鈴木謙太郎 |

## 問題1

### モジュールeqの動作検証

講義資料で示されたモジュールeqを、同じく示されたeqSimを用いてシミュレーションした。その結果は下のようになった。

```plaintext
VCD info: dumpfile eq.vcd opened for output.
 x y s time
 0 0 1         0
 0 1 0        50
 1 0 0       100
 1 1 1       150
eqSim.v:15: $finish called at 200 (1s)
```

このシミュレーションはすべての入力例をカバーしており、x=yのときのみs=1となることが確認できている。

### eqSimモジュールの改良

eqSimモジュールを以下のように改良し、内部のs1とs2を表示するようにした。

```v
module eqSim; /* 一致検出回路の */
    wire s; /* シミュレーション */
    reg x, y;
    eq g1(s, x, y);
    initial
        begin
        $dumpfile("eq.vcd");
        $dumpvars(0, eqSim);
        $monitor(" %b %b  %b  %b %b", x, y,  g1.s1, g1.s2,s, $stime);
        $display(" x y s1 s2 s       time");
        x=0; y=0;
        #50 y=1;
        #50 x=1; y=0;
        #50 y=1;
        #50 $finish;
        end
endmodule
```

このときの出力は下のようになった。

```bash
VCD info: dumpfile eq.vcd opened for output.
 x y s1 s2 s       time
 0 0  0  1 1         0
 0 1  0  0 0        50
 1 0  0  0 0       100
 1 1  1  0 1       150
eqSim.v:15: $finish called at 200 (1s)
```

これにより、内部的にもs1とs2が正しく計算され、s1|s2から期待されるsが出力されていることが確認できた。

## 問題2

入力信号 a, b, c, d を受け取り，a = b とc = d がともに成り立
つとき出力信号sを1に，それ以外のときsを0にする回路の
モジュールdoubleEqを次のように作成した。

```v
module doubleEq(
    s,a,b,c,d
);
    input a, b, c, d;
    output s;
    wire w1, w2;
    eq m1(w1, a, b);
    eq m2(w2, c, d);
    assign s = w1 & w2;
endmodule
```

## 問題3

[問題2](#eqsimモジュールの改良)で作成したdoubleEqモジュールをシミュレーションするdoubleEqSimモジュールを以下のように作成した。

```v
module doubleEqSim; /* 一致検出回路の */
    wire s; /* シミュレーション */
    reg a, b, c, d;
    doubleEq g1(s, a, b, c, d);
    initial
        begin
        $dumpfile("doubleEq.vcd");
        $dumpvars(0, doubleEqSim);
        $monitor(" %b %b %b %b  %b  %b  %b", a, b, c, d, s, g1.w1, g1.w2, $stime);
        $display(" a b c d w1 w2  s      time");
        /* test all case */
        a=0; b=0; c=0; d=0;
        #50 a=0; b=0; c=0; d=1;
        #50 a=0; b=0; c=1; d=0;
        #50 a=0; b=0; c=1; d=1;
        #50 a=0; b=1; c=0; d=0;
        #50 a=0; b=1; c=0; d=1;
        #50 a=0; b=1; c=1; d=0;
        #50 a=0; b=1; c=1; d=1;
        #50 a=1; b=0; c=0; d=0;
        #50 a=1; b=0; c=0; d=1;
        #50 a=1; b=0; c=1; d=0;
        #50 a=1; b=0; c=1; d=1;
        #50 a=1; b=1; c=0; d=0;
        #50 a=1; b=1; c=0; d=1;
        #50 a=1; b=1; c=1; d=0;
        #50 a=1; b=1; c=1; d=1;
        end
endmodule
```