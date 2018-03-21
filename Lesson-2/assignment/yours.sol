/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    //mapping(address => Employee) employees;
    Employee[] employees;
    
    uint totalSalary;
    
    function Payroll() {
        owner = msg.sender;
        totalSalary = 0;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary *(now - employee.lastPayday) / payDuration;
        employee.lastPayday = now;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length;i++){
            if (employees[i].id == employeeId) {
                return (employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var (employee,index) =  _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId,salary * 1 ether,now));
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        
        var (employee,index) =  _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employees[index]);
        delete employees[index];
        totalSalary -= employee.salary;
        employees[index] = employees[employees.length -1];
        employees.length -=1;
    }

    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        
        var (employee,index) =  _findEmployee(e);
        assert(employee.id != 0x0);
        _partialPaid(employees[index]);
        totalSalary += s * 1 ether - employee.salary;
        employees[index].salary = s * 1 ether;
        
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        /*
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        */
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee,index) =  _findEmployee(msg.sender);
        
        assert(employee.id != 0x0);
        
        //uint nextPayday = employee.lastPayday + payDuration;
        //assert(nextPayday < now);
        uint paytimes = (now - employee.lastPayday) / payDuration;
        assert(paytimes > 0);

        employees[index].lastPayday += payDuration * paytimes;
        employee.id.transfer(employee.salary * paytimes);
    }
}
