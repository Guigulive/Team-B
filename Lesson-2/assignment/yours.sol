/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

 contract Payroll{
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
     address owner;
     uint constant payDuration=10 seconds;
    
     Employee[] employees;
     
     function Payroll() public{
         owner = msg.sender;
     }
     
     function _findEmployee(address employeeId) private returns (Employee,uint){
         for(uint i=0;i<employees.length;i++)
         {
             if(employees[i].id == employeeId)
             {
                 return (employees[i],i);
             }
         }
     }
     
     function _partialPaid(Employee employee) private returns (uint){
         uint payMent=employee.salary*(now - employee.lastPayday)/payDuration;
         employee.id.transfer(payMent);
         return (employee.lastPayday+(now - employee.lastPayday)/payDuration*payDuration);
     }
     
    function addFund() payable  public returns (uint) {
        
    }
    
    function addEmployee(address employeeId, uint salary) public{
        require(msg.sender == owner);
        var (employee,index)=_findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId,salary* 1 ether,now));
    }
    
    function removeEmployee(address employeeId) public{
        require(msg.sender == owner);
        var (employee,index)=_findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index]=employees[employees.length-1];
        employees.length -= 1;
        
    }
    
     function updateEmployee(address employeeOldId ,address employeeNewId,uint salary){
         require(msg.sender == owner);  
         var (employee,index) = _findEmployee(employeeOldId);
         assert(employee.id != 0x0);
       uint lastPayday = _partialPaid(employee);
     
        employees[index].id=employeeNewId;
        employees[index].salary=salary * 1 ether;
        employees[index].lastPayday=lastPayday;
    }
     
     function getPaid(){
         var (employee,index) = _findEmployee(msg.sender);
         assert(employee.id != 0x0);
         uint nextPayday=employee.lastPayday + payDuration;
         assert(nextPayday < now);
         uint payMent = employee.salary * (now - employee.lastPayday) / payDuration;
         employees[index].lastPayday=employee.lastPayday+(now - employee.lastPayday)/payDuration*payDuration;
         employee.id.transfer(payMent);
     }
     
     function calculateRunway() returns (uint){
         uint totalSalary= 0;
         for(uint i=0; i < employees.length; i++){
             totalSalary+=employees[i].salary ;
         }
         return this.balance / totalSalary;
     }
     
     function hasEnoughFund() returns (bool){
         return calculateRunway() >0;
     }
 }
