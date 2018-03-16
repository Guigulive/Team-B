pragma solidity ^0.4.14;

contract Payroll {
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;
    
    Employee[] employees;
    address owner;
    
    function Payroll(){
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary*(now-employee.lastPayday)/payDuration;
            employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint){
        for(uint i=0; i<employees.length; i++){
            if(employees[i].id == employeeId){
                return (employees[i] ,i);
            }
        }
    }
    
    function addEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += employees[employees.length-1].salary;
    }
    
    function removeEmployee(address employeeId){
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employees[index].salary;
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        employees[index].id = employeeId;
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        //uint totalSalary = 0;
        //uint len = employees.length;
        //for(uint i = 0;i < len; i++ ){
        //    totalSalary += employees[i].salary;
        //}
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway()>0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay < now);
        
        employee.lastPayday = employee.lastPayday + payDuration;
        employee.id.transfer(employee.salary);
    }
}
