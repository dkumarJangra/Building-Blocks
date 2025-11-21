table 50435 "Project wise Appl. Setup"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            TableRelation = "Responsibility Center 1".Code;

            trigger OnValidate()
            var
                RespCenter: Record "Responsibility Center 1";
            begin
                RespCenter.Reset();
                If RespCenter.GET("Project Code") then
                    "Project Name" := RespCenter.Name
                ELSE
                    "Project Name" := '';

            end;

        }
        field(2; "Project Name"; TExt[100])
        {
            Editable = False;



        }
        field(3; "Project Rank Code"; Code[10])
        {

            TableRelation = "Rank Code Master";
            trigger OnValidate()
            var
                ProjectwiseAppSetup: Record "Project wise Appl. Setup";
                RankCodemaster: Record "Rank Code Master";
            begin
                TestField("Effective From Date");
                TestField("Effective To Date");
                RankCodemaster.RESET;
                IF RankCodemaster.GET("Project Rank Code") then
                    "Project Rank Description" := RankCodemaster.Description
                ELSE
                    "Project Rank Description" := '';

                IF ("Effective From Date" <> 0D) and ("Effective To Date" <> 0D) THEN begin
                    ProjectwiseAppSetup.RESET;
                    ProjectwiseAppSetup.SetRange("Project Code", "Project Code");
                    ProjectwiseAppSetup.SetFilter("Effective From Date", '<%1', "Effective From Date");
                    ProjectwiseAppSetup.SetFilter("Effective To Date", '>%1', "Effective To Date");
                    ProjectwiseAppSetup.SetRange("Project Rank Code", "Project Rank Code");
                    If ProjectwiseAppSetup.FindFIRST() then
                        Error('Setup already lie between' + Format("Effective From Date") + '..' + Format("Effective To Date"));
                END;



            end;
        }
        field(4; "Project Rank Description"; Text[50])
        {
            Editable = False;


        }
        field(5; "Effective From Date"; Date)
        {
            trigger OnValidate()
            var
                Conforder: Record "Confirmed Order";

            begin
                IF "Effective To Date" <> 0D then
                    If "Effective From Date" > "Effective To Date" then
                        Error('Effective From Date can not be greater than ' + Format("Effective To Date"));


            end;

        }
        field(6; "Effective To Date"; Date)
        {
            trigger OnValidate()
            var
                Conforder: Record "New Confirmed Order";
            begin
                IF "Effective From Date" <> 0D then
                    If "Effective To Date" < "Effective From Date" then
                        Error('Effective to Date can not be less than ' + Format("Effective from Date"));

            end;

        }
        field(7; "Travel Applicable"; Boolean)
        {
            trigger OnValidate()
            var
                ProjectwiseAppSetup: Record "Project wise Appl. Setup";
                RankCodemaster: Record "Rank Code Master";
            begin


                IF ("Effective From Date" <> 0D) and ("Effective To Date" <> 0D) THEN begin
                    ProjectwiseAppSetup.RESET;
                    ProjectwiseAppSetup.SetRange("Project Code", "Project Code");
                    ProjectwiseAppSetup.SetFilter("Effective From Date", '<%1', "Effective From Date");
                    ProjectwiseAppSetup.SetFilter("Effective To Date", '>%1', "Effective To Date");
                    ProjectwiseAppSetup.SetRange("Project Rank Code", "Project Rank Code");
                    If ProjectwiseAppSetup.FindFIRST() then
                        Error('Setup already lie between' + Format("Effective From Date") + '..' + Format("Effective To Date"));
                END;
            END;

        }
        field(8; "Registration Bonus (BSP2)"; Boolean)
        {
            trigger OnValidate()
            var
                ProjectwiseAppSetup: Record "Project wise Appl. Setup";
                RankCodemaster: Record "Rank Code Master";
            begin


                IF ("Effective From Date" <> 0D) and ("Effective To Date" <> 0D) THEN begin
                    ProjectwiseAppSetup.RESET;
                    ProjectwiseAppSetup.SetRange("Project Code", "Project Code");
                    ProjectwiseAppSetup.SetFilter("Effective From Date", '<%1', "Effective From Date");
                    ProjectwiseAppSetup.SetFilter("Effective To Date", '>%1', "Effective To Date");
                    ProjectwiseAppSetup.SetRange("Project Rank Code", "Project Rank Code");
                    If ProjectwiseAppSetup.FindFIRST() then
                        Error('Setup already lie between' + Format("Effective From Date") + '..' + Format("Effective To Date"));
                END;
            END;

        }
        Field(9; "Commission Structure Code"; Code[20])
        {
            TableRelation = "Unit Type".Code;
            trigger OnValidate()
            var
                ProjectwiseAppSetup: Record "Project wise Appl. Setup";
                RankCodemaster: Record "Rank Code Master";
            begin


                IF ("Effective From Date" <> 0D) and ("Effective To Date" <> 0D) THEN begin
                    ProjectwiseAppSetup.RESET;
                    ProjectwiseAppSetup.SetRange("Project Code", "Project Code");
                    ProjectwiseAppSetup.SetFilter("Effective From Date", '<%1', "Effective From Date");
                    ProjectwiseAppSetup.SetFilter("Effective To Date", '>%1', "Effective To Date");
                    ProjectwiseAppSetup.SetRange("Project Rank Code", "Project Rank Code");
                    If ProjectwiseAppSetup.FindFIRST() then
                        Error('Setup already lie between' + Format("Effective From Date") + '..' + Format("Effective To Date"));
                END;
            END;
        }

    }

    keys
    {
        key(Key1; "Project Code", "Effective From Date", "Effective To Date", "Project Rank Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
    trigger OnModify()
    var
        Conforder: Record "New Confirmed Order";
    begin

        IF UserId <> 'BCUSER' THEN BEGIN
            IF ("Effective From Date" <> 0D) AND ("Effective To Date" <> 0D) THEN BEGIN
                Conforder.RESET;
                Conforder.SetRange("Shortcut Dimension 1 Code", "Project Code");
                Conforder.SetRange("Region Code", "Project Rank Code");
                Conforder.Setrange("Posting Date", "Effective From Date", "Effective To Date");
                If Conforder.FindFirst() then
                    Error('Application already exists');
            END;

        end;
    END;
}

