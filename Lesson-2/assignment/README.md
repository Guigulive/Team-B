## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

作业：
1、记录的gas值见后面，每次都在增多（除了addEmployee的第1、2次见有诡异的减少，是因为第一次有什么额外的初始化操作消耗了gas？），应该是由于employees数组增大导致计算消耗增多的原因。
2、优化见代码：把totalsalary的计算放在了每次addEmployee是做，这个能降低calculateRunway的gas消耗，但是会增加add的gas消耗

No. 1
addEmployee
 transaction cost 	105206 gas 
 execution cost 	82334 gas 
calculateRunway
 transaction cost 	22966 gas 
 execution cost 	1694 gas 

No. 2
addEmployee
 transaction cost 	91047 gas 
 execution cost 	68175 gas 
calculateRunway
 transaction cost 	23747 gas 
 execution cost 	2475 gas 

No.3
addEmployee
 transaction cost 	91888 gas 
 execution cost 	69016 gas
calculateRunway
 transaction cost 	24528 gas 
 execution cost 	3256 gas 
No.4 
addEmployee
  transaction cost 	92729 gas 
 execution cost 	69857 gas 
calculateRunway
  transaction cost 	25309 gas 
 execution cost 	4037 gas 

5
addEmployee
  transaction cost 	93570 gas 
 execution cost 	70698 gas 
calculateRunway
  transaction cost 	26090 gas 
 execution cost 	4818 gas 

6 
addEmployee
 transaction cost 	94347 gas 
 execution cost 	71539 gas   
calculateRunway
 transaction cost 	26871 gas 
 execution cost 	5599 gas 

 7
addEmployee
 transaction cost 	95252 gas 
 execution cost 	72380 gas 
calculateRunway
 transaction cost 	27652 gas 
 execution cost 	6380 gas 

 8
addEmployee
 transaction cost 	96029 gas 
 execution cost 	73221 gas 
calculateRunway
 transaction cost 	28433 gas 
 execution cost 	7161 gas 
9
addEmployee
transaction cost 	96934 gas 
 execution cost 	74062 gas 
calculateRunway
 transaction cost 	29214 gas 
 execution cost 	7942 gas 

 10
addEmployee
transaction cost 	97775 gas 
 execution cost 	74903 gas
calculateRunway
 transaction cost 	29995 gas 
 execution cost 	8723 gas 