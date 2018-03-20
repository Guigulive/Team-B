/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

import './Ownable.sol';

contract Payroll is Ownable{
    
    struct Employee{
        address id;
        uint salary;
        uint lastPayDay;
    }
    uint constant payDuration = 10 seconds;
    address owner;
    mapping(address => Employee) public Employees;
    uint total;
    
    modifier employeeIdExists(address addr) {
        require(Employees[addr].id != 0x0);
        _;
    }
    
    function _payEmployee(Employee employee) private {
        employee.id.transfer(employee.salary * (now - employee.lastPayDay)/payDuration);
    }
    
    function addEmployee(address addr, uint s) onlyOwner {
        Employee employee = Employees[addr];
        assert(employee.id == 0x0);
        Employees[addr] =  Employee(addr,s * 1 ether,now);
        total += s * 1 ether;
    }
    
    function removeEmployee(address addr) onlyOwner employeeIdExists(addr) {
        Employee employee = Employees[addr];
        _payEmployee(employee);
        delete Employees[addr];
        total -= employee.salary;
    }
    
    function updateEmployee(address addr, uint s) onlyOwner employeeIdExists(addr) {
        Employee employee = Employees[addr];
        _payEmployee(employee);
        total -= employee.salary;
        employee.salary = s * 1 ether;
        total += s * 1 ether;
        employee.lastPayDay = now;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calcRunway() returns (uint) {
        return this.balance / total;
    }
    
    function hasEnoughFund() returns (bool){
        return calcRunway() >= 1;
    }
    
    function getPaid() employeeIdExists(msg.sender) {
       Employee employee = Employees[msg.sender];
       uint nextPayDay = employee.lastPayDay + payDuration;
       require(nextPayDay < now);
       employee.lastPayDay = nextPayDay;
       employee.id.transfer(employee.salary);
    }
    
    function changePaymentAddress(address oldAddr, address newAddr) employeeIdExists(oldAddr){
        Employee employee = Employees[oldAddr];
        uint salary = employee.salary;
        removeEmployee(oldAddr);
        addEmployee(newAddr, salary);
        
    }
    
}

