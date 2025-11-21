table 97857 "Status Change Log"
{
    // 
    // No  Order    Dev Date   Typ Description
    // ====================================================================================================================================
    // 001 WKF50020 MSI 191107 NEW Build
    //                             Example Table for Codeunit 55128 "Exit Point Sample".
    //                             For ExitPoint on Status Level Change useable.

    Caption = 'Status Change Log';

    fields
    {
        field(1; "To-do No."; Code[20])
        {
            Caption = 'To-do No.';
            TableRelation = "To-do";
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(15; "Old Status"; Integer)
        {
            Caption = 'Old Status';
            //TableRelation = Table5128015;
        }
        field(16; "New Status"; Integer)
        {
            Caption = 'New Status';
            //TableRelation = Table5128015;
        }
        field(20; Date; Date)
        {
            Caption = 'Date';
        }
        field(30; Time; Time)
        {
            Caption = 'Time';
        }
    }

    keys
    {
        key(Key1; "To-do No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

