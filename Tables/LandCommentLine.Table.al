table 60725 "Land Comment Line"
{
    // ALLETG RIL0012 12-07-2011: Added Option 'Activity Master' in 'Table Name' Field

    Caption = 'Land Comment Line';
    //DrillDownPageID = 60714;
    //LookupPageID = 60714;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(7; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Alle';
            Editable = false;
        }
        field(8; "Comment Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
            OptionCaption = ' ,Associate Change';
            OptionMembers = " ","Associate Change";
        }
        field(9; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //ALLETDK>>
        IF "Comment Type" <> "Comment Type"::" " THEN
            ERROR('This Comment Cannot be deleted');
        //ALLETDK<<<
    end;

    trigger OnInsert()
    begin
        "Creation Date" := TODAY;
        "Creation Time" := TIME;
        "User ID" := USERID;
    end;


    procedure SetUpNewLine()
    var
        CommentLine: Record "Land Comment Line";
    begin
        CommentLine.SETRANGE("No.", "No.");
        CommentLine.SETRANGE(Date, WORKDATE);
        IF NOT CommentLine.FINDFIRST THEN
            Date := WORKDATE;
    end;
}

