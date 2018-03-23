第三课：课后作业

第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
```
/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    using SafeMath for uint;
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    uint totalSalary = 0 ;
    address owner;
    uint constant payDuration=10 seconds;
    mapping(address => Employee) public employees;
    
    modifier employeeExist(address employeeId){
        var employee=employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    function _partialPaid(Employee employee) private{
        uint payMent=employee.salary.mul(now.sub(employee.lastPayday).div(payDuration));
        employee.id.transfer(payMent);
    }
     
    function addFund() payable public returns (uint) {
       
    }
   
    function addEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) public{
        var employee = employees[employeeId];
        employees[employeeId]=Employee(employeeId,salary.mul(1 ether),now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
   
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public{
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }
   
     function updateEmployee(address employeeId ,uint salary) onlyOwner employeeExist(employeeId) public{
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = salary.mul(1 ether);
        employees[employeeId].lastPayday=now;
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
     
     function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        uint nextPayday=employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
     }
     
     function calculateRunway() returns (uint){
         return this.balance.div(totalSalary);
     }
     
     function hasEnoughFund() returns (bool){
         return calculateRunway() >0;
     }
}
```
测试一：addEmployee


测试二：removeEmployee


测试三：updateEmployee


测试四：getPaid

测试五：calculateRunway




第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能

```
pragma solidity ^0.4.14;
import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    using SafeMath for uint;
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    uint totalSalary = 0 ;
    uint constant payDuration=10 seconds;
    mapping(address => Employee) public employees;
    
    modifier employeeExist(address employeeId,bool contain){
        Employee employee = employees[employeeId];
        if(contain){
            assert(employee.id != 0x0);
        }else{
            assert(employee.id == 0x0);    
        }
        
        _;
    }
    modifier changeAddress(address employeeOldId,address employeeNewId){
        employees[employeeNewId] =employees[employeeOldId];
        employees[employeeNewId].id=employeeNewId;
        delete employees[employeeOldId];
        _;
    }
    
    
    function _partialPaid(Employee employee) private{
        uint payMent=employee.salary.mul(now.sub(employee.lastPayday).div(payDuration));
        employee.id.transfer(payMent);
    }
     
    function addFund() payable public returns (uint) {
       
    }
   
    function addEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId,false) public{
        employees[employeeId]=Employee(employeeId,salary.mul(1 ether),now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
   
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId,true) public{
        Employee employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }
   
    function updateEmployee(address employeeId ,uint salary) onlyOwner employeeExist(employeeId,true) public{
        Employee employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = salary.mul(1 ether);
        employees[employeeId].lastPayday=now;
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
     
     
     function getPaid() employeeExist(msg.sender,true) {
        var employee = employees[msg.sender];
        uint nextPayday=employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
     }
     
     function changePaymentAddress(address employeeOldId,address employeeNewId) onlyOwner employeeExist(employeeOldId,true) employeeExist(employeeNewId,false) changeAddress(employeeOldId,employeeNewId){
        
     }
     
     function calculateRunway() public returns (uint){
         return this.balance.div(totalSalary);
     }
     
     function hasEnoughFund() public returns (bool){
         return calculateRunway() >0;
     }
}
```
第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
contract O
contract A is O
contract B is O
contract C is O
contract K1 is A, B
contract K2 is A, C
contract Z is K1, K2
L(Z) := [Z] + merge(L(K1), L(K2), [K1, K2]) 
        = [Z] + merge([K1, A, B, O], [K2, A, C, O], [K1, K2])  
         = [Z, K1] + merge([A, B, O], [K2, A, C, O], [K2])  
         = [Z, K1, K2] + merge([A, B, O], [A, C, O])  
         = [Z, K1, K2, A] + merge([B, O], [C, O])  
         = [Z, K1, K2, A, B] + merge([O], [C, O])  
         = [Z, K1, K2, A, B, C] + merge([O], [O])  
         = [Z, K1, K2, A, B, C, O]

