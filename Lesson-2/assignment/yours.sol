/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    
     struct Employee{
        address id;
        uint salary;
        uint lastPayDay;
    }
    uint constant payDuration = 10 seconds;
    address owner;
    mapping(address => Employee) public Employees;
    uint total;
    
    function Payroll(){
        owner = msg.sender;
    }
    
    function _payEmployee(Employee employee) private {
        require(employee.id != 0x0);
        employee.id.transfer(employee.salary * (now - employee.lastPayDay)/payDuration);
    }
    
    function addEmployee(address addr, uint s){
        require(msg.sender == owner);
        Employee employee = Employees[addr];
        assert(employee.id == 0x0);
        Employees[addr] =  Employee(addr,s * 1 ether,now);
        total += s * 1 ether;
    }
    
    function removeEmployee(address addr){
        require(msg.sender == owner);
        Employee employee = Employees[addr];
        _payEmployee(employee);
        delete Employees[addr];
        total -= employee.salary;
    }
    
    function updateEmployee(address addr, uint s) {
        require(msg.sender == owner);
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
    
    function getPaid(){
       Employee employee = Employees[msg.sender];
       require(employee.id != 0x0);
       uint nextPayDay = employee.lastPayDay + payDuration;
       require(nextPayDay < now);
       employee.lastPayDay = nextPayDay;
       employee.id.transfer(employee.salary);
    }
    
}
