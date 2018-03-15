/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract payroll{
    
    uint salary;
    address employee;
    uint lastPayDay;
    uint constant payDuration = 10 seconds;
    /* 合约发起者 */
    address owner;
    
    function payroll(){
        owner = msg.sender;
    }
    
    /* 向合约地址添加余额 */
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calcRunway() returns (uint) {
        require(salary != 0);
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calcRunway() >= 1;
    }
    
    function getPaid(){
        
        require(msg.sender == employee);
        uint nextPayDay = lastPayDay + payDuration;
        
        /* 重大操作,快速失败,消耗gas */
        assert(nextPayDay < now);
        
        lastPayDay = nextPayDay;
        employee.transfer(salary);
    
    }
    
    /*
      雇员与工资是对应的,需一起更新,不然都需要验证当前合约下雇佣地址不为空!
    */
    function updateEmployee(address e, uint s){
        
        require(msg.sender == owner);
        if(employee != 0x0){
            uint payment = salary * (now - lastPayDay) / payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 wei;
        lastPayDay = now;
    }
    
}
