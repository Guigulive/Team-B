## 硅谷live以太坊智能合约 第三课作业
这里是同学提交作业的目录

### 第三课：课后作业
- 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
- 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2

作业：
-- 第一题：
addEmployee：
decoded input 	{
	"address employeeId": "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c",
	"uint256 salary": "1"
}
decoded output 	{}

addFund：
decoded input 	{}
 decoded output 	{
	"0": "uint256: fund 50000000000000000000"
}
 logs 	[]
 value 	50000000000000000000 wei

calculateRunway:
 decoded input 	{}
 decoded output 	{
	"0": "uint256: runway 50"
}

getPaid : //间隔时间比较长，一次拿了多个周期工资
 decoded input 	{}
 decoded output 	{}

再次执行calculateRunway:
decoded output 	{
	"0": "uint256: runway 5"
}

hasEnoughFund :
decoded output 	{
	"0": "bool: true"
}

removeEmployee:第一次时发生薪水不够支付，报错，addFund后完成
decoded input 	{
	"address employeeId": "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c"
}
 decoded output 	{}

transferOwnership :
decoded input 	{
	"address newOwner": "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db"
}
 decoded output 	{}

再addEmployee后updateEmployee：
decoded input 	{
	"address employeeId": "0xca35b7d915458ef540ade6068dfe2f44e8fa733c",
	"uint256 salary": "2"
}
 decoded output 	{}

employees["0xca35b7d915458ef540ade6068dfe2f44e8fa733c"] :
0: address: id 0xca35b7d915458ef540ade6068dfe2f44e8fa733c
1: uint256: salary 2000000000000000000
2: uint256: lastPayday 1521606779

owner:
0: address: 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db

-- 第二题 ：
   见your.sol代码

-- 第三题：
   继承线为：Z,K2,C,K1,B,A,O
