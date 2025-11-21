table 50050 "Verita Application Data"
{
    DataPerCompany = false;

    fields
    {
        field(2; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Tally Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Development Receipt Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Cheque No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Cheque Bank and Branch"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Cheque Status"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Ch. Clearance / Bounce Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Deposit/Paid Bank"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Project code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "GST Group Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "GST Group Type"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "HSN/SAC Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "GST Base mount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "CGST Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "SGST Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "IGST Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Total Developmnt Charge Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Create Charge Lines"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(26; Remarks; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(27; Type; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Last App batch"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Application No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

