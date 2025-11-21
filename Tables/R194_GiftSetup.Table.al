table 50152 "R194 Gift Setup"
{

    fields
    {
        field(1; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Extent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Gift Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = False;
        }
        field(5; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = False;
        }
        field(6; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = False;
        }
        field(7; "Plots"; integer)
        {
            DataClassification = ToBeClassified;

        }
        Field(8; "Gift Item No."; code[20])
        {
            DataClassification = ToBeClassified;

        }
        Field(9; "Item Description"; Text[100])
        {

            Caption = 'Item Description';
            CalcFormula = Lookup("Item"."Description" WHERE("No." = FIELD("Gift Item No.")));
            FieldClass = FlowField;

        }

    }

    keys
    {
        key(Key1; "Start Date", Extent)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "Creation Date" := Today;
        "Creation Time" := Time;
        "Created By" := USERID;
    end;

}

