pragma solidity ^0.4.14;
import "./Ownable.sol";

contract Payroll is Ownable {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint public totalSalary;
    uint constant payDuration = 10 seconds;
 
    mapping(address => Employee) public employees;

    modifier employeeIdExists(address employeeId) {
        assert(employees[employeeId].id != 0);
        _;
    }

    function _partialPaid(Employee storage employee) private {
        employee.id.transfer(employee.salary * (now - employee.lastPayday) / payDuration);
        employee.lastPayday = now;
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner {
        Employee employee = employees[employeeId];
        assert(employee.id == 0);
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) onlyOwner
        employeeIdExists(employeeId) returns(uint)  {
        Employee e = employees[employeeId];
        totalSalary -= e.salary;
        _partialPaid(e);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner 
        employeeIdExists(employeeId) {
        Employee employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary -= employee.salary;
        employee.salary = salary * 1 ether;
        totalSalary += employee.salary;
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner
        {
        uint salary = employees[oldAddress].salary;
        removeEmployee(oldAddress);
        addEmployee(newAddress, salary / 1 ether);
    }
    
    function addFund() payable onlyOwner returns (uint)  {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        if(totalSalary > 0)    
            return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeIdExists(msg.sender) {
        Employee employee = employees[msg.sender];
        _partialPaid(employee);
    }
}
