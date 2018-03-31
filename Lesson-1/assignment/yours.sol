pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 30 days;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }

    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);

        address lastEmployee = employee;
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;

        if (lastEmployee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            lastEmployee.transfer(payment);
        }
    }

    function addFund()  payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() view returns (uint) {
        return this.balance / salary;
    }

    function hasEnoughFund() view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        require(msg.sender == employee);

        uint nextPayday = lastPayday + payDuration;
        require(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
