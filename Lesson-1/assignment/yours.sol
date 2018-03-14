/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
//定义领取工资的时间间隔，并设置为常量，不允许更改
    uint constant payDuration = 10 seconds;
//定义工资发放者的地址
    address owner;
    //定义工资变量
    uint salary;
    //定义员工接收工资的地址变量
    address employee;
    //定义最后领取工资的时间变量
    uint lastPayday;

//合约初始化，将合约调用者初始化为工资发放地址
    function Payroll() public {
        owner = msg.sender;
    }
    //往合约地址里面加入代币
    function addFund() public payable returns (uint) {
        return this.balance;
    }
   //计算合约中能够支付工资的次数
    function calculateRunway()  public returns (uint) {
        return this.balance / salary;
    }
     //计算合约里面的代币是否足够支付工资
    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }
    //获取工资，需要判断当前调用合约的地址为员工的地址
    function getPaid() public {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
    //更改员工的收币地址,
    function changeAddress(address e) public{
        //只有合约所有者才能修改员工收币地址
        require(msg.sender == owner);
        //在更新员工收币地址之前，先结算上一个员工的工资。
            if (employee != 0x0) {
                uint payment = salary * (now - lastPayday) / payDuration;
                employee.transfer(payment);
            }
            //更新员工的收币地址
            employee = e;
            //更新最新的工资计算开始时间
            lastPayday = now;
    }
        
        //更改员工的工资
        function changeSalary(uint s) public{
            require(msg.sender == owner);
            //结算更改工资之前的工资
            if (employee != 0x0) {
                uint payment = salary * (now - lastPayday) / payDuration;
                employee.transfer(payment);
                }
            //更新员工的收币地址
            salary = s * 1 ether;
            //更新最新的工资计算开始时间
            lastPayday = now;
        }
}
