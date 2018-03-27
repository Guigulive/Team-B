pragma solidity ^0.4.14;

/*
*雇员1：0x14723a09acff6d2a60dcdf7aa4aff308fddc160c
*
*雇员2：0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db
*
*雇员3：0x583031d1113ad414f02576bd6afabfb302140225
*
*雇员4：0xdd870fa1b7c4700f2bd7f44238821c26f7392148
*
*新增函数changePaymentAddress
*新增modifier employeeNotExist断言雇员新地址不存在map键值对中
*
*
*/
contract Payroll {
    struct Employee{
        address id;//合约雇员的id
        uint salary;//合约薪酬
        uint lastPayday;//上次付款薪酬
        
    }

    uint constant payDuration = 10 seconds;// 发薪周期

    address owner;//合约拥有者

    mapping(address=>Employee) public employees;//键值对雇员集合
    
    
    uint totalSalary=0;//初始化总薪酬等于0

    function Payroll() {
        owner = msg.sender;//
    }
    
    modifier onlyOwner {//函数调用者必须是合约拥有者
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address employeeId){//当前雇员地址必须存在
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier employeeNotExist(address employeeId){//当前雇员地址必须不存在
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary*(now-employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }
    
    function changePaymentAddress(address oldEmployeeId,address newEmployeeId) onlyOwner employeeExist(oldEmployeeId) employeeNotExist(newEmployeeId){//更改员工的薪水支付地址
        var employee = employees[oldEmployeeId];//先获取原employee对象
        var salary = employee.salary;//临时存储薪水
        var lastPayday = employee.lastPayday;//临时存储上次支付时间
        delete employees[oldEmployeeId];//删除旧employee键值对
        employees[newEmployeeId] = Employee(newEmployeeId,salary,lastPayday);//新增更新地址后employee键值对
    }
    
    function addEmployee(address employeeId,uint salary) onlyOwner{
        
        var employee = employees[employeeId];//有没有办法像这样共通的employee不能为空的判断，在遍历employees的时候就判断，并对外抛出异常，使外层调用的函数也能终止，避免重复判断规则。
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
    
    function checkEmployee(address employeeId) returns (uint salary,uint lastPayday) {//读取雇员信息
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