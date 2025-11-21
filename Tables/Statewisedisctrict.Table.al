table 50453 "District Details"
{
    // version NAVW19.00.00.52055,NAVIN9.00.00.52055,TDS-REGEF-194Q

    Caption = 'District Details';
    DataCaptionFields = "State Code", "State Name";
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
        field(3; "State Name"; Text[50])
        {
            Caption = 'State Name';
            Editable = False;


        }


    }

    keys
    {
        key(Key1; Code, "State Code")
        {
        }
        key(Key2; "State Code", Code)
        {
        }

    }

    fieldgroups
    {
        fieldgroup(DropDown; "State Code", Code)
        {
        }

    }

}

