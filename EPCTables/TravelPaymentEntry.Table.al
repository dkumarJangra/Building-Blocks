table 97829 "Travel Payment Entry"
{

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Responsibility Center 1";

            trigger OnValidate()
            begin
                LedgerSetup.GET;
                IF DimValue.GET(LedgerSetup."Global Dimension 1 Code", "Project Code") THEN
                    "Project Name" := DimValue.Name;
            end;
        }
        field(2; "Project Name"; Text[50])
        {
            Editable = false;
        }
        field(3; "Team Lead"; Code[20])
        {
            Editable = true;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF "Team Lead" <> '' THEN BEGIN
                    IF Vend.GET("Team Lead") THEN
                        "Team Lead Name" := Vend.Name;
                END ELSE
                    "Team Lead Name" := '';
            end;
        }
        field(4; "Team Lead Name"; Text[60])
        {
            Editable = false;
        }
        field(5; "Amount to Pay"; Decimal)
        {
            Editable = true;

            trigger OnValidate()
            begin
                //IF "Amount to Pay" > Amount THEN
                //  ERROR('Amount to Pay can not be greater than Amount');

                TDSCalculation;
            end;
        }
        field(7; "Sub Associate Code"; Code[20])
        {
            Editable = true;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF "Sub Associate Code" <> '' THEN BEGIN
                    IF Vend.GET("Sub Associate Code") THEN
                        "Sub Associate Name" := Vend.Name;
                END ELSE
                    "Sub Associate Name" := '';
            end;
        }
        field(8; "Sub Associate Name"; Text[60])
        {
            Editable = false;
        }
        field(9; "Creation Date"; Date)
        {
        }
        field(10; "Post from Approval"; Boolean)
        {
        }
        field(11; "Document No."; Code[20])
        {
            TableRelation = "Travel Header"."Document No." WHERE("Document No." = FIELD("Document No."));
        }
        field(12; "Line No."; Integer)
        {
        }
        field(17; "Cheque No."; Code[10])
        {
        }
        field(18; "Bank Acc. No."; Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                IF "Bank Acc. No." <> '' THEN
                    IF BAcc.GET("Bank Acc. No.") THEN
                        "Bank Name" := BAcc.Name;
            end;
        }
        field(19; "Cheque Date"; Date)
        {
        }
        field(20; "Bank Name"; Text[60])
        {
            Editable = false;
        }
        field(21; "Parent Code"; Code[20])
        {
            Editable = true;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF "Parent Code" <> '' THEN BEGIN
                    IF Vend1.GET("Parent Code") THEN
                        "Parent Name" := Vend1.Name;
                END ELSE
                    "Parent Name" := '';
            end;
        }
        field(22; "Activity Break down Str"; Text[30])
        {
            Editable = false;
        }
        field(23; "Sent for Approval"; Boolean)
        {
            Editable = true;

            trigger OnValidate()
            begin
                TESTFIELD(Approved, FALSE);

                IF "Sent for Approval" THEN BEGIN
                    "Sent By for Approval" := USERID;
                    USER.RESET;
                    USER.SETRANGE("User Name", USERID);
                    IF USER.FINDFIRST THEN
                        "Approval Sender  Name" := USER."User Name";
                END ELSE BEGIN
                    "Sent By for Approval" := '';
                    "Approval Sender  Name" := '';
                END;
            end;
        }
        field(24; Approved; Boolean)
        {
            Editable = true;

            trigger OnValidate()
            begin
                MemberOf.RESET;
                MemberOf.SETRANGE("User Name", USERID);
                MemberOf.SETRANGE("Role ID", 'TAAPP');
                IF NOT MemberOf.FINDFIRST THEN
                    ERROR('You are not authorised to Approved this Eligibility');
                IF Approved THEN BEGIN
                    "Approved By" := USERID;
                    USER.RESET;
                    USER.SETRANGE("User Name", USERID);
                    IF USER.FINDFIRST THEN
                        "Approver Name" := USER."User Name";
                END ELSE BEGIN
                    "Approved By" := '';
                    "Approver Name" := '';
                END;
            end;
        }
        field(26; "Parent Name"; Text[60])
        {
            Editable = false;
        }
        field(28; Retrun; Boolean)
        {
        }
        field(31; Status; Option)
        {
            Description = 'BBG1.01';
            Editable = false;
            OptionCaption = 'Normal,Return';
            OptionMembers = Normal,Return;
        }
        field(32; "Approver Name"; Text[60])
        {
            Editable = false;
        }
        field(33; "Approval Sender  Name"; Text[60])
        {
            Editable = false;
        }
        field(34; "Approved By"; Code[20])
        {
            Editable = false;
        }
        field(35; "Sent By for Approval"; Code[20])
        {
            Editable = false;
        }
        field(36; "TA Creation on Commission Vouc"; Boolean)
        {
        }
        field(37; "TDS Amount"; Decimal)
        {
            Editable = true;
        }
        field(40; Month; Integer)
        {
            Description = 'ALLEPG 271112';
        }
        field(41; Year; Integer)
        {
            Description = 'ALLEPG 271112';
        }
        field(42; "Ready for Payment"; Boolean)
        {
        }
        field(43; "TA Rate"; Decimal)
        {

            trigger OnValidate()
            begin
                //"Amount to Pay" := "TA Rate" * "Total Area";
            end;
        }
        field(44; "Total Area"; Decimal)
        {
            Editable = true;
        }
        field(45; Type; Option)
        {
            OptionCaption = 'Team,Individual';
            OptionMembers = Team,Individual;
        }
        field(46; "Voucher No."; Code[20])
        {
        }
        field(47; "TDS %"; Decimal)
        {
        }
        field(48; "Remaining Amount"; Decimal)
        {
            Editable = true;
        }
        field(50000; "Adjust Remaining Amt"; Boolean)
        {
            Description = 'BBG1.00 190413';
        }
        field(50001; "Post Payment"; Boolean)
        {
            Description = 'BBG1.00 190413';
        }
        field(50002; "Entry No."; Integer)
        {
        }
        field(50003; Reverse; Boolean)
        {
            Description = 'ALLETDK250413';
        }
        field(50004; "Application No."; Code[20])
        {
            Description = 'ALLETDK050513';
            Editable = true;
        }
        field(50005; CreditMemo; Boolean)
        {
        }
        field(50006; "CreditMemo No."; Code[20])
        {
        }
        field(50007; "ARm TA Code"; Code[20])
        {
            CalcFormula = Lookup("Travel Header"."ARM TA Code" WHERE("Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(50009; RecordFind; Boolean)
        {
        }
        field(50010; "Check Record"; Boolean)
        {
        }
        field(50021; "Entry Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'INS1.0';
            Editable = false;
        }
        field(50027; "Pmt User ID"; Code[20])
        {
        }
        field(50028; "Pmt Date Time"; DateTime)
        {
        }
        field(50029; Remark; Text[50])
        {
        }
        field(50030; "Payment PostDate"; Date)
        {
        }
        field(50031; "Invoice Date"; Date)
        {
            Editable = false;
        }
        field(50032; "TDS Deducat on Invoice"; Decimal)
        {
            CalcFormula = Sum("TDS Entry"."TDS Amount" WHERE("Document Type" = FILTER(Invoice),
                                                              "Document No." = FIELD("Voucher No.")));
            FieldClass = FlowField;
        }
        field(50033; "Appl. Not Show on Travel Form"; Boolean)
        {
            Editable = false;
        }
        field(50034; "TDS Base Amount"; Decimal)
        {
            CalcFormula = Sum("TDS Entry"."TDS Base Amount" WHERE("Document Type" = FILTER(Invoice),
                                                                   "Document No." = FIELD("Voucher No.")));
            FieldClass = FlowField;
        }
        field(50100; "Data create with Batch"; Boolean)
        {
            Editable = false;
        }
        field(50101; "Create Travel Pmt Entry"; Boolean)
        {
        }
        field(50102; "Records exister"; Boolean)
        {
        }
        field(50103; "Not consider in CommReport"; Boolean)
        {
        }
        field(50104; "For Report"; Boolean)
        {
        }
        field(50105; "Old Company Name"; Text[30])
        {
            TableRelation = Company;
        }
        field(50106; Month_1; Integer)
        {
        }
        field(50107; Year_1; Integer)
        {
        }
        field(50108; "Invoice Post Date"; Date)
        {
        }
        field(50109; "FIND Ent"; Boolean)
        {
        }
        field(50110; "Invoice Adjust amt"; Decimal)
        {
        }
        field(50111; "Posted marked by batch"; Boolean)
        {
            Editable = false;
        }
        field(50112; "Block Associate"; Boolean)
        {
            CalcFormula = Lookup(Vendor."BBG Black List" WHERE("No." = FIELD("Sub Associate Code")));
            FieldClass = FlowField;
        }
        field(50200; "Associate for TA Transfer"; Boolean)
        {
            Editable = false;
        }
        field(50201; "Docuemnt Transfer"; Boolean)
        {
            Editable = false;
        }
        field(50202; "TA Reverse for LLP Name"; Text[50])
        {
            Editable = false;
        }
        field(50203; "BBP TA Document No."; Code[20])
        {
            Editable = false;
        }
        field(50204; "BBP TA Document Lin No."; Integer)
        {
            Editable = false;
        }
        field(50205; "Company Name"; Text[50])
        {
            Editable = true;
            TableRelation = Company;
        }
        field(50206; "Generate Payment Details"; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            SumIndexFields = "Amount to Pay", "TA Rate";
        }
        key(Key2; "Project Code", "Team Lead")
        {
            Clustered = true;
        }
        key(Key3; "Sub Associate Code", "Voucher No.")
        {
            SumIndexFields = "Amount to Pay";
        }
        key(Key4; "Sub Associate Code", Month, Year, Approved)
        {
        }
        key(Key5; "Voucher No.")
        {
        }
        key(Key6; "Sub Associate Code", "Creation Date", Approved, Reverse, CreditMemo, "Not consider in CommReport")
        {
            SumIndexFields = "Amount to Pay";
        }
        key(Key7; "Sub Associate Code", "Creation Date", Approved, "TA Creation on Commission Vouc")
        {
        }
        key(Key8; "Sub Associate Code", "Remaining Amount")
        {
        }
        key(Key9; "Document No.", "Post Payment")
        {
            SumIndexFields = "Amount to Pay";
        }
        key(Key10; "Post Payment")
        {
        }
        key(Key11; "Old Company Name", "Sub Associate Code", "Invoice Post Date")
        {
        }
        key(Key12; "Sub Associate Code", Year_1, Month_1)
        {
        }
        key(Key13; "Application No.", "Voucher No.", "Post Payment")
        {
            SumIndexFields = "Amount to Pay";
        }
        key(Key14; "Sub Associate Code", "Post Payment")
        {
        }
        key(Key15; "Application No.", "Sub Associate Code", "Post Payment", Approved)
        {
            SumIndexFields = "Amount to Pay";
        }
        key(Key16; "Document No.", "Sub Associate Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //IF TrHeader.GET("Document No.") THEN
        //  ERROR('First delete the Header Part');
    end;

    trigger OnModify()
    begin
        //TESTFIELD(Approved,FALSE);
    end;

    var
        Vend: Record Vendor;
        Vend1: Record Vendor;
        DimValue: Record "Dimension Value";
        LedgerSetup: Record "General Ledger Setup";
        TravelpaymentDetails: Record "Travel Payment Details";
        BAcc: Record "Bank Account";
        Travelsetup: Record "Travel Setup Header";
        USER: Record User;
        UnitSetup: Record "Unit Setup";
        //NODHeader: Record 13786;//Need to check the code in UAT

        //NODlines: Record 13785;//Need to check the code in UAT

        TDSSetup: Record "TDS Setup";// 13728;
        TAXRate: Record "Tax Rate";
        P: Page "Tax Rates";
        Vendor: Record Vendor;
        TravelHeader: Record "Travel Header";
        TravelPaymentEntry: Record "Travel Payment Entry";
        TotalValue: Decimal;
        THeader: Record "Travel Header";
        CheckRate: Decimal;
        TrHeader: Record "Travel Header";
        MemberOf: Record "Access Control";


    procedure TDSCalculation()
    var
        Vendor: Record Vendor;
        AllowedSection: Record "Allowed Sections";
        CodeunitEventMgt: Codeunit "BBG Codeunit Event Mgnt.";
        TDSPercent: Decimal;
    begin

        IF Vendor.Get("Sub Associate Code") Then begin
            AllowedSection.Reset();
            AllowedSection.SetRange("Vendor No", Vendor."No.");
            AllowedSection.SetRange("TDS Section", UnitSetup."TDS Nature of Deduction TA");
            IF AllowedSection.FindFirst() then begin
                TDSPercent := CodeunitEventMgt.GetTDSPer(Vendor."No.", AllowedSection."TDS Section", Vendor."Assessee Code");
                "TDS Amount" := ("Amount to Pay" * TDSPercent) / 100;
            end;
        end;

        /*
        NODHeader.RESET;
        NODHeader.SETRANGE(NODHeader."No.", "Sub Associate Code");
        IF NODHeader.FINDFIRST THEN BEGIN
            UnitSetup.GET;
            TDSSetup.RESET;
            TDSSetup.SETRANGE(TDSSetup."TDS Nature of Deduction", UnitSetup."TDS Nature of Deduction TA");
            TDSSetup.SETRANGE(TDSSetup."Assessee Code", NODHeader."Assesse Code");
            TDSSetup.SETRANGE("Effective Date", 0D, WORKDATE);
            IF TDSSetup.FINDLAST THEN BEGIN
                "TDS Amount" := ("Amount to Pay" * TDSSetup."TDS %") / 100;
            END;
        END;
        */
        //Need to check the code in UAT
        /*
        Vendor.RESET;
        Vendor.SETRANGE("No.", "Sub Associate Code");
        IF Vendor.FINDFIRST THEN BEGIN
            UnitSetup.GET;
            TAXRate.RESET;
            TAXRate.SETRANGE( , UnitSetup."TDS Nature of Deduction TA");
            TAXRate.SETRANGE(TDSSetup."Assessee Code", Vendor."Assessee Code");
            TAXRate.SETRANGE("Effective Date", 0D, WORKDATE);
            IF TAXRate.FINDLAST THEN BEGIN
                "TDS Amount" := ("Amount to Pay" * TAXRate."TDS %") / 100;
            END;
        END;
        */
    end;
}

