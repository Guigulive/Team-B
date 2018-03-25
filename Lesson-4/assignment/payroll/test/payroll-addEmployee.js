var Payroll = artifacts.require( "./Payroll.sol" );

contract( 'Payroll', function ( accounts ) {
    
    const owner = accounts[ 0 ]
    const employeeId = accounts[ 1 ]
    const guestId = accounts[ 2 ]
    const salary = 9
    
    it("测试添加的新员工 accounts[ 1 ] salary = 9", async () => {
        
        const payrollInstance = await Payroll.deployed.call( owner, { from: owner } )
        await payrollInstance.addEmployee( employeeId, salary )
        const employee = await payrollInstance.employees.call( employeeId )
        
        assert.equal( employee[ 0 ], employeeId, "员工地址添加不正确" );
        assert.equal( employee[ 1 ], web3.toWei( salary, 'ether' ), "员工工资添加不正确" );
        
    } );
    
    it("测试 guestId 添加新员工", async () => {
        try {
            const payrollInstance = await Payroll.deployed.call( owner )
            await payrollInstance.addEmployee( employeeId, salary ,{ from: guestId })
        } catch (e) {
            assert.include(
                e.toString(),
                "Error: VM Exception while processing transaction: revert",
                "非 owner 不能够添加新员工"
            )
        }
    });
    
    
    it("测试两次添加同一个员工", async () => {
        try {
            const payrollInstance = await Payroll.deployed.call( owner )
            await payrollInstance.addEmployee( employeeId, salary )
            await payrollInstance.addEmployee( employeeId, salary )
        } catch (e) {
            assert.include(
                e.toString(),
                "Error: VM Exception while processing transaction: revert",
                "不同添加已存在的员工"
            )
        }
    });
    
} );


