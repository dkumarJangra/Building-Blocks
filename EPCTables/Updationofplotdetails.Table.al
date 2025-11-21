table 60800 "Updation of plot details"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Plot No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "No. of Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Received Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Min. allotment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Creation Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Application No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}