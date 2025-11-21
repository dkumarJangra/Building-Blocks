table 50059 "Land Vendor Receipt Payment"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Description 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Amount; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Created By" := USERID;
                "Creation Date" := TODAY;
                "Posting Date" := TODAY;
                IF "Payment Mode" <> "Payment Mode"::Payment THEN
                    Amount := -1 * Amount;
            end;
        }
        field(12; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                      Blocked = CONST(false))
            ELSE IF ("Account Type" = CONST(Customer)) Customer
            ELSE IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF ("Account Type" = CONST("IC Partner")) "IC Partner";
        }
        field(13; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                           Blocked = CONST(false))
            ELSE IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
                Location: Record Location;
                GLAcc: Record "G/L Account";
                BankAccount: Record "Bank Account";
            begin
            end;
        }
        field(16; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate()
            var
            //GSTComponent: Record 16405;
            begin
            end;
        }
        field(24; "Account Type"; Option)
        {
            Caption = 'Account Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate()
            var
            //GSTComponent: Record 16405;
            begin
                IF ("Account Type" = "Account Type"::Vendor) OR ("Account Type" = "Account Type"::Customer) THEN BEGIN
                END ELSE
                    ERROR('Account Type should be Vendor or Customer');
            end;
        }
        field(26; "Cheque No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Payment Method"; Code[10])
        {
            Caption = 'Payment Method';
            DataClassification = ToBeClassified;
            NotBlank = true;

            trigger OnLookup()
            begin
                //ALLEDK 190113
                IF ("Payment Mode" = "Payment Mode"::"Refund Cash") OR ("Payment Mode" = "Payment Mode"::"Refund Bank") OR
                ("Payment Mode" = "Payment Mode"::Payment) THEN BEGIN
                    RecPaymentMethod.RESET;
                    RecPaymentMethod.SETRANGE("Payment Method Type", RecPaymentMethod."Payment Method Type"::Cash);
                    IF RecPaymentMethod.FINDFIRST THEN BEGIN
                        IF PAGE.RUNMODAL(Page::"Payment Methods New", RecPaymentMethod) = ACTION::LookupOK THEN
                            VALIDATE("Payment Method", RecPaymentMethod.Code);
                    END;
                END ELSE
                    IF ("Payment Mode" = "Payment Mode"::"Refund Bank") OR ("Payment Mode" = "Payment Mode"::Payment) OR ("Payment Mode" = "Payment Mode"::"Refund Cash") THEN BEGIN
                        RecPaymentMethod.RESET;
                        RecPaymentMethod.SETRANGE("Payment Method Type", RecPaymentMethod."Payment Method Type"::Bank);
                        IF RecPaymentMethod.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Payment Methods New", RecPaymentMethod) = ACTION::LookupOK THEN
                                VALIDATE("Payment Method", RecPaymentMethod.Code);
                        END;
                    END;
                //ALLEDK 190113
            end;

            trigger OnValidate()
            begin
                IF PaymentMethod.GET("Payment Method") THEN BEGIN
                    //IF ("Payment Mode" <> "Payment Mode"::"6") AND ("Payment Mode" <> "Payment Mode"::"7") THEN //ALLETDK
                    Description := PaymentMethod.Description;
                END;
            end;
        }
        field(29; "Payment Mode"; Option)
        {
            Caption = 'Payment Mode';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Refund Cash,Refund Bank,Payment';
            OptionMembers = " ","Refund Cash","Refund Bank",Payment;

            trigger OnValidate()
            begin

                BondSetup.GET;
                BondSetup.TESTFIELD("Cash A/c No.");
                BondSetup.TESTFIELD("Cheque in Hand");
                BondSetup.TESTFIELD("DD in Hand");
                BondSetup.TESTFIELD("D.C./C.C./Net Banking A/c No.");
                IF ("Payment Mode" <> "Payment Mode"::"Refund Bank") THEN
                    "Cheque Status" := "Cheque Status"::Cleared
                ELSE
                    "Cheque Status" := "Cheque Status"::" ";

                UserSetup.GET(USERID);
                UserSetup.TESTFIELD("User Branch");
                "User Branch Code" := UserSetup."User Branch";
                "Shortcut Dimension 1 Code" := "User Branch Code";


                IF Loc.GET("User Branch Code") THEN
                    "User Branch Name" := Loc.Name
                ELSE
                    CLEAR("User Branch Name");

                IF "Payment Mode" = "Payment Mode"::"Refund Cash" THEN BEGIN
                    RecPaymentMethod.RESET;
                    RecPaymentMethod.SETRANGE("Payment Method Type", RecPaymentMethod."Payment Method Type"::Cash);
                    IF NOT RecPaymentMethod.FINDFIRST THEN
                        ERROR('Create Payment Method for CASH')
                    ELSE
                        VALIDATE("Payment Method", RecPaymentMethod.Code);
                END;
            end;
        }
        field(30; "User Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "User Branch Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Cheque Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Cleared,Bounced,Cancelled';
            OptionMembers = " ",Cleared,Bounced,Cancelled;
        }
        field(33; "Deposit/Paid Bank"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No.";

            trigger OnLookup()
            var
                RecConfOrder: Record "New Confirmed Order";
                RecApplication: Record "New Application Booking";
                CompName: Text[30];
            begin
            end;

            trigger OnValidate()
            var
                NewConfOrder: Record "New Confirmed Order";
            begin


                IF BankAccount.GET("Deposit/Paid Bank") THEN
                    "Deposit / Paid Bank Name" := BankAccount.Name
                ELSE
                    "Deposit / Paid Bank Name" := '';
                BankAccount.TESTFIELD("Bank Acc. Posting Group");
            end;
        }
        field(34; "Deposit / Paid Bank Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        }
        field(36; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(38; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39; Narration; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Refund Posted Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(41; Remarks; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(44; "TDS Nature of Deduction"; Code[10])
        {
            Caption = 'TDS Nature of Deduction';
            DataClassification = ToBeClassified;
            TableRelation = "TDS Section";// "TDS Nature of Deduction";

            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
            end;
        }
        field(45; "Assessee Code"; Code[10])
        {
            Caption = 'Assessee Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Assessee Code";
        }
        field(46; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Lead,Opportunity,Agreement';
            OptionMembers = " ",Lead,Opportunity,Agreement;
        }
        field(47; "Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Payment Transaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Project Cost Paid,Project Related Cost Paid';
            OptionMembers = " ","Project Cost Paid","Project Related Cost Paid";
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Posted, FALSE);
    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalTemplate: Record "Gen. Journal Template";
        UnitSetup: Record "Unit Setup";
        GenJournalLine_1: Record "Gen. Journal Line";
        LineNo: Integer;
        DocNo: Code[20];
        NoSeriesManagement: Codeunit NoSeriesManagement;
        UserSetup: Record "User Setup";
        EntryExists: Boolean;
        JobMaster: Record "Job Master";
        PaymentMethod: Record "Payment Method";
        RecPaymentMethod: Record "Payment Method";
        BondSetup: Record "Unit Setup";
        Loc: Record Location;
        BankAccount: Record "Bank Account";
        //VoucherAccount: Record 16547;
        BankACC: Record "Bank Account";
    //NODHeader: Record 13786;
}

