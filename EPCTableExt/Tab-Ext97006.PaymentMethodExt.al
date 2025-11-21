tableextension 97006 "EPC Payment Method Ext" extends "Payment Method"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Payment Method Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 190113';
            OptionCaption = ' ,Cash,Bank,,MJVM,,Refund Cash,Refund Bank,AJVM,Debit Note,JV,Negative Adjmt.';
            OptionMembers = " ",Cash,Bank,"D.D.",MJVM,"D.C./C.C./Net Banking","Refund Cash","Refund Bank",AJVM,"Debit Note",JV,"Negative Adjmt.";
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}