namespace db;

using { cuid, managed, temporal, Currency } from '@sap/cds/common';

type Gender : String(20) enum{
    Male = 'M';
    Female = 'F';
};

type Status : String(20) enum{
    Complted;
    WIP;
};

type Email : String(255)@assert.format : '^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$';

aspect salAmount {
    EmpSalary       : amountT;
    Currency        : Currency;
};

type amountT : Decimal(15, 2)@(
    Semantics.amount.currencyCode : 'Currency',
    sap.unit: 'Currency'
);



entity City {
    key ID      : Integer;
    name        : localized String(100) not null @assert.unique;
    //employee    : Association to Employee;
}

entity Employee : cuid, managed, salAmount {
    Fname       : String;
    Lname       : String;
    EmpGender   : Gender;
    EmpEmail    : Email;
    EmpRating   : Integer;
    Milestone   : String;
    city        : Association to one City;
    task        : Composition of many WorkAssignments on task.Task = $self;
}

entity WorkAssignments: managed {
    Key Id      : Integer @assert.unique;
    Status      : Status default 'WIP';
    Desc        : String;
    Task        : Composition of Employee;
}