pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        // 注意单位：单位 wei
        uint salary;
        uint lastPayday;
    }

    // 30 days
    uint constant payDuration = 30 days;
    uint totalSalary = 0;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }

    function test (address employeeId)  returns(uint) {
        // 如果没有找到返回 0 个，如果找了的是第 0 个也返回 0.
        var (employee, index) = _findEmployee(employeeId);
        return index;
    }

    function _partialPaid(Employee employee) private {
        uint payments = (now - employee.lastPayday) / payDuration *  employee.salary;
        employee.id.transfer(payments);
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salaryEther) {
        require(msg.sender == owner);
        // 添加新雇员前，需判断新雇员是否已存在
        var (employee, index) = _findEmployee(employeeId);
        require(employee.id == 0x0);

        uint salary = salaryEther * 1 ether;

        // 这里有这里有疑问
        // Employee storage emp = Employee(employeeId, salary, now);
        // employees.push(emp);
        employees.push(Employee(employeeId, salary, now));
        totalSalary += salary;
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);

        var (employee, index) = _findEmployee(employeeId);
        employees[index] = employees[employees.length - 1];
        employees.length = employees.length -1;
        totalSalary -= employee.salary;

        _partialPaid(employee);
    }

    function updateEmployee(address employeeId, uint salaryEther) {
        require(msg.sender == owner);

        var (employee, index) = _findEmployee(employeeId);

        require(employee.id != 0x0);

        uint salary = salaryEther * 1 ether;
        totalSalary = totalSalary + salary - employees[index].salary;
        employees[index].salary = salary;

        _partialPaid(employee);
    }


    function addFund()  payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() view returns (uint) {
        return this.balance / totalSalary;
    }

    function hasEnoughFund() view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        require(employee.id != 0x0);

        uint nextPayday = employee.lastPayday + payDuration;
        require(nextPayday < now);
        //         memory employee
        //        employee.lastPayday = nextPayday;
        //        employee.id.transfer(employee.salary);

        // 要改变是 storage employee
        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employee.salary);
    }
}
