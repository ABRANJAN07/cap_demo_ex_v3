const cds = require('@sap/cds');

const { Employee, WorkAssignments } = cds.entities('db');

module.exports = cds.service.impl((srv) => {

    srv.after('READ', "Employee", async res => {

        if (Array.isArray(res)) {
            res.forEach(async element => {
                if (element.EmpRating >= 3) {
                    console.log("Data: ", element.EmpRating);
                    element.Milestone = "Yes_Test";
                }
            });
        }

        console.log("res: ", res);
        
        console.log("Milestone Updated");

    });

    srv.on("unBoundedFunc", async req => {
        console.log("Entered");
        const results = await cds.tx(req).run(SELECT `Fname,Lname`.from(Employee).where(`EmpSalary<=${9000}`));
        console.log('Results: ', results);
        const myJSON = JSON.stringify(results);
        console.log("myjson: ", myJSON);
        return results;
    });

    srv.on('hikeSalary', async req => {
        const { employee, amount} = req.data;
        console.log("employee: ", employee);
        console.log("amount: ", amount);
        console.log("Req.Data: ", req.data);

        let b = await SELECT `EmpSalary`.from(Employee).where `ID = ${req.data.employee}`;
        console.log("b: ", b[0].EmpSalary);

        let hikedSal = parseFloat(req.data.amount) + parseFloat(b[0].EmpSalary);
        console.log("hikedSal: ", hikedSal);
        
        await UPDATE (Employee).set({EmpSalary: hikedSal}).where `ID = ${req.data.employee}`;

        let x = {};
        x.EmpSalary = hikedSal;
        return x;
    });

});