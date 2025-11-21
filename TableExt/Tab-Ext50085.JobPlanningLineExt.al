tableextension 50085 "BBG Job Planning Line Ext" extends "Job Planning Line"
{
    fields
    {
        // Add changes to table fields here
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                //RAHEE1.00 150512
                RecUserSetup.GET(USERID);
                "Location Code" := RecUserSetup."Purchase Resp. Ctr. Filter";
                //RAHEE1.00 150512
            end;
        }
        field(50000; "Total Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0019 23-07-2007';
        }

        field(50002; "Measure Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0019 23-07-2007';
        }
        field(50003; "Demo Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0019 23-07-2007';
        }


        field(50060; "Insert Explode Lines"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 070512';
        }


        field(50101; "Estimated Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.0';
        }
        field(50102; PVC; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.0';
        }
        field(90001; "BOQ Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
        }

        field(90004; "Unit of Measure"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
            Editable = false;
            TableRelation = "Unit of Measure";
        }
        field(90005; Material; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                CalculateRate; //ALLESP BCL0011 11-07-2007
            end;
        }
        field(90006; Labor; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                CalculateRate; //ALLESP BCL0011 11-07-2007
            end;
        }
        field(90007; Equipment; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                CalculateRate; //ALLESP BCL0011 11-07-2007
            end;
        }
        field(90008; Other; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                CalculateRate; //ALLESP BCL0011 11-07-2007
            end;
        }
        field(90009; "OverHead %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                CalculateRate; //ALLESP BCL0011 11-07-2007
            end;
        }
        field(90012; "Phase Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
        }

        field(90014; Bold; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(90016; Usage; Code[20])
        {
            Caption = 'Usage';
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                IF Usage = '' THEN
                    EXIT;

                CASE Type OF
                    Type::"G/L Account":
                        BEGIN
                            GLAcc.GET(Usage);
                            GLAcc.CheckGLAcc;
                            GLAcc.TESTFIELD("Direct Posting", TRUE);
                        END;
                END;
            end;
        }
        field(90017; Selected; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Alleab';

            trigger OnValidate()
            begin
                BEGIN
                    IF xRec.Selected = TRUE THEN
                        IF CONFIRM('Do you want to remove selection?', FALSE) THEN
                            Selected := FALSE
                        ELSE
                            Selected := TRUE;

                END;
            end;
        }
        field(90018; "This Bill Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 1 : 3;
            Description = 'Alleab';
        }
        field(90019; "BOQ Rate Inclusive Tax"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB20-03';
        }
        field(90020; "Rate Only"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB25-03';
        }
        field(90021; "Non Schedule"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB25-03';
        }

        field(90023; "G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
            TableRelation = "G/L Account" WHERE("Direct Posting" = FILTER(false));
        }

        field(90025; "Posted Quantity"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job Contract Entry No." = FIELD("Job Contract Entry No.")));
            Caption = 'Posted Quantity';
            Description = 'ALLEAA';
            Editable = false;
            FieldClass = FlowField;
        }





        field(90033; "Percent Change"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90034; "BBG BOM Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';
            TableRelation = Item;
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
        JobMaster: Record "Job Master";
        GLBudgetEntry: Record "G/L Budget Entry";
        RecUserSetup: Record "User Setup";
        RecRespCenter: Record "Responsibility Center 1";
        GLAcc: Record "G/L Account";

    trigger OnBeforeDelete()
    begin
        //RAHEE1.00 080512
        IF Job.GET("Job No.") THEN
            IF (Job.Approved) THEN BEGIN
                IF (Job.Amended = TRUE) AND (Job."Amendment Approved" = TRUE) THEN
                    ERROR('Please first Amend this job')
                ELSE IF (Job.Amended = FALSE) THEN
                    ERROR('Please first Amend this job');
            END;
        //RAHEE1.00 080512



        //TESTFIELD(Transferred,FALSE);

        // ALLEPG 041011 Start
        GLBudgetEntry.RESET;
        GLBudgetEntry.SETRANGE("Job Contract Entry No.", "Job Contract Entry No.");
        IF GLBudgetEntry.FINDFIRST THEN
            GLBudgetEntry.DELETE(TRUE);
        // ALLEPG 041011 End

    end;

    PROCEDURE CalculateRate();
    BEGIN
        //ALLESP BCL0011 11-07-2007 Start:
        "Direct Unit Cost (LCY)" := (Material + Labor + Equipment + Other) * (1 + ("OverHead %" / 100));
        "Unit Cost" := (Material + Labor + Equipment + Other) * (1 + ("OverHead %" / 100));
        IF ("Unit Cost" <> xRec."Unit Cost") OR ("Unit Price" <> xRec."Unit Price") THEN;
        //  UpdateJobBudgetEntry;
        //ALLESP BCL0011 11-07-2007 End:
    END;
}