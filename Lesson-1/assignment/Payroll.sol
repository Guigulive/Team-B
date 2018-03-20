pragma solidity ^0.4.14;

contract Payroll{
    uint salary;//薪水
    address staff;//员工钱包地址
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function setStaff(address staffAddress){//设置员工账户地址
        staff = staffAddress;
    }
    
    function setSalary(uint staffSalary){//设置薪酬
        salary = staffSalary;
    }
    
    function addFund() payable returns (uint){//账户存钱
        return this.balance;
    }
    
    function calculateRunway() returns (uint){//账户中还能支付多少次薪酬
        return this.balance/salary;
    }
    
    function hasEnoughFund() returns (bool){//账户中是否还能支付一次薪酬
        return calculateRunway() >0;
    }
    
    function getPaid(){//给员工发工资
        uint nextPayday = lastPayday+payDuration;
        if(nextPayday>now || msg.sender != staff){//如果没到发工资或者拿钱的不是员工本人，抛出异常
            revert();
        }
            lastPayday = nextPayday;//更新上次发薪时间
            staff.transfer(salary);//给员工支付薪酬
     
    }
    
}