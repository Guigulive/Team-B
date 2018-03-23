pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    using SafeMath for uint;
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    uint totalSalary = 0 ;
    uint constant payDuration=10 seconds;
    mapping(address => Employee) public employees;
    
    modifier employeeExist(address employeeId,bool contain){
        Employee employee = employees[employeeId];
        if(contain){
            assert(employee.id != 0x0);
        }else{
            assert(employee.id == 0x0);    
        }
        
        _;
    }
    modifier changeAddress(address employeeOldId,address employeeNewId){
        employees[employeeNewId] =employees[employeeOldId];
        employees[employeeNewId].id=employeeNewId;
        delete employees[employeeOldId];
        _;
    }
    
    
    function _partialPaid(Employee employee) private{
        uint payMent=employee.salary.mul(now.sub(employee.lastPayday).div(payDuration));
        employee.id.transfer(payMent);
    }
     
    function addFund() payable public returns (uint) {
       
    }
   
    function addEmployee(address employeeId, uint salary)  onlyOwner employeeExist(employeeId,false) public{
        employees[employeeId]=Employee(employeeId,salary.mul(1 ether),now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
   
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId,true) public{
        Employee employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }
   
    function updateEmployee(address employeeId ,uint salary) onlyOwner employeeExist(employeeId,true) public{
        Employee employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = salary.mul(1 ether);
        employees[employeeId].lastPayday=now;
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
     
     
     function getPaid() employeeExist(msg.sender,true) {
        var employee = employees[msg.sender];
        uint nextPayday=employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
     }
     
     function changePaymentAddress(address employeeOldId,address employeeNewId) onlyOwner employeeExist(employeeOldId,true)  employeeExist(employeeNewId,false) changeAddress(employeeOldId,employeeNewId){
        
     }
     
     function calculateRunway() public returns (uint){
         return this.balance.div(totalSalary);
     }
     
     function hasEnoughFund() public returns (bool){
         return calculateRunway() >0;
     }
}
