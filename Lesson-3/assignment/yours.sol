/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    
    uint constant payDuration = 10 seconds;
    
    address owner;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    mapping(address => Employee) public employees ;
    
    uint totalSalary = 0;

    modifier employeeExist(address employeeId){
        Employee employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    //_partialPaid可以进一步整合成modifier，但感觉并没有实际意思，反而会降低代码可读性
    function _partialPaid(Employee employee) private {
        uint payment = (employee.salary.mul(now.sub(employee.lastPayday))).div(payDuration);
        employee.lastPayday = now;
        employee.id.transfer(payment);
    }
    

    function addEmployee(address employeeId, uint salary) onlyOwner{
        
        Employee employee = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId]=Employee(employeeId,salary.mul(1 ether),now);
        totalSalary = totalSalary.add(salary.mul(1 ether));
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
       
        Employee employee = employees[employeeId];
       
        _partialPaid(employees[employeeId]);
        delete employees[employeeId];
        totalSalary = totalSalary.sub(employee.salary);
        
    }

    function changePaymentAddress(address employeeId, address newaddress) onlyOwner employeeExist(employeeId) {
         employees[employeeId].id = newaddress;
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        
        Employee employee = employees[employeeId];
       
        _partialPaid(employees[employeeId]);
        totalSalary = (totalSalary.add(salary.mul(1 ether))).sub(employee.salary);
        employees[employeeId].salary = salary.mul(1 ether);
        
    }
    
    function addFund() payable returns (uint fund) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint runway) {
        
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender) {
        Employee employee = employees[msg.sender];
      
        //uint nextPayday = employee.lastPayday + payDuration;
        //assert(nextPayday < now);
        uint paytimes = (now.sub(employee.lastPayday)).div(payDuration);
        assert(paytimes > 0);

        employees[msg.sender].lastPayday = employees[msg.sender].lastPayday.add(payDuration.mul(paytimes));
        employee.id.transfer(employee.salary.mul(paytimes));
    }
}
