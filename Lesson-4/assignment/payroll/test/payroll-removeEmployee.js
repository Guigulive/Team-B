var Payroll = artifacts.require( "./Payroll.sol" );

contract( 'Payroll', function ( accounts ) {
    
    const owner = accounts[ 0 ]
    const employeeId = accounts[ 1 ]
    const guestId = accounts[ 2 ]
    const salary = 9
    
    it("测试删除新增员工", async () => {
        
        const payrollInstance = await Payroll.deployed.call( owner, { from: owner } )
        await payrollInstance.addEmployee( employeeId, salary )
        await payrollInstance.removeEmployee( employeeId )
    
        const employee = await payrollInstance.employees.call( employeeId )
    
        assert.equal( employee[ 0 ], '0x0000000000000000000000000000000000000000', "删除员工不成功" );
        
    
    } );
    
    it("测试 guestId 删除新员工", async () => {
        try {
            const payrollInstance = await Payroll.deployed.call( owner )
            await payrollInstance.addEmployee( employeeId, salary ,{ from: guestId })
            await payrollInstance.removeEmployee( employeeId )
    
            assert(false, "非 owner 不能够删除新员工");
        } catch (e) {
            assert.include(
                e.toString(),
                "Error: VM Exception while processing transaction: revert",
                "非 owner 不能够删除新员工"
            )
        }
    });
    
    
    it("测试删除一个不存在的员工", async () => {
        try {
            const payrollInstance = await Payroll.deployed.call( owner )
            await payrollInstance.removeEmployee( employeeId )
    
            assert(false, "不能成功删除一个不存在的员工");
        } catch (e) {
            assert.include(
                e.toString(),
                "Error: VM Exception while processing transaction: revert",
                "不能删除不存在的员工"
            )
        }
    });
    
} );


