table 50461 "Village Details"
{

    Caption = 'Village Details';
    DataCaptionFields = "Code";
    DataPerCompany = false;
    DrillDownPageID = "village details list";
    LookupPageID = "village details list";

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
        field(5; "Mandal Code"; Code[50])
        {
            Caption = 'Mandal Code';
            TableRelation = "Mandal Details".Code where("State Code" = field("State Code"), "District Code" = Field("District Code"));

        }

    }

    keys
    {
        key(Key1; "Code", "State Code", "District Code", "Mandal Code")
        {
        }

    }


}

