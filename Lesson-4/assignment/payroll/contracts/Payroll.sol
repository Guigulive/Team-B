pragma solidity ^0.4.14;
import './Ownable.sol';
contract Payroll is Ownable {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint public totalSalary;
    uint constant payDuration = 10 seconds;
 
    mapping(address => Employee) public employees;

    modifier employeeIdExists(address employeeId)  {
        assert(employees[employeeId].id != 0);
        _;
    }

    function _partialPaid(Employee storage employee) private {
        uint toPay = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(toPay);
        employee.lastPayday = now;
    }
    
    function addEmployee(address employeeId, uint salary) public onlyOwner {
        Employee storage employee = employees[employeeId];
        assert(employee.id == 0);
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) public onlyOwner
        employeeIdExists(employeeId) returns(uint)  {
        Employee storage e = employees[employeeId];
        totalSalary -= e.salary;
        _partialPaid(e);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) public onlyOwner 
        employeeIdExists(employeeId) {
        Employee storage employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary -= employee.salary;
        employee.salary = salary * 1 ether;
        totalSalary += employee.salary;
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner
        {
        uint salary = employees[oldAddress].salary;
        removeEmployee(oldAddress);
        addEmployee(newAddress, salary / 1 ether);
    }
    
    function addFund() public payable onlyOwner returns (uint)  {
        return this.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        if(totalSalary > 0)    
            return this.balance / totalSalary;
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public employeeIdExists(msg.sender) {
        Employee storage employee = employees[msg.sender];
        _partialPaid(employee);
    }
}