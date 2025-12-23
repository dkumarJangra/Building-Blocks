table 50200 "Region/Districts Rank Entry"
{
    DataPerCompany = false;
    DrillDownPageId = "Region/Districts default Rank";
    fields
    {
        field(1; "Region_Districts Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Region_districtsRankEntry: Record "Region/Districts Rank Entry";  //18122025
            begin
                //Code added 18122025 Start
                Region_districtsRankEntry.RESET;
                Region_districtsRankEntry.SetRange("Region_Districts Code", Rec."Region_Districts Code");
                IF Region_districtsRankEntry.Count > 1 THEN
                    Error('Data already Exists against =' + Rec."Region_Districts Code");
                //Code added 18122025 END
            end;
        }
        Field(2; Rank; Decimal)
        {
            DataClassification = ToBeClassified;
            TableRelation = Rank;
            trigger OnValidate()
            var
                Rank_1: Record Rank;
                Region_districtsRankEntry: Record "Region/Districts Rank Entry";  //18122025
            begin
                TestField("Region/Rank Code");
                IF "Region/Rank Code" = 'R0003' then
                    Error('Region/Rank Code should not be R0003');
                //Code addded 18122025 Start
                IF Rank <> 0 THEN begin
                    Region_districtsRankEntry.RESET;
                    Region_districtsRankEntry.SetRange("Region_Districts Code", Rec."Region_Districts Code");
                    IF Region_districtsRankEntry.Count > 1 THEN
                        Error('Data already Exists against =' + Rec."Region_Districts Code");
                end;
                //Code addded 18122025 END

                Rank_1.RESET;
                IF Rank_1.GET(Rank) THEN
                    Description := Rank_1.Description
                ELSE
                    Description := '';
            end;
        }

        field(3; Description; Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = False;
        }
        field(4; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Active,In-Active';
            OptionMembers = Active,"In-Active";
        }
        field(5; "State Code"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Cluster State Master";
            trigger OnValidate()
            Var
                ClusterstateMaster: Record "Cluster State Master";
                Region_districtsRankEntry: Record "Region/Districts Rank Entry";  //18122025

            begin
                //Code added 18122025 Start
                Region_districtsRankEntry.RESET;
                Region_districtsRankEntry.SetRange("Region_Districts Code", Rec."Region_Districts Code");
                IF Region_districtsRankEntry.Count > 1 THEN
                    Error('Data already Exists against =' + Rec."Region_Districts Code");


                //Code added 18122025 END



                IF "State Code" <> 0 THEN begin
                    ClusterstateMaster.RESET;
                    IF ClusterstateMaster.GET("State Code") then begin
                        "State Name" := ClusterstateMaster."State Name";
                        //Code commented 18122025 Start
                        //     IF "State Code" = 1 then
                        //         "Region/Rank Code" := 'R0001';
                        //     IF "State Code" = 2 then
                        //         "Region/Rank Code" := 'R0002';
                        //     IF "State Code" = 3 then
                        //         "Region/Rank Code" := 'R0003';

                        // END ELSE begin
                        //     "State Name" := '';
                        //     "Region/Rank Code" := '';
                        // end;
                        //Code commented 18122025 END
                    end;


                end;
            END;

        }
        field(8; "State Name"; text[100])
        {
            DataClassification = ToBeClassified;
            Editable = False;

        }
        Field(9; "Region/Rank Code"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Rank Code Master".Code;
            //Editable = false;
        }


    }

    keys
    {
        key(Key1; "Region_Districts Code", Rank)

        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

