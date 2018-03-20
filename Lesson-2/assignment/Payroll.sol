pragma solidity ^0.4.14;

/*
*雇主:0xca35b7d915458ef540ade6068dfe2f44e8fa733c
*
*员工1:0x14723a09acff6d2a60dcdf7aa4aff308fddc160c    
*transaction cost 22966    execution cost 1694
*员工2:0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db
*transaction cost 23747    execution cost 2475
*员工3:0x583031d1113ad414f02576bd6afabfb302140225
*transaction cost 24528    execution cost 3256
*员工4:0xdd870fa1b7c4700f2bd7f44238821c26f7392148
*transaction cost 25309    execution cost 4037
*员工5:0xe4829bcf2f0979522ba7afe74f9fb7dc41322a6d
*transaction cost 26090    execution cost 4818
*员工6:0x358a7ce1782fc82900ff9e351f7e78c90e5adb4a
*transaction cost 26871    execution cost 5599
*员工7:0xf7c3c48d00983d179f876098781cebfc0eb6a130
*transaction cost 27652    execution cost 6380
*员工8:0x0a451ba2621db2ffe257cb53580e481ef02e3fe0
*transaction cost 28433    execution cost 7161
*员工9:0xfb364d47f57d8cf6e569769cca06f3771759fe75
*transaction cost 29214    execution cost 7942
*员工10:0x113c2c0d6ce45d10ca06ff600fa06bda07d103a2
*transaction cost 29995    execution cost 8723
*
*观察发现每加入一个员工，计算剩余支付薪酬消耗的gas就越多，因为雇员的数量越多遍历计算的就越多
*优化calculateRunway函数，新定义状态变量totalSalary，在新增、删除、更新雇员过程中动态更新totalSalary，最后执行calculateRunway函数时就避免计算，直接算剩余支付薪酬
*/


contract Payroll {
    struct Employee{
        address id;//合约雇员的id
        uint salary;//合约薪酬
        uint lastPayday;//上次付款薪酬
        
    }

    uint constant payDuration = 10 seconds;// 发薪周期

    address owner;//合约拥有者
    Employee[] employees;
    
    uint totalSalary=0;//初始化总薪酬等于0

    function Payroll() {
        owner = msg.sender;//
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary*(now-employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee,uint){
        for(uint i = 0;i < employees.length;i++){
            if(employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }
    
    function addEmployee(address employeeId,uint salary){
        require(msg.sender==owner);
        
        var(employee,index) = _findEmployee(employeeId);//有没有办法像这样共通的employee不能为空的判断，在遍历employees的时候就判断，并对外抛出异常，使外层调用的函数也能终止，避免重复判断规则。
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId,salary * 1 ether,now));
        
        totalSalary += salary * 1 ether; 
    }
    
    function removeEmployee(address employeeId){
        require(msg.sender==owner);
        
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
         _partialPaid(employee);
         
         totalSalary -= employee.salary; 
         
         delete employees[index];
        employees[index]=employees[employees.length-1];
        employees.length-=1;
        
        
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);//更新员工和薪资
        
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        
        totalSalary -= employee.salary; 
        totalSalary += salary * 1 ether; 
        
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
        


    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {//这里是固定薪酬的总和，当有人已支付过不是一个完整周期的薪酬，这里计算的方式就有问题。
        //uint totalSalary = 0;
        //for(uint i = 0;i < employees.length;i++){
            //totalSalary += employees[i].salary; 
        //}
        
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
         var(employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);

    }
}