table 97749 "MIS Payment Schedule"
{
    DrillDownPageID = "Update Milestone Code";
    LookupPageID = "Update Milestone Code";

    fields
    {
        field(1; "Unit No."; Code[20])
        {
            Editable = false;
            TableRelation = "Confirmed Order";
        }
        field(2; "Scheme Code"; Code[20])
        {
            Editable = false;
        }
        field(3; "Project Type"; Code[20])
        {
            Editable = false;
            TableRelation = "Unit Type";
        }
        field(4; "Customer No."; Code[20])
        {
            Editable = false;
            TableRelation = Customer;
        }
        field(5; Duration; Integer)
        {
            Editable = false;
        }
        field(6; "Payment Mode"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Cash,Cheque,D.D.,Banker''s Cheque,P.O.,Cheque by Post,NEFT,Stopped';
            OptionMembers = " ",Cash,Cheque,"D.D.","Banker's Cheque","P.O.","Cheque by Post",NEFT,Stopped;
        }
        field(7; "Due Date"; Date)
        {
            Editable = false;
        }
        field(8; "Interest Amount"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Editable = true;
        }
        field(9; "Introducer Code"; Code[20])
        {
            Caption = 'Introducer Code';
            Editable = false;
            TableRelation = Vendor;
        }
        field(10; "Installment No."; Integer)
        {
            Editable = false;
        }
        field(11; "Year Code"; Integer)
        {
            Editable = false;
        }
        field(12; Stopped; Boolean)
        {
            Editable = false;
        }
        field(13; "Cheque No."; Code[10])
        {
        }
        field(14; "Cheque Date"; Date)
        {
        }
        field(15; "Bank Code"; Code[10])
        {
            TableRelation = "Bank Account";
        }
        field(16; "Cheque Status"; Option)
        {
            Editable = false;
            OptionMembers = " ","Cheque Printed","Cheque Released";
        }
        field(17; "Return Frequency"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Monthly,Quarterly,Half Yearly,Annually';
            OptionMembers = " ",Monthly,Quarterly,"Half Yearly",Annually;
        }
        field(18; "Unit Office Code"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Unit No.", "Installment No.")
        {
            Clustered = true;
        }
        key(Key2; "Unit No.", "Due Date", "Payment Mode", Stopped, "Cheque Status", "Interest Amount")
        {
        }
    }

    fieldgroups
    {
    }

    var
        RecBondEntry: Record Application;
        recCustomer: Record Customer;
        Vendor: Record Vendor;
        vMMName: Text[50];
        vMMcode: Code[20];
        vParentCode: Code[30];
        RecPmtSch: Record "Unit Maturity";
        UserSetup: Record "User Setup";
        Flag: Boolean;


    procedure FindTopParent(MM: Code[20])
    var
        vMM: Code[20];
        Vendor1: Record Vendor;
    begin
        vMM := MM;
        IF Vendor1.GET(vMM) THEN BEGIN
            IF Vendor1."BBG Rank Code" < 16 THEN BEGIN
                vMMcode := Vendor1."No.";
                vMMName := Vendor1.Name;
                FindTopParent(Vendor1."BBG Parent Code");
            END;
        END;
    end;
}

