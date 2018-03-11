## 其他

- 合约是中介：由于调用函数的动作是在挖矿时执行的，所以Solidity 没有原生定时器，不通过合约本身自动触发函数执行。应该将合约看做一个中介，需要外部来触发合约函数的执行。

- 本地状态变量声明提升：类似于 JS 用 `val` 声明变量。

```
contract SimpleStorage {
    function set(uint data){
        if (true) {
            uint temp = 1; // 本地状态变量
        }
        uint temp; // 报错，因为声明本地状态变量的作用域是函数，而不是 {}。
    }
}
```