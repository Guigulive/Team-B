pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    
    using SafeMath for uint;
    
    uint constant payDuration = 10 seconds;
    
    uint totalSalary = 0;
    
    mapping(address=>Employee) public employees;
    address owner;
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier employeeNotExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary*(now-employee.lastPayday)/payDuration;
            employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) {
        var employee =employees[employeeId];
        totalSalary += salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
         
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId)  {
        var employee = employees[employeeId];
        totalSalary -= employees[employeeId].salary;
        _partialPaid(employee);
        employees[employeeId].id = employeeId;
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
        totalSalary += employees[employeeId].salary;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    
    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway()>0;
    }
    
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday){
        var employee = employees[employeeId];
        //return (employee.salary, employee.lastPayday);
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner employeeExist(oldAddress) employeeNotExist(newAddress){
        var (salary, lastPayday) = checkEmployee(oldAddress);
        employees[newAddress] = Employee(newAddress, salary*1 ether, lastPayday);
        delete employees[oldAddress];
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        
        uint nextPayDay = employee.lastPayday.add(payDuration);
        assert(nextPayDay < now);
        
        employees[msg.sender].lastPayday = nextPayDay;
        employee.id.transfer(employee.salary);
    }
}
