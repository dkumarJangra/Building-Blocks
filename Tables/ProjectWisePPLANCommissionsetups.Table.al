table 50451 "Project wise PPLAN Commission"
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


    }

    keys
    {
        key(Key1; "Project Code", "Effective From Date", "Effective To Date")
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
                Conforder.Setrange("Posting Date", "Effective From Date", "Effective To Date");
                If Conforder.FindFirst() then
                    Error('Application already exists');
            END;

        end;
    END;
}

