table 50000 "Land Book"
{
    // ALLEPG 080713 : Created new table.


    fields
    {
        field(1; "Entry No."; Integer)
        {
            Editable = false;
        }
        field(2; Date; Date)
        {
        }
        field(3; "Vendor Code"; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF Vendor.GET("Vendor Code") THEN
                    "Vendor Name" := Vendor.Name
                ELSE
                    "Vendor Name" := '';
            end;
        }
        field(4; "Vendor Name"; Text[50])
        {
        }
        field(5; "Document Type"; Option)
        {
            OptionCaption = ' ,Payment,Refund,Invoice,Credit Memo';
            OptionMembers = " ",Payment,Refund,Invoice,"Credit Memo";
        }
        field(6; "Posting Type"; Option)
        {
            OptionCaption = ' ,Advance,Running,Retention';
            OptionMembers = " ",Advance,Running,Retention;
        }
        field(7; Mode; Option)
        {
            OptionCaption = ' ,Cash,Bank,Other';
            OptionMembers = " ",Cash,Bank,Other;
        }
        field(8; "Bank Code"; Code[20])
        {

            trigger OnLookup()
            begin
                IF Mode = Mode::Bank THEN
                    IF PAGE.RUNMODAL(Page::"Bank Account List", BankAcc) = ACTION::LookupOK THEN BEGIN
                        "Bank Code" := BankAcc."No.";
                        IF BankAcc.GET("Bank Code") THEN
                            "Bank Name" := BankAcc.Name;
                    END;
            end;

            trigger OnValidate()
            begin
                IF BankAcc.GET("Bank Code") THEN
                    "Bank Name" := BankAcc.Name;
            end;
        }
        field(9; Towards; Option)
        {
            OptionCaption = ' ,Legal,Land,Entertainment Exp,Printing & Stationary';
            OptionMembers = " ",Legal,Land,"Entertainment Exp","Printing & Stationary";
        }
        field(10; "Bank Name"; Text[50])
        {
        }
        field(11; "Cheque No."; Integer)
        {
        }
        field(12; "Cheque Date"; Date)
        {
        }
        field(13; "Cheque Cleared"; Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(14; "Cheque Cleared Date"; Date)
        {
        }
        field(15; Quantity; Decimal)
        {
        }
        field(16; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(17; "Project Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(18; Amount; Decimal)
        {
        }
        field(19; "Registered Value"; Decimal)
        {
        }
        field(20; Registered; Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(21; "Registration No."; Code[20])
        {
        }
        field(22; "Registration Date"; Date)
        {
        }
        field(23; "Registration Office"; Text[60])
        {
        }
        field(24; "Registration in Favour of"; Text[60])
        {
        }
        field(25; Status; Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(26; "Reference By"; Text[30])
        {
        }
        field(27; "Contact No."; Integer)
        {
        }
        field(28; "Applied With"; Integer)
        {
        }
        field(29; "Estimated Value"; Decimal)
        {
        }
        field(30; Remark; Text[100])
        {
        }
        field(31; "Release/ReOpen"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(32; Select; Boolean)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Release/ReOpen", "Release/ReOpen"::Open);
            end;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD("Release/ReOpen", "Release/ReOpen"::Open);
    end;

    trigger OnInsert()
    begin
        LandBook.RESET;
        IF LandBook.FINDLAST THEN
            "Entry No." := LandBook."Entry No." + 1;
    end;

    trigger OnModify()
    begin
        TESTFIELD("Release/ReOpen", "Release/ReOpen"::Open);
    end;

    var
        Vendor: Record Vendor;
        BankAcc: Record "Bank Account";
        LandBook: Record "Land Book";
}

