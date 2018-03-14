/*作业请提交在这个目录下*/
pragma solidity ^0.4.0;

contract Payroll {
    uint constant payDuration = 10 seconds;
    address employee ;
    uint salary = 1 ether;
    uint lastPayday = now;
    
    //可以调整地址和薪水，需要定义两个方法，来修改变量employee和salary的值
    function updateSalary(uint newSalary) {
        salary = newSalary * 1 ether;
    }    
    
    //注意：address变量在输入参数时一定要加上双引号
    function updateAddress(address newAddress){
        //判断输入的地址是否是空值
        if (newAddress == 0x0){
            revert();
        }
        employee = newAddress;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require( msg.sender == employee) ;
        uint nextPayDay = lastPayday + payDuration;
        if (nextPayDay > now){
            revert();
        }
        lastPayday = nextPayDay;
        employee.transfer(salary);
    }
}
