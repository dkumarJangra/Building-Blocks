table 60747 "Commission Structr Amount Base"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center 1";

            trigger OnValidate()
            begin
                // Job.RESET;
                // IF Job.GET("Project Code") THEN
                //     "Rank Code" := Job."Region Code for Rank Hierarcy"
                // ELSE
                //     "Rank Code" := '';
            end;
        }
        field(2; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
                Newconforder: Record "New Confirmed Order";
            begin


                IF "End Date" <> 0D THEN BEGIN
                    if "Start Date" > "End Date" then
                        Error('Start date can not be greater than End Date');
                END;

            end;


        }
        field(3; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Newconforder: Record "New Confirmed Order";
            begin


                IF "Start Date" <> 0D THEN BEGIN
                    if "Start Date" > "End Date" then
                        Error('End date can not be less than start Date');
                END;

            end;
        }
        field(5; "Rank Code"; Code[10])
        {
            DataClassification = ToBeClassified;

            TableRelation = "Rank Code Master";
        }
        field(6; "Desg. Code"; Decimal)
        {
            DataClassification = ToBeClassified;
            TableRelation = Rank;


        }
        field(7; "Payment Plan Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "App. Charge Code" WHERE("Sub Payment Plan" = CONST(true));

        }
        field(10; "Rate Per Square"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Commission % on Min.Allotment"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(12; "Corner Rate Per Square"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(14; "60 Ft Rate Per Square"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(15; "Corner And 60 Ft Rate Per Sq."; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(16; "East Facing Rate Per Sq."; Decimal)
        {
            DataClassification = ToBeClassified;


        }

        field(17; "% Per Square"; Decimal)
        {
            DataClassification = ToBeClassified;


        }

        field(18; "Corner % Per Square"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(19; "60 Ft % Per Square"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(20; "Corner And 60 Ft % Per Sq."; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(21; "East Facing % Per Sq."; Decimal)
        {
            DataClassification = ToBeClassified;


        }
    }

    keys
    {
        key(Key1; "Project Code", "Start Date", "End Date", "Rank Code", "Desg. Code", "Payment Plan Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Job: Record Job;

    trigger OnModify()
    var
        Newconforder: Record "New Confirmed Order";
    begin
        IF UserId <> 'BCUSER' THEN BEGIN
            IF ("Start Date" <> 0D) AND ("End Date" <> 0D) then begin
                Newconforder.RESET;
                Newconforder.SetRange("Shortcut Dimension 1 Code", "Project Code");
                Newconforder.SetRange("Posting Date", "Start Date", "End Date");
                If Newconforder.FindFirst() then
                    Error('Application already exists');
            END;
        END;
    end;
}


