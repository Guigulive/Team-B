pragma solidity ^0.4.14;

import "./Ownable.sol";

contract Payroll is Ownable {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;

    address owner;
    mapping(address => Employee) public employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        
        uint new_salary = salary * 1 ether;
        employees[employeeId] = Employee(employeeId, new_salary, now);
        totalSalary += new_salary;
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        totalSalary -= employee.salary;
        
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        
        uint new_salary = salary * 1 ether;
        totalSalary = totalSalary - employee.salary + new_salary;
        employees[employeeId].salary = new_salary;
        employees[employeeId].lastPayday = now;
    }
    
    function changePaymentAddress(address employeeId, address newAddress) onlyOwner employeeExist(employeeId) {
        uint salary = employees[employeeId].salary / 1 ether;
        removeEmployee(employeeId);
        addEmployee(newAddress, salary);
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }

    
    function showTotal() returns (uint) {
        require (msg.sender == owner);
        return totalSalary;
    }
}
