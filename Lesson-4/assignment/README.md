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

答:
juicebox@juicebox:~/payroll$ truffle test
Using network 'development'.

Compiling ./contracts/Ownable.sol...
Compiling ./contracts/Payroll.sol...
Compiling ./contracts/SimpleStorage.sol...
Compiling ./test/TestSimpleStorage.sol...
Compiling truffle/Assert.sol...
Compiling truffle/DeployedAddresses.sol...


  TestSimpleStorage
    ✓ testItStoresAValue (63ms)

  Contract: Payroll
    ✓ ...addEmployee with salary 2. (88ms)

  Contract: Payroll
    ✓ Test getPaid() (294ms)

  Contract: SimpleStorage
    ✓ ...should store the value 89. (61ms)

  Contract: Payroll
    ✓ Test call addEmployee() and removeEmployee by owner (106ms)
    ✓ Test remove a non-existent employee


  6 passing (1s)

