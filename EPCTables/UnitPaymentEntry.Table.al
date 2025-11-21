table 97794 "Unit Payment Entry"
{
    // ALLETDK081112..Added "Cheque Status" field in key "Document Type","Document No.","Milestone Code","Cheque Status"
    //                Added new field "Charge Code"
    // ALLETDK141112..Changed Table relation for "Unit No." field and renamed to Unit Code
    // BBG1.00 AD220213: REMOVED VALIDATION OF BAL. A/C NO. ON PAYMENT METHOD AS NOT DESIRED IN BBG ON UNIT SETUP/APPLICATION

    Caption = 'Unit Payment Line';
    DrillDownPageID = "Unit Payment Entry List";
    LookupPageID = "Unit Payment Entry List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Application,RD,FD,MIS,BOND';
            OptionMembers = Application,RD,FD,MIS,BOND;
        }
        field(2; "Document No."; Code[20])
        {
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(4; "Unit Code"; Code[20])
        {
            Caption = 'Unit Code';
            TableRelation = "Unit Master";
        }
        field(5; "Payment Method"; Code[10])
        {
            Caption = 'Payment Method';
            NotBlank = true;
            TableRelation = "Payment Method" WHERE("Bal. Account Type" = CONST("G/L Account"));

            trigger OnValidate()
            begin
                IF PaymentMethod.GET("Payment Method") THEN BEGIN
                    //PaymentMethod.TESTFIELD("Bal. Account No.");// BBG1.00 AD220213
                    Description := PaymentMethod.Description;
                    //"Cheque Status" := PaymentMethod."Default Payment Status"; //ALLETDK220213
                END;
            end;
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            begin
                UpdateDueAmount();
                CheckCashAmount();
            end;
        }
        field(8; "Cheque No./ Transaction No."; Code[20])
        {

            trigger OnValidate()
            begin
                //IF ("Cheque No./ Transaction No." <> '') AND NOT (STRLEN("Cheque No./ Transaction No.") IN [6,7]) THEN
                //  ERROR(Text0001);
            end;
        }
        field(9; "Cheque Date"; Date)
        {

            trigger OnValidate()
            var
                Application: Record Application;
                BondSetup: Record "Unit Setup";
            begin
                // ALLEPG 221012 Start
                BondSetup.GET;

                /*
                IF ("Cheque Date" < CALCDATE(BondSetup."Cheque Date Validity",WORKDATE)) THEN
                  ERROR(Text0002);
                IF ("Cheque Date" < WORKDATE) OR ("Cheque Date" > CALCDATE(BondSetup."Cheque Date Validity",WORKDATE)) THEN
                  ERROR(Text0002);
                // ALLEPG 221012 End
                */

            end;
        }
        field(10; "Cheque Bank and Branch"; Text[50])
        {

            trigger OnValidate()
            begin
                "Cheque Bank and Branch" := UPPERCASE("Cheque Bank and Branch");
            end;
        }
        field(12; "Cheque Status"; Option)
        {
            OptionCaption = ' ,Cleared,Bounced';
            OptionMembers = " ",Cleared,Bounced;
        }
        field(13; "Chq. Cl / Bounce Dt."; Date)
        {

            trigger OnValidate()
            begin

                IF "Document Type" = "Document Type"::Application THEN BEGIN
                    IF Application.GET("Document No.") THEN
                        IF Bond.GET(Application."Unit No.") THEN;
                    IF "Cheque Status" <> "Cheque Status"::" " THEN     //ALLEDK 260213
                        ERROR(Text0008);                                  //ALLEDK 260213
                END;
                //ALLEDK 260213
                IF "Document Type" = "Document Type"::Application THEN BEGIN
                    IF Bond.GET("Document No.") THEN
                        IF Bond.Type = Bond.Type::Normal THEN BEGIN
                            IF "Cheque Status" <> "Cheque Status"::" " THEN
                                ERROR(Text0008);
                        END;
                END;
                //ALLEDK 260213
            end;
        }
        field(14; "Application No."; Code[20])
        {
            Caption = 'Application No.';
        }
        field(15; "Payment Mode"; Option)
        {
            Caption = 'Payment Mode';
            OptionCaption = ' ,Cash,Bank,D.D.,MJVM,D.C./C.C./Net Banking,Refund Cash,Refund Cheque,AJVM,Debit Note,JV,Negative Adjmt.';
            OptionMembers = " ",Cash,Bank,"D.D.",MJVM,"D.C./C.C./Net Banking","Refund Cash","Refund Cheque",AJVM,"Debit Note",JV,"Negative Adjmt.";

            trigger OnValidate()
            begin
                BondSetup.GET;
                BondSetup.TESTFIELD("Cash A/c No.");
                BondSetup.TESTFIELD("Cheque in Hand");
                BondSetup.TESTFIELD("DD in Hand");
                BondSetup.TESTFIELD("Transfer A/c");
                BondSetup.TESTFIELD("D.C./C.C./Net Banking A/c No.");

                CASE "Payment Mode" OF
                    "Payment Mode"::Cash:
                        BEGIN
                            VALIDATE("Payment Method", BondSetup."Cash A/c No.");
                            "Cheque No./ Transaction No." := '';
                            "Cheque Date" := 0D;
                            "Cheque Bank and Branch" := '';
                            "Deposit/Paid Bank" := '';
                        END;
                    "Payment Mode"::Bank:
                        VALIDATE("Payment Method", BondSetup."Cheque in Hand");
                    "Payment Mode"::MJVM:
                        VALIDATE("Payment Method", BondSetup."Transfer A/c");
                END;
            end;
        }
        field(17; Posted; Boolean)
        {
            Caption = 'Posted';
        }
        field(18; "Installment No."; Integer)
        {
        }
        field(19; "Deposit/Paid Bank"; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Document Type" IN ["Document Type"::Application, "Document Type"::RD] THEN BEGIN
                    GetUserSetup;
                    UserSetup.TESTFIELD("Responsibility Center");
                    //  UserSetup.TESTFIELD("Shortcut Dimension 2 Code");

                    GetGLSetup;
                    GLSetup.TESTFIELD("Global Dimension 1 Code");
                    /*
                      DefaultDim.RESET;
                      DefaultDim.SETRANGE("Table ID",DATABASE::"Bank Account");
                      DefaultDim.SETRANGE("No.","Deposit/Paid Bank");
                      DefaultDim.SETRANGE("Dimension Code",GLSetup."Global Dimension 1 Code");
                      DefaultDim.SETRANGE("Dimension Value Code",UserSetup."Responsibility Center");
                      IF DefaultDim.ISEMPTY THEN
                        FIELDERROR("Deposit/Paid Bank");
                        */
                END;

            end;
        }
        field(20; "Not Refundable"; Boolean)
        {
            Editable = false;
        }
        field(22; "Posted Document No."; Code[20])
        {
        }
        field(23; Type; Option)
        {
            Editable = false;
            OptionCaption = ' ,Received,Interest,Principal,Interest + Principal';
            OptionMembers = " ",Received,Interest,Principal,"Interest + Principal";
        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(26; "Document Date"; Date)
        {
        }
        field(27; "Posting date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(28; Reversed; Boolean)
        {
            CalcFormula = Max("G/L Entry"."BBG Do Not Show" WHERE("Document No." = FIELD("Posted Document No.")));
            FieldClass = FlowField;
        }
        field(29; Sequence; Code[10])
        {
            Caption = 'Sequence';
        }
        field(30; "Commision Applicable"; Boolean)
        {
        }
        field(31; "Direct Associate"; Boolean)
        {
        }
        field(32; "Explode BOM"; Boolean)
        {
        }
        field(33; "Reversal Document No."; Code[20])
        {
        }
        field(34; "Order Ref No."; Code[20])
        {
            TableRelation = IF ("Payment Mode" = CONST(MJVM)) "Confirmed Order";
        }
        field(35; "Created from Application"; Boolean)
        {
        }
        field(36; "Branch Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(37; "Charge Code"; Code[20])
        {
        }
        field(38; "Priority Payment"; Boolean)
        {
        }
        field(39; "Actual Milestone"; Code[20])
        {
            Description = 'TDK';
        }
        field(40; "User ID"; Code[50])
        {
            Description = 'ALLEDK 2712';
            Editable = false;
            TableRelation = User;
        }
        field(41; "App. Pay. Entry Line No."; Integer)
        {
            Description = 'ALLETDK';
        }
        field(42; "Transfered MTM"; Boolean)
        {
            Description = 'ALLEDK 130113';
        }
        field(43; "Transfered MTM Received"; Decimal)
        {
            Description = 'ALLEDK 130113';
        }
        field(44; "Transfered MTM Post"; Boolean)
        {
            Description = 'ALLEDK 130113';
        }
        field(50201; "Discount Payment Type"; Option)
        {
            Description = 'BBG1.6 311213';
            OptionCaption = ' ,Forfeit,Excess Payment';
            OptionMembers = " ",Forfeit,"Excess Payment";
        }
        field(50202; "Balance Amount"; Decimal)
        {
            Description = 'ALLE 241014';
            Editable = false;
        }
        field(50203; "Unit & Buffer Base Amount"; Decimal)
        {
            CalcFormula = Sum("Unit & Comm. Creation Buffer"."Base Amount" WHERE("Unit No." = FIELD("Document No."),
                                                                                  "Charge Code" = FIELD("Charge Code"),
                                                                                  "Commission Created" = FILTER(false),
                                                                                  "Direct Associate" = FILTER(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50204; "Commission Entry Base Amount"; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Base Amount" WHERE("Application No." = FIELD("Document No."),
                                                                      "Charge Code" = FIELD("Charge Code"),
                                                                      "Business Type" = FILTER(SELF),
                                                                      "Direct to Associate" = FILTER(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50205; "New Balance Amount"; Decimal)
        {
            Description = 'ALLE 241014';
            Editable = true;
        }
        field(50206; "Entry Find"; Boolean)
        {
        }
        field(50222; "Entry From MSC"; Boolean)
        {
            Editable = false;
        }
        field(50223; "For checking"; Boolean)
        {
            CalcFormula = Lookup("Confirmed Order"."For Checking Collection" WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(50300; "Application Date of Joining"; Date)
        {
            CalcFormula = Lookup("Confirmed Order"."Posting Date" WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2; Posted, "Payment Mode", "Cheque Status", "Chq. Cl / Bounce Dt.", "Document Type", "Document No.", "Document Date", "Posting date")
        {
            SumIndexFields = Amount;
        }
        key(Key3; "Document Type", "Document No.", "Payment Mode", "Cheque No./ Transaction No.", "Cheque Date")
        {
        }
        key(Key4; "Unit Code", "Payment Mode", "Cheque No./ Transaction No.")
        {
        }
        key(Key5; "Document Type", "Document No.", Sequence, "Cheque Status", "Priority Payment")
        {
            SumIndexFields = Amount;
        }
        key(Key6; "Document No.", "Charge Code")
        {
        }
        key(Key7; "Document No.", "App. Pay. Entry Line No.", "Charge Code")
        {
        }
        key(Key8; "Shortcut Dimension 1 Code", "Document Type", "Application No.")
        {
        }
        key(Key9; "Document No.", "Posting date", "Charge Code")
        {
            SumIndexFields = Amount;
        }
        key(Key10; "Document No.", "Direct Associate")
        {
            SumIndexFields = Amount;
        }
        key(Key11; "Document No.", "Cheque Status", "Posting date")
        {
            SumIndexFields = Amount;
        }
        key(Key12; "Document No.", "Posting date", "Cheque Status", "Charge Code")
        {
            SumIndexFields = Amount;
        }
        key(Key13; "Document No.", "Commision Applicable")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //CheckRegistration;
        //TESTFIELD(Posted,FALSE);
        UpdateAmount();
    end;

    trigger OnInsert()
    begin
        CheckExistingLines;
        //CheckRegistration;
        CheckAppPaymentPlan;
        BPayEntry.RESET;
        BPayEntry.SETRANGE("Document Type", "Document Type");
        BPayEntry.SETFILTER(BPayEntry."Document No.", "Document No.");
        IF BPayEntry.FIND('+') THEN BEGIN
            "Line No." := BPayEntry."Line No." + 10000;
        END ELSE
            "Line No." := 10000;

        TESTFIELD("Payment Method");
        IF ("Payment Mode" = "Payment Mode"::Bank) OR ("Payment Mode" = "Payment Mode"::"Refund Cheque") THEN BEGIN

            TESTFIELD("Cheque No./ Transaction No.");
            TESTFIELD("Cheque Date");
            TESTFIELD("Cheque Bank and Branch");
            TESTFIELD("Deposit/Paid Bank");
            TESTFIELD("Cheque Bank and Branch");
        END;
        "Posting date" := WORKDATE;
        "Document Date" := GetDescription.GetDocomentDate;
        UserSetup.GET(USERID);
        "Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
        "Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        "Branch Code" := UserSetup."User Branch";
    end;

    trigger OnModify()
    begin
        //TESTFIELD(Posted,FALSE);

        //CheckRegistration;dk
        //TESTFIELD(Posted,FALSE);
        TESTFIELD("Payment Method");
        IF ("Payment Mode" = "Payment Mode"::Bank) OR ("Payment Mode" = "Payment Mode"::"Refund Cheque") THEN BEGIN
            TESTFIELD("Cheque No./ Transaction No.");
            TESTFIELD("Cheque Date");
            TESTFIELD("Cheque Bank and Branch");
            TESTFIELD("Deposit/Paid Bank");
            TESTFIELD("Cheque Bank and Branch");
        END;
        UpdateAmount();
    end;

    var
        PaymentMethod: Record "Payment Method";
        BondSetup: Record "Unit Setup";
        Text0001: Label 'Please enter a valid cheque no.';
        Text0002: Label 'Please enter a valid cheque date.';
        Text0003: Label 'You cannot change Line No. %1.';
        Text0004: Label 'Cheque Already Cleared and Posted';
        Text0005: Label 'Payment Mode is %1';
        Text0006: Label 'Please enter Cheque Clearance Date';
        Text0007: Label 'Please enter a valid cheque Clearance date.';
        Text0008: Label 'Cheque Clearance date cannot be changed';
        Application: Record Application;
        Bond: Record "Confirmed Order";
        TotalApplAmt: Decimal;
        TotalRcvdAmt: Decimal;
        Text0009: Label 'Payment mode %1 already exists.';
        Text0010: Label 'Maximum permitted amount in %1 is %2.';
        Text0011: Label 'Amount should not be greater than Due Amount = %1.';
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        DefaultDim: Record "Default Dimension";
        Text0012: Label 'Error';
        GLSetupRead: Boolean;
        GetDescription: Codeunit GetDescription;
        BPayEntry: Record "Unit Payment Entry";
        Text0013: Label 'The Bond is already Exploded.\Not allowed to enter New Line';
        Text0014: Label 'Bond is already Registered.\Not allowed to modify or delete';


    procedure CheckCashAmount()
    var
        BondSetup: Record "Unit Setup";
        PaymentLines: Record "Unit Payment Entry";
        CashAmount: Decimal;
    begin
        IF "Document Type" = "Document Type"::Application THEN
            IF "Payment Mode" = "Payment Mode"::Cash THEN BEGIN
                PaymentLines := Rec;
                SETRANGE("Document Type", "Document Type");
                SETRANGE("Document No.", "Document No.");
                SETRANGE("Payment Mode", "Payment Mode"::Cash);
                SETRANGE("Not Refundable", FALSE);
                SETFILTER("Line No.", '<>%1', "Line No.");
                IF FINDSET THEN
                    REPEAT
                        CashAmount += Amount;
                    UNTIL NEXT = 0;
                SETRANGE("Document Type");
                SETRANGE("Document No.");
                SETRANGE("Payment Mode");
                SETRANGE("Not Refundable");
                SETRANGE("Line No.");
                Rec := PaymentLines;
                BondSetup.GET;
                IF CashAmount + Amount > BondSetup."Cash Max. Amount" THEN
                    ERROR(STRSUBSTNO(Text0010, FORMAT("Payment Mode"), BondSetup."Cash Max. Amount"));
            END;
    end;


    procedure UpdateDueAmount()
    begin
        UpdateAmount();
        IF TotalApplAmt - TotalRcvdAmt < 0 THEN
            ERROR(STRSUBSTNO(Text0011, TotalApplAmt - TotalRcvdAmt + Amount));
    end;


    procedure UpdateAmount()
    var
        PmtLines: Record "Unit Payment Entry";
    begin
        IF "Document Type" <> "Document Type"::Application THEN
            EXIT;

        IF NOT Application.GET("Document No.") THEN
            EXIT;

        TotalApplAmt := 0;
        TotalRcvdAmt := 0;
        TotalApplAmt := Application."Investment Amount" + Application."Service Charge Amount";
        TotalRcvdAmt := Rec.Amount;

        PmtLines := Rec;
        SETRANGE("Document Type", "Document Type");
        SETRANGE("Document No.", "Document No.");
        //SETRANGE("Payment Mode","Payment Mode"::Cash);
        //SETRANGE("Not Refundable",FALSE);
        SETFILTER("Line No.", '<>%1', "Line No.");
        IF FINDSET THEN
            REPEAT
                TotalRcvdAmt += Amount;
            UNTIL NEXT = 0;

        SETRANGE("Document Type");
        SETRANGE("Document No.");
        //SETRANGE("Payment Mode");
        //SETRANGE("Not Refundable");
        SETRANGE("Line No.");
        Rec := PmtLines;
    end;


    procedure GetAmounts(var TotalAmount: Decimal; var ReceivedAmount: Decimal)
    begin
        UpdateAmount();
        TotalAmount := TotalApplAmt;
        ReceivedAmount := TotalRcvdAmt;
    end;


    procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    end;


    procedure GetUserSetup()
    begin
        IF UserSetup."User ID" <> USERID THEN
            UserSetup.GET(USERID);
    end;


    procedure CheckExistingLines()
    begin
        BPayEntry.RESET;
        BPayEntry.SETRANGE("Document Type", "Document Type");
        BPayEntry.SETFILTER("Document No.", "Document No.");
        BPayEntry.SETRANGE("Explode BOM", TRUE);
        BPayEntry.SETRANGE(Posted, FALSE);
        IF BPayEntry.FINDFIRST THEN
            ERROR(Text0013);
    end;


    procedure CheckRegistration()
    var
        Bond: Record "Confirmed Order";
    begin
        Bond.RESET;
        IF Bond.GET("Document No.") THEN BEGIN
            IF Bond.Status = Bond.Status::Registered THEN
                ERROR(Text0014);
        END;
    end;


    procedure CheckAppPaymentPlan()
    var
        Application: Record Application;
    begin
        IF Application.GET("Document No.") THEN
            Application.TESTFIELD("Payment Plan");
    end;
}

