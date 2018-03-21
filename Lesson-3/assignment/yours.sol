/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable  {
    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
   uint constant payDuration = 10 seconds;
   address owner;
   //Employee[] employees;
   mapping(address => Employee) public employees;
   
   uint private totalSalary = 0;
  
    // function Payroll() {
    //     owner = msg.sender;
    // }

    // modifier onlyOwner {
    //     require(msg.sender == owner);
    //     _;
    // }
    
    modifier employExist(address employeeId){
        var employeeTemp = employees[employeeId];
        assert(employeeTemp.id != 0x0);
        _;
    }
    
   function changePaymentAddress(address oldaddress, address newaddress) onlyOwner employExist(oldaddress) {
        uint salary = employees[oldaddress].salary;
        removeEmployee(oldaddress);
        addEmployee(newaddress, salary.div(1 ether));
        
    }
    
    function _partialPaid(Employee storage employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.lastPayday = now;
        employee.id.transfer(payment);

    }
    

    function addEmployee(address employeeId, uint salary) onlyOwner  {
        var employeeTemp = employees[employeeId];
        assert(employeeTemp.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
    
    function removeEmployee(address employeeId) onlyOwner employExist(employeeId) {
        var employeeTemp = employees[employeeId];
        _partialPaid(employeeTemp);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        //不释放空间?
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary)   onlyOwner employExist(employeeId) {
        var employeeTemp = employees[employeeId];

        _partialPaid(employeeTemp);
        totalSalary -= totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].salary = salary.mul(1 ether);
        employees[employeeId].lastPayday = now;
        totalSalary -= totalSalary.add(employees[employeeId].salary);
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
    
    function checkEmployee(address employeeid) returns(uint salary, uint lastPayday){
        var employeeTemp = employees[employeeid];
        //return (employeeTemp.salary, employeeTemp.lastPayday);
        salary = employeeTemp.salary;
        lastPayday = employeeTemp.lastPayday;
    }
    
    function getPaid() employExist(msg.sender) {
        var employeeTemp = employees[msg.sender];
        uint nextPayday = employeeTemp.lastPayday.add( payDuration);
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employeeTemp.id.transfer(employeeTemp.salary);
        
    }
    
} 
