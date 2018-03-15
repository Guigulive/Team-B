pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        require(employee.id != 0);
        employee.id.transfer(employee.salary * (now - employee.lastPayday) / payDuration);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++) {
            Employee e = employees[i];
            if(e.id == employeeId) {
                return (e, i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (e, index)= _findEmployee(employeeId);
        if(e.id == 0) {
            employees.push(Employee(employeeId, salary * 1 ether, now));
            return;
        }
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (e, i) = _findEmployee(employeeId);
        assert(e.id != 0);
        _partialPaid(e);
        delete employees[i];
        employees[i] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (e, index) = _findEmployee(employeeId);
        assert(e.id != 0);
        _partialPaid(e);
        employees[index].salary = salary * 1 ether;
    }
    
    function addFund() payable returns (uint) {
        require(msg.sender == owner);
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
    
       uint totalSalary = 0;
       // cache employees.length, each iteration save around 200  gases 
       uint len = employees.length;
       for (uint i = 0; i < len; i++) {
            totalSalary += employees[i].salary;
        }
        if(totalSalary != 0)
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0);
        _partialPaid(employee);
    }
}
