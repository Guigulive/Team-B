pragma solidity ^0.4.14;

contract Payroll {
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
        
    }

    uint constant payDuration = 10 seconds;

    address owner;

    mapping(address=>Employee) public employees;

    uint totalSalary=0;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier employeeNotExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary*(now-employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }
    
    function changePaymentAddress(address oldEmployeeId,address newEmployeeId) onlyOwner employeeExist(oldEmployeeId) employeeNotExist(newEmployeeId){
        var employee = employees[oldEmployeeId];
        var salary = employee.salary;
        var lastPayday = employee.lastPayday;
        delete employees[oldEmployeeId];
        employees[newEmployeeId] = Employee(newEmployeeId,salary,lastPayday);
    }
    
    function addEmployee(address employeeId,uint salary) onlyOwner{
        
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        
        employees[employeeId] = Employee(employeeId,salary * 1 ether,now);
        
        totalSalary += salary * 1 ether; 
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){
        
        var employee = employees[employeeId];
        
         _partialPaid(employee);
         
         totalSalary -= employee.salary; 
         
         delete employees[employeeId];
        
        
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
        
        var employee = employees[employeeId];
        
        _partialPaid(employee);
        
        totalSalary -= employee.salary; 
        totalSalary += salary * 1 ether; 
        
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
        


    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        //uint totalSalary = 0;
        //for(uint i = 0;i < employees.length;i++){
            //totalSalary += employees[i].salary; 
        //}
        
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function checkEmployee(address employeeId) returns (uint salary,uint lastPayday) {
        var employee = employees[employeeId];
        
        salary = employee.salary;
        lastPayday=employee.lastPayday;
    }
    
    function getPaid() employeeExist(msg.sender){
         var employee = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);

    }
}

