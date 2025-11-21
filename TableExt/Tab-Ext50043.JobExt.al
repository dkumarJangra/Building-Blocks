tableextension 50043 "BBG Job Ext" extends Job
{
    fields
    {
        // Add changes to table fields here
        modify("Bill-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                // ALELAA
                TESTFIELD("Sent for Approval", FALSE);
                TESTFIELD(Approved, FALSE);
                Blocked := Blocked::Posting;
                "Job Creation Date" := TODAY;
                "Job Creation Time" := TIME;
                // ALELAA
            end;
        }
        modify("Starting Date")
        {
            trigger OnAfterValidate()
            begin
                TESTFIELD(Status, Status::Planning);
            end;
        }
        modify("Ending Date")
        {
            trigger OnAfterValidate()
            begin
                TESTFIELD(Status, Status::Planning);
            end;
        }
        modify(Status)
        {
            trigger OnAfterValidate()
            Begin
                Memberof.RESET;
                Memberof.SETRANGE("User Name", USERID);
                Memberof.SETFILTER("Role ID", 'A_CHANGEJOBSTATUS');
                IF NOT Memberof.FINDFIRST THEN
                    ERROR('Sorry, You do not have rights to change the status');

            End;
        }

        field(50001; "Extension Given From"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 05-07-2007';
        }
        field(50002; "Extension Given To"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 05-07-2007';
        }
        field(50003; "Defect Liability (Year)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Description = 'ALLESP BCL0004 05-07-2007';
        }
        field(50004; "Defect Liability (Month)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Description = 'ALLESP BCL0004 05-07-2007';
            MaxValue = 12;
            MinValue = 0;
        }
        field(50005; "Concession Period (Year)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Description = 'ALLESP BCL0004 05-07-2007';
        }
        field(50006; "Concession Period (Month)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Description = 'ALLESP BCL0004 05-07-2007';
            MaxValue = 12;
            MinValue = 0;
        }

        field(50008; "LOI Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 05-07-2007';
        }
        field(50009; "Contract Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 05-07-2007';
            OptionCaption = 'EPC-Item BOQ,EPC-LumpSum,BOT,BOT Annuity,Others';
            OptionMembers = "EPC-Item BOQ","EPC-LumpSum",BOT,"BOT Annuity",Others;
        }
        field(50018; "Explosives Required"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 05-07-2007';

            trigger OnValidate()
            begin
                //ALLESP BCL0004 06-07-2007 Start:
                IF Rec."Explosives Required" <> xRec."Explosives Required" THEN
                    "Explosives Supplied By" := 0;
                //ALLESP BCL0004 06-07-2007 End:
            end;
        }
        field(50019; "Explosives Supplied By"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 05-07-2007';
            OptionCaption = ' ,Client,Contractor';
            OptionMembers = " ",Client,Contractor;
        }
        field(50020; "Mobilization Advance"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Entry Type" = CONST("Initial Entry"),
                                                                                  "Posting Type" = CONST("Mobilization Advance"),
                                                                                  "Document Type" = CONST(Payment)));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50021; "Equipment Advance"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Entry Type" = CONST("Initial Entry"),
                                                                                  "Posting Type" = CONST("Equipment Advance"),
                                                                                  "Document Type" = CONST(Payment)));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50022; "Secured Advance"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Entry Type" = CONST("Initial Entry"),
                                                                                  "Posting Type" = CONST("Secured Advance"),
                                                                                  "Document Type" = CONST(Payment)));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50023; "Adhoc Advance"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Entry Type" = CONST("Initial Entry"),
                                                                                  "Posting Type" = CONST("Adhoc Advance"),
                                                                                  "Document Type" = CONST(Payment)));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50024; "Initial Security Deposit Amt."; Decimal)
        {
            // CalcFormula = Sum("LC Detail"."LC Value" WHERE(Type = CONST(ABG),
            //                                                 "Project Code" = FIELD("No.")));
            // Description = 'ALLESP BCL0005 06-07-2007';
            // FieldClass = FlowField;
        }
        field(50025; "Earnest Money Deposit Amt."; Decimal)
        {
            // CalcFormula = Sum("LC Detail"."LC Value" WHERE(Type = CONST(PBG),
            //                                                 "Project Code" = FIELD("No.")));
            // Description = 'ALLESP BCL0005 06-07-2007';
            // FieldClass = FlowField;
        }

        field(50027; "Project Site Location"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 11-07-2007';
            TableRelation = Location;
        }
        field(50029; "Project Status"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 05-07-2007';
            OptionCaption = 'Yet to Take Off,In Progress,Completed';
            OptionMembers = "Yet to Take Off","In Progress",Completed;

            trigger OnValidate()
            begin
                //ALLESP BCL0004 12-07-2007 Start:
                IF "Project Status" = xRec."Project Status" THEN
                    EXIT;
                //ALLESP BCL0004 12-07-2007 End:
                //SC 280907 --
                IF "Project Status" < xRec."Project Status" THEN
                    ERROR(Text005);
                //SC ++
            end;
        }
        field(50032; "Performance Gurantee Amt."; Decimal)
        {
            // CalcFormula = Sum("LC Detail"."LC Value" WHERE(Type = CONST(Earnest),
            //                                                 "Project Code" = FIELD("No.")));
            // Description = 'ALLESP BCL0005 06-07-2007';
            // FieldClass = FlowField;
        }
        field(50037; "Agreement Signing Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 31-07-2007';
        }

        field(50039; "Deposit Against Advance"; Decimal)
        {
            // CalcFormula = Sum("LC Detail"."LC Value" WHERE(Type = CONST(Others),
            //                                                 "Project Code" = FIELD("No.")));
            // Description = 'ALLESP BCL0005 06-07-2007';
            // FieldClass = FlowField;
        }
        field(50040; "Security Deposit Amt."; Decimal)
        {
            // CalcFormula = Sum("LC Detail"."LC Value" WHERE(Type = CONST(Bond),
            //                                                 "Project Code" = FIELD("No.")));
            // Description = 'ALLESP BCL0005 06-07-2007';
            // FieldClass = FlowField;
        }
        field(50041; LC; Decimal)
        {
            // CalcFormula = Sum("LC Detail"."LC Value" WHERE(Type = CONST(LC),
            //                                                 "Project Code" = FIELD("No.")));
            // Description = 'ALLESP BCL0005 06-07-2007';
            // FieldClass = FlowField;
        }
        field(50042; "Other Material Requried"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 05-07-2007';
        }
        field(50043; "Material Supplied By"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 05-07-2007';
            OptionCaption = ' ,Client,Contractor';
            OptionMembers = " ",Client,Contractor;
        }





        field(50056; "LOI No."; Text[60])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 25-09-2007';
        }

        field(50073; "Transmittal Name"; Text[50])
        {
            Caption = 'Transmittal Name';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50074; "Transmittal Address"; Text[50])
        {
            Caption = 'Transmittal Address';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50075; "Transmittal Address 2"; Text[50])
        {
            Caption = 'Transmittal Address 2';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50076; "Transmittal City"; Text[50])
        {
            Caption = 'Transmittal City';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';

            trigger OnLookup()
            begin
                PostCode.LookUpCity("Transmittal City", "Transmittal Post Code", TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity("Transmittal City","Transmittal Post Code"); // ALLE MM Code Commented
            end;
        }
        field(50077; "Transmittal Post Code"; Code[20])
        {
            Caption = 'Transmittal Post Code';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookUpPostCode("Transmittal City", "Transmittal Post Code", TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode("Transmittal City","Transmittal Post Code");  // ALLE MM Code Commented
            end;
        }
        field(50078; "Transmittal Country/Region"; Code[10])
        {
            Caption = 'Transmittal Country/Region';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
            Editable = true;
            TableRelation = "Country/Region";
        }

        field(50100; "Estimated Value"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Estimated Value" WHERE("Job No." = FIELD("No."),
                                                                           "Estimated Value" = FILTER(> 0)));
            Description = 'RAHEE1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50101; Composite; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.0 170412';
        }
        field(50102; "Sent for Approval Amend Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.0 040412';
        }
        field(50103; "Sent for Approval Amend Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.0 040412';
        }
        field(50104; "Sent for Approval Amend Job"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.0 040412';
        }

        field(50115; "Refund %"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Job_1: Record Job;
            begin
                TESTFIELD(Status, Status::Planning);
                CompanywiseAccount.RESET;
                CompanywiseAccount.SETRANGE("MSC Company", TRUE);
                IF CompanywiseAccount.FINDFIRST THEN BEGIN
                    Job_1.RESET;
                    Job_1.CHANGECOMPANY(CompanywiseAccount."Company Code");
                    Job_1.SETRANGE("No.", "No.");
                    IF Job_1.FINDFIRST THEN BEGIN
                        Job_1."Refund %" := "Refund %";
                        Job_1.MODIFY;
                    END;
                END;
            end;
        }



        field(50119; "Regd Numbers"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckPermission;
            end;
        }
        field(50120; "Regd date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckPermission;
            end;
        }
        field(50121; "Payment plan"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckPermission;
            end;
        }
        field(50122; Doj; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckPermission;
            end;
        }
        field(50123; "Blocked Comment"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckPermission;
            end;
        }
        field(50124; Ldp; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckPermission;
            end;
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
        RecUserSetup: Record "User Setup";
        RankCode_1: Record "Rank Code";
        CommissionStructure: Record "Commission Structure";
        CompanywiseAccount: Record "Company wise G/L Account";
        RecJob: Record Job;
        DocSetup: Record "Document Type Setup";
        DocApproval: Record "Document Type Approval";
        DocumentApproval: Record "Document Type Approval";
        DocApproval1: Record "Document Type Approval";
        Application: Record Application;
        ConfOrder: Record "Confirmed Order";
        Memberof: Record "Access Control";
        WorkFlowDocSetup: Record "Workflow Doc. Type Setup";
        UserMgt: Codeunit "User Management";
        UserSetup: Record "User Setup";
        DocumentMaster_1: Record "Document Master";
        Text005: Label 'Contact %1 %2 is related to a different company than customer %3.';
        PostCode: Record "Post Code";

    trigger OnBeforeInsert()
    begin
        IF WORKDATE < 20080221D THEN
            ERROR('You can not work on this workdate');

        //alleab
        "USER ID" := USERID;
        //JPL START

        RecUserSetup.GET(USERID);
        "Responsibility Center" := RecUserSetup."Purchase Resp. Ctr. Filter";

        //alleab
    end;

    trigger OnAfterInsert()
    begin
        Blocked := Blocked::Posting; // ALLEAA

        //ALLEDK 030715
        Initiator := USERID;
        "Job Creation Date" := TODAY;
        "Job Creation Time" := TIME;
    end;

    trigger OnAfterModify()
    begin
        //TESTFIELD(Approved,FALSE); // ALLEAA
        //RAHEE1.00 040512
        IF (Approved) THEN BEGIN
            IF (Amended = TRUE) AND ("Amendment Approved" = TRUE) THEN
                ERROR('Please first Amend this job')
            ELSE IF (Amended = FALSE) THEN
                ERROR('Please first Amend this job');
        END;
        //RAHEE1.00 040512
    end;

    trigger OnBeforeDelete()
    begin
        TESTFIELD(Approved, FALSE); // ALLEAA
    end;

    PROCEDURE ShowDocument();
    VAR
        NewDocTrack: Record "New Document Tracking";
        NewDocTrackFrm: Page "New Document Trackings";
    BEGIN
        NewDocTrack.SETRANGE("Table ID", DATABASE::Job);
        NewDocTrack.SETRANGE("Document Type", 0);
        NewDocTrack.SETRANGE("Document No.", "No.");
        NewDocTrack.SETRANGE("Line No.", 0);
        NewDocTrackFrm.SETTABLEVIEW(NewDocTrack);
        NewDocTrackFrm.RUNMODAL;
        GET("No.");
    END;

    PROCEDURE CheckPermission();
    BEGIN
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'A_CHANGEJOBDetails');
        IF NOT Memberof.FINDFIRST THEN
            ERROR('Sorry, You do not have rights to change the Details');
    END;

}