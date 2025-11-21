table 50462 "Mandal Details"
{

    Caption = 'Mandal Details';
    DataCaptionFields = "Code";
    DataPerCompany = false;

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
        }

        field(2; "State Code"; Code[10])
        {
            Caption = 'State Code';
            TableRelation = State.Code;
            trigger OnValidate()
            var
                State: Record state;
            begin
                If "State Code" <> '' then begin
                    IF State.GET("State Code") then
                        "State Name" := State.Description
                    ELSE
                        "State Name" := '';
                END;
            end;
        }
        field(3; "District Code"; Code[50])
        {
            Caption = 'District Code';
            TableRelation = "District Details".Code where("State Code" = field("State Code"));

        }
        field(4; "State Name"; TExt[50])
        {
            Caption = 'State Name';
            Editable = False;

        }

    }

    keys
    {
        key(Key1; "Code", "State Code", "District Code")
        {
        }

    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "District Code", "State Code")
        {
        }

    }

}

