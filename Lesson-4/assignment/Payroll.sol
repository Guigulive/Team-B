pragma solidity ^0.4.2;

library SafeMath {

  function mul(uint a, uint b) internal returns (uint) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint a, uint b) internal returns (uint) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint a, uint b) internal returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint a, uint b) internal returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  
  function Ownable() public {
    owner = msg.sender;
  }


  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}

contract Payroll is Ownable{

    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    mapping (address => Employee) public employees;
    
    uint public totalSalary;


    modifier employeeExist(address employeeId) {
        require(employees[employeeId].salary >0);
        _;
    }
    
    function _partialPaid(address employeeId) private employeeExist(employeeId) {
        uint payment = employees[employeeId].salary * (now - employees[employeeId].lastPayday) / payDuration;
        employees[employeeId].lastPayday = now;
        employees[employeeId].id.transfer(payment);
    }
    

    function addEmployee(address employeeId, uint salary) public onlyOwner {
        employees[employeeId] = Employee(employeeId,salary*1 ether,now);
        totalSalary+=salary*1 ether;
    }

    
    function removeEmployee(address employeeId) public onlyOwner {            
        totalSalary-=employees[employeeId].salary;
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExist(employeeId){
        require(salary > 0);       
        _partialPaid(employeeId);
        totalSalary-=employees[employeeId].salary;
        employees[employeeId].salary = salary * 1 ether;
        totalSalary+=salary*1 ether;
    }
    
    function addFund() payable public returns (uint) {
        return address(this).balance;
    }
    
    function calculateRunway() public returns (uint) {
        return address(this).balance / totalSalary;
    }
    
    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public employeeExist(msg.sender){
        uint nextPayday = employees[msg.sender].lastPayday + payDuration;
        assert(nextPayday < now);
        employees[msg.sender].lastPayday = nextPayday;
        employees[msg.sender].id.transfer(employees[msg.sender].salary);      
    }

    function changePaymentAddress(address newAddr) public employeeExist(msg.sender){
        Employee memory employee = employees[msg.sender];
        delete employees[employee.id];
        employee.id = newAddr;
        employees[employee.id] = employee;
    }
}
