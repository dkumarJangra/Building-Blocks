table 60738 "LOAN EMI Document"
{
    Caption = 'LOAN EMI Document';

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Salaried,NRI,Self-Employed,Self-Employed SEP';
            OptionMembers = " ",Salaried,NRI,"Self-Employed","Self-Employed SEP";
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Customer Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Customer Name 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Customer Mobile No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Monthly Income"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Tenure; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; Obligation; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Project Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; Extent; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Loan Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "EMI Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Rate of Interest"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Document No." = '' THEN BEGIN
            BBGSetups.GET;
            BBGSetups.TESTFIELD("Loan EMI No. Series");
            "Document No." := NoSeriesManagement.GetNextNo(BBGSetups."Loan EMI No. Series", TODAY, TRUE);
            "Creation Date" := TODAY;
            "Creation Time" := TIME;
        END;
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        BBGSetups: Record "BBG Setups";
}

