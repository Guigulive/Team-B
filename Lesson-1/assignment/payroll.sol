pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    
    struct Employee {
        uint salary;
        address account; //maybe different with employee address ,Todo
    }
    //uint salary;
    //address employee;
    uint lastPayday;
    
    mapping(address => Employee) employees;
    
    function Payroll() {
        owner = msg.sender;
        lastPayday = now;
    }
    
    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        
        //Todo
        /*
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        */
        
        employees[e].salary = s * 1 ether;
        employees[e].account = e;
        
        //lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        Employee employee = employees[msg.sender];
        return this.balance / employee.salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        Employee storage employee = employees[msg.sender];
        
        assert(employee.salary > 0);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.account.transfer(employee.salary);
    }
}
