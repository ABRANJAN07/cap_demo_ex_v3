using { db as mydb } from '../db/data-model';

service CatalogService {

    entity Employee as projection on mydb.Employee {
        ID as EmployeeId,
        Fname,
        Lname,
        EmpGender,
        EmpEmail,
        EmpSalary,
        Currency,
        EmpRating,
        Milestone,
        city.name as CityName,
        city,
        task
    };

    entity WorkAssignments as projection on mydb.WorkAssignments {     
        Id,
        Status,
        Desc,
        Task,
    };
    
    type data {
        Fname       : String;
        Lname       : String;
    };   
    function unBoundedFunc() returns array of data;

    action hikeSalary( employee: Employee:EmployeeId, amount: Decimal(15, 2) ) returns { EmpSalary: Decimal(15, 2) };

}