## 硅谷live以太坊智能合约 第四课作业
这里是同学提交作业的目录

### 第四课：课后作业
- 将第三课完成的payroll.sol程序导入truffle工程
- 在test文件夹中，写出对如下两个函数的单元测试：
- function addEmployee(address employeeId, uint salary) onlyOwner
- function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId)
- 思考一下我们如何能覆盖所有的测试路径，包括函数异常的捕捉
- (加分题,选作）
- 写出对以下函数的基于solidity或javascript的单元测试 function getPaid() employeeExist(msg.sender)
- Hint：思考如何对timestamp进行修改，是否需要对所测试的合约进行修改来达到测试的目的？

作业：
这周工作事情比较多，作业完成的比较仓促，老师见谅！
由于js不熟，最开始尝试用solidity写，但发现问题较多，而且同学们都在讨论js的问题，所以参考同学的问答信息该用js写，勉强写了一个基础test。

测试的结果如下：
juicebox@juicebox:~/payroll$ truffle test
Using network 'development'.

Compiling ./contracts/Ownable.sol...
Compiling ./contracts/SafeMath.sol...
Compiling ./contracts/payroll.sol...


  Contract: Payroll
    ✓ Test addEmployee() (207ms)
    ✓ Test removeEmployee() (398ms)

  Contract: SimpleStorage
    ✓ ...should store the value 89. (178ms)


  3 passing (971ms)
