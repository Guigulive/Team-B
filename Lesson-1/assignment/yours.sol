/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint salaryUnit = 1 ether;
    uint salary = 1;
    address employee;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    //Update address
    function updateEmployee(address e) {
        employee = e;
    }
    
    //Update salary
    function updateSalary(uint s){
        salary = s * salaryUnit;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway()>0;
    }
    
    function getPaid() {
        if(msg.sender != employee){
            revert();
        }
        
        uint nextPayDay = lastPayday + payDuration;
        if(nextPayDay > now){
            revert();
        }
        
        lastPayday = lastPayday + payDuration;
        employee.transfer(salary);
    }
}
