table 97757 "Car Parking"
{
    DrillDownPageID = "Assocaite Web Staging Form";
    LookupPageID = "Assocaite Web Staging Form";

    fields
    {
        field(1; "Project Code"; Code[20])
        {
        }
        field(2; Type; Option)
        {
            OptionCaption = 'Covered,Open';
            OptionMembers = Covered,Open;
        }
        field(3; "Code"; Code[20])
        {
        }
        field(4; "Alloted To"; Code[20])
        {
            TableRelation = Item."No." WHERE(Type1 = CONST(Flat));
        }
        field(90011; "Sub Project Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE(Code = FILTER('PROJECT BLOCK'),
                                                          "LINK to Region Dim" = FIELD("Project Code"));
        }
    }

    keys
    {
        key(Key1; "Project Code", Type, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

