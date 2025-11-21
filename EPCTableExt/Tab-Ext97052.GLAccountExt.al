tableextension 97052 "EPC G/L Account Ext" extends "G/L Account"
{
    fields
    {
        // Add changes to table fields here
        field(90097; "BBG Resource Account"; Boolean)
        {
            Caption = 'Resource Account';
            DataClassification = ToBeClassified;
            Description = 'Alleas01--JPL';
        }
        field(50004; "BBG Cash Account"; Boolean)
        {
            Caption = 'Cash Account';
            DataClassification = ToBeClassified;
            Description = 'AlleDK 180908';
        }
        field(90110; "BBG Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("BBG Branch" = FILTER(true));

            trigger OnValidate()
            begin
                IF "BBG Branch Code" <> '' THEN BEGIN
                    GLAcc.RESET;
                    GLAcc.SETRANGE("BBG Branch Code", "BBG Branch Code");
                    GLAcc.SETRANGE("BBG Cash Account", TRUE);
                    IF GLAcc.FINDFIRST THEN
                        ERROR('Cash Account is already been defined for the Branch Code %1', "BBG Branch Code");
                END;
                collbranch.RESET;
                collbranch.SETRANGE(Code, "BBG Branch Code");
                IF collbranch.FINDFIRST THEN BEGIN
                    "BBG Branch Name" := collbranch.Name;
                END ELSE
                    "BBG Branch Name" := '';
            end;
        }
        field(90111; "BBG Branch Name"; Text[50])
        {
            Caption = 'Branch Name';
            DataClassification = ToBeClassified;
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
        collbranch: Record Location;
        GLAcc: Record "G/L Account";
        //VAccount: Record 16547;
        Memberof: Record "Access Control";
}