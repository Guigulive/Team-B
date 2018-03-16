/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    
    uint constant payDuration = 10 seconds;
    /* 合约发起者 */
    address owner;
    
    /* Employee 类 */
    struct Employee{
        address id;
        uint salary;
        uint lastPayDay;
    }
    
    Employee[] Employees;
    
    function Payroll(){
        owner = msg.sender;
    }
    
    /* 根据地址获取一个员工信息 */
    function _findEmployee(address id) private returns (Employee, uint){
        for(uint i=0; i<Employees.length; i++){
            if(Employees[i].id == id){
                return (Employees[i], i);
            }
        }
    }
    
    function _payEmployee(Employee employee) private {
        /* 发在私有方法里验证 */
        require(employee.id != 0x0);
        employee.id.transfer(employee.salary * (now - employee.lastPayDay)/payDuration);
    }
    
    /* 添加一个员工信息 */
    function addEmployee(address addr, uint s){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(addr);
        assert(employee.id == 0x0);
        Employees.push(Employee(addr,s*1 ether,now));
    }
    
    /* 删除一个员工 */
    function removeEmployee(address addr){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(addr);
        _payEmployee(employee);
        delete Employees[index];
        Employees[index] = Employees[Employees.length - 1];
        Employees.length -= 1;
    }
    
    /* 更新一个员工信息 */
    function updateEmployee(address addr, uint s){
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(addr);
        _payEmployee(employee);
        Employees[index].salary = s * 1 ether;
        Employees[index].lastPayDay = now;
    }
    
    function getLength() returns (uint){
        return Employees.length;
    }
    
    function getBalance() returns (uint){
        return this.balance;
    }
    
    /* 向合约地址添加余额 */
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calcRunway() returns (uint) {
        uint total = 0;
        uint length = getLength();
        for(var i = 0; i< length; i++){
            total += Employees[i].salary;
        }
        return this.balance / total;
    }
    
    function hasEnoughFund() returns (bool){
        return calcRunway() >= 1;
    }
    
    
    function getPaid(){
       var (employee, index) = _findEmployee(msg.sender);
       require(employee.id != 0x0);
       uint nextPayDay = employee.lastPayDay + payDuration;
       require(nextPayDay < now);
       Employees[index].lastPayDay = nextPayDay;
       employee.id.transfer(employee.salary);
    }
    
}

