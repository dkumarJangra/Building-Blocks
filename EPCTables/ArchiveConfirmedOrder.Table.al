table 97824 "Archive Confirmed Order"
{
    Caption = 'Archive Confirmed Order';
    DataPerCompany = false;
    DrillDownPageID = "Archive Confirmed Order List";
    LookupPageID = "Archive Confirmed Order List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
            NotBlank = true;
        }
        field(2; "Scheme Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Document Type Initiator"; //WHERE("Document Type" = FIELD("Scheme Code"));
        }
        field(3; "Project Type"; Code[20])
        {
            Editable = false;
            TableRelation = "Unit Type".Code;
        }
        field(4; Duration; Integer)
        {
            Editable = false;
        }
        field(5; "Customer No."; Code[20])
        {
            Editable = false;
            TableRelation = Customer;
        }
        field(6; "Introducer Code"; Code[20])
        {
            Caption = 'Introducer Code';
            Editable = false;
            TableRelation = Vendor;
        }
        field(7; "Maturity Date"; Date)
        {
            Editable = false;
        }
        field(8; "Maturity Amount"; Decimal)
        {
            Editable = false;
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(11; "Application No."; Code[20])
        {
            Editable = false;
            NotBlank = true;
        }
        field(12; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Documented,Cash Dispute,Documentation Dispute,Verified,Active,,,,,,,Registered,Cancelled';
            OptionMembers = Open,Documented,"Cash Dispute","Documentation Dispute",Verified,Active,"Death Claim","Maturity Claim","Maturity Dispute",Matured,Dispute,"Blocked (Loan)",Registered,Cancelled;
        }
        field(13; "User Id"; Code[20])
        {
            Editable = false;
            TableRelation = User;
        }
        field(14; Amount; Decimal)
        {
            Description = 'Investment Amount';
        }
        field(15; "Posting Date"; Date)
        {
            Editable = false;
        }
        field(16; "Document Date"; Date)
        {
            Editable = false;
        }
        field(17; "Investment Frequency"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Monthly,Quarterly,Half Yearly,Annually';
            OptionMembers = " ",Monthly,Quarterly,"Half Yearly",Annually;
        }
        field(18; "Return Frequency"; Option)
        {
            Description = 'prev Dateformula';
            Editable = false;
            OptionCaption = ' ,Monthly,Quarterly,Half Yearly,Annually';
            OptionMembers = " ",Monthly,Quarterly,"Half Yearly",Annually;
        }
        field(19; "Service Charge Amount"; Decimal)
        {
            Editable = false;
        }
        field(21; "Bond Category"; Option)
        {
            Editable = false;
            OptionMembers = "A Type","B Type";
        }
        field(22; "Posted Doc No."; Code[20])
        {
            Editable = false;
        }
        field(23; "Discount Amount"; Decimal)
        {
            CalcFormula = Sum("Debit App. Payment Entry"."Net Payable Amt" WHERE("Document No." = FIELD("No."),
                                                                                  Posted = FILTER(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Return Payment Mode"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Cash,Cheque,D.D.,Banker''s Cheque,P.O.,Cheque by Post,NEFT,Stopped,NEFT Updated';
            OptionMembers = " ",Cash,Cheque,"D.D.","Banker's Cheque","P.O.","Cheque by Post",NEFT,Stopped,"NEFT Updated";
        }
        field(25; "Received From"; Option)
        {
            Editable = false;
            OptionMembers = " ","Marketing Member","Bond Holder";
        }
        field(26; "Received From Code"; Code[20])
        {
            Editable = false;
            TableRelation = IF ("Received From" = CONST("Marketing Member")) Vendor."No."
            ELSE IF ("Received From" = CONST("Bond Holder")) Customer."No.";
        }
        field(27; "Version No."; Integer)
        {
            Editable = true;
        }
        field(28; "Maturity Bonus Amount"; Decimal)
        {
            Editable = false;
        }
        field(29; "Creation Time"; Time)
        {
            Editable = false;
        }
        field(30; "Customer No. 2"; Code[20])
        {
            TableRelation = Customer;
        }
        field(32; "Bond Posting Group"; Code[20])
        {
            Editable = false;
            TableRelation = "ID 2 Group";
        }
        field(34; "Investment Type"; Option)
        {
            Caption = 'Investment Type';
            Editable = false;
            OptionCaption = ' ,RD,FD,MIS';
            OptionMembers = " ",RD,FD,MIS;
        }
        field(35; "Dispute Remark"; Text[50])
        {
            Editable = false;
        }
        field(36; "Return Bank Account Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Customer Bank Account" WHERE("Customer No." = FIELD("Customer No."),
                                                           Code = FIELD("Return Bank Account Code"));
        }
        field(37; "Return Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Return Amount';
            Editable = false;
        }
        field(38; "With Cheque"; Boolean)
        {
            Editable = false;
        }
        field(39; "Last Certificate Printed On"; Date)
        {
            CalcFormula = Max("Unit Print Log".Date WHERE("Unit No." = FIELD("No."),
                                                           "Report Type" = CONST(Certificate)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Amount Received"; Decimal)
        {
            Caption = 'Amount Received';
            Editable = false;
            FieldClass = Normal;
        }
        field(50000; "Reg. Document Issue"; Boolean)
        {
        }
        field(50001; "Issue Date"; Date)
        {
        }
        field(50002; "Reg. Office"; Text[60])
        {
        }
        field(50003; "Registration In Favour Of"; Text[60])
        {
        }
        field(50004; "Registered/Office Name"; Text[70])
        {
        }
        field(50005; "Reg. Address"; Text[80])
        {
        }
        field(50006; "Father/Husband Name"; Text[60])
        {
        }
        field(50007; "Branch Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(50008; "Registered City"; Code[10])
        {
            TableRelation = State;
        }
        field(50009; "Zip Code"; Code[10])
        {
            TableRelation = "Post Code";
        }
        field(50010; "Gold Coin Generated"; Boolean)
        {
            Description = 'BBG1.01 161012';
            Editable = false;
        }
        field(50011; "Total Received Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        field(50100; "Incentive Calculate"; Boolean)
        {
        }
        field(50101; "Discount Payment Type"; Option)
        {
            Description = 'BBG1.6 311213';
            OptionCaption = ' ,Forfeit,Excess Payment';
            OptionMembers = " ",Forfeit,"Excess Payment";
        }
        field(50102; "ForeFit Amount"; Decimal)
        {
            Description = 'BBG1.6 311213';
        }
        field(50103; "Excess amount"; Decimal)
        {
            Description = 'BBG1.6 311213';
        }
        field(50201; "Unit Payment Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "App. Charge Code".Code WHERE("Sub Payment Plan" = FILTER(true),
                                                           "Show Payment Plan on Receipt" = FILTER(true));
        }
        field(50202; "New Unit Payment Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "App. Charge Code".Code WHERE("Sub Payment Plan" = FILTER(true));
        }
        field(50203; "Unit Plan Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50335; "Last Unit Vacated By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50336; "Last Unit Vacate Date_Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50337; "Restrict Issue for Gold/Silver"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Silver,Gold,Both';
            OptionMembers = " ",Silver,Gold,Both;
        }
        field(50338; "Restriction Remark"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(50341; "Registration Initiated Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60012; "Min. Allotment Amount"; Decimal)
        {
            Editable = false;
        }
        field(90000; "Unit Code"; Code[20])
        {
        }
        field(90001; "Registration No."; Code[20])
        {
            Description = 'ALLEPG 040712';
        }
        field(90002; "Registration Date"; Date)
        {
            Description = 'ALLEPG 040712';
        }
        field(90003; "Commission Reversed"; Boolean)
        {
        }
        field(90004; "Penalty Amount"; Decimal)
        {
            Editable = true;
        }
        field(90005; "Travel Calculated"; Boolean)
        {
            Editable = false;
        }
        field(90006; "Amount Refunded"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(90007; "Penalty Document No."; Code[20])
        {
            Editable = false;
        }
        field(90008; "Saleable Area"; Decimal)
        {
        }
        field(90009; "Travel Entry No."; Integer)
        {
        }
        field(90010; "Dummay Unit Code"; Code[20])
        {
        }
        field(90011; Type; Option)
        {
            OptionCaption = ' ,Normal,Priority';
            OptionMembers = " ",Normal,Priority;
        }
        field(90012; "Allocated Unit No."; Code[20])
        {
            TableRelation = "Unit Master";
        }
        field(90013; "Payment Plan"; Code[20])
        {
            Description = 'ALLEDK 010113 length change';
        }
        field(90014; "New Project"; Code[20])
        {
            TableRelation = "Responsibility Center 1";
        }
        field(90015; "New Member"; Code[20])
        {
            TableRelation = Customer;
        }
        field(90016; "Commission Amt."; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Commission Amount" WHERE("Application No." = FIELD("No."),
                                                                            "Associate Code" = FIELD("Introducer Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90017; "Commission Paid"; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Commission Amount" WHERE("Application No." = FIELD("No."),
                                                                            "Voucher No." = FILTER(<> ''),
                                                                            "Associate Code" = FIELD("Introducer Code"),
                                                                            "Commission Amount" = FILTER(> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90018; "Creation Date"; Date)
        {
            Description = 'ALLETDK';
        }
        field(90019; "Commission Not Generate"; Boolean)
        {
            Description = 'ALLEDK 060113';
        }
        field(90020; "Comm. Base Amt. to be Adj."; Decimal)
        {
            Description = 'ALLEDK 090113';
        }
        field(90022; "Commission Base Amount"; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Base Amount" WHERE("Application No." = FIELD("No."),
                                                                      "Introducer Code" = FIELD("Introducer Code"),
                                                                      "Business Type" = CONST(SELF),
                                                                      "Direct to Associate" = CONST(false)));
            Description = 'ALLEDK 090113';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90023; "Direct Associate Amount"; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Base Amount" WHERE("Application No." = FIELD("No."),
                                                                      "Introducer Code" = FIELD("Introducer Code"),
                                                                      "Business Type" = CONST(SELF),
                                                                      "Direct to Associate" = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90024; "Total Comm & Direct Assc. Amt."; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Base Amount" WHERE("Application No." = FIELD("No."),
                                                                      "Introducer Code" = FIELD("Introducer Code"),
                                                                      "Business Type" = CONST(SELF)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90025; "Amount Adj. Associate"; Decimal)
        {
        }
        field(90026; "BBG Discount"; Decimal)
        {
        }
        field(90027; "Net Due Amount"; Decimal)
        {
            Editable = false;
        }
        field(90028; "Commission Amount"; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Commission Amount" WHERE("Application No." = FIELD("No."),
                                                                            "Associate Code" = FIELD("Introducer Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90029; "Travel Generate"; Boolean)
        {
            Editable = false;
        }
        field(90030; "AJVM Associate Code"; Code[20])
        {
            Description = 'ALLEDK 270113';
            TableRelation = Vendor;
        }
        field(90031; "Net Discount Amount"; Decimal)
        {
            CalcFormula = Sum("Application Payment Entry".Amount WHERE("Document No." = FIELD("Application No."),
                                                                        Posted = CONST(true),
                                                                        "Document Type" = CONST(BOND),
                                                                        "Cheque Status" = FILTER(<> Bounced),
                                                                        "Payment Mode" = CONST("Debit Note")));
            FieldClass = FlowField;
        }
        field(90032; "AJVM Associate Balance"; Decimal)
        {
            Editable = false;
        }
        field(90033; "Pass Book No."; Code[20])
        {
        }
        field(90034; "Unit Vacate Date"; Date)
        {
            Description = 'ALLETDK030313';
        }
        field(90035; "Expexted Discount by BBG"; Decimal)
        {
        }
        field(90036; "Bill-to Customer Name"; Text[60])
        {
            Description = 'BBG1.00 300313';
            Editable = false;
        }
        field(90037; "Archive Date"; Date)
        {
            Description = 'ALLECK310313';
        }
        field(90038; "Archive Time"; Time)
        {
            Description = 'ALLECK310313';
        }
        field(90039; "Member Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            FieldClass = FlowField;
        }
        field(90120; "Loan File"; Boolean)   //251124 Added new field
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90123; "R194 Gift Issued"; Boolean)   //251124 Added new field
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }


        field(90125; "App. applicable for issue R194"; Boolean)   //251124 Added new field
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90126; "Registration No. 2"; Code[50])   //251124 Added new field
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(90127; "Region Code"; Code[10])   // Code added 01072025
        {
            Editable = false;

        }

        field(90128; "Travel applicable"; Boolean)  //New field added 01072025
        {
            Editable = False;


        }
        field(90129; "Registration Bouns (BSP2)"; Boolean)  //New field added 01072025
        {
            Editable = False;

        }

        field(90150; "New Region code"; Code[20])  //New field added 01072025
        {
            TableRelation = "Rank Code Master".Code;
            Editable = false;

        }

    }

    keys
    {
        key(Key1; "No.", "Version No.")
        {
            Clustered = true;
        }
        key(Key2; "Investment Type", "No.", "Introducer Code", Status, "Return Payment Mode")
        {
        }
        key(Key3; Status, "No.")
        {
        }
        key(Key4; "Project Type", "Posting Date", Duration, "Bond Category", "No.", "Application No.")
        {
        }
        key(Key5; "Introducer Code", "Posting Date")
        {
        }
        key(Key6; "Shortcut Dimension 1 Code", "Project Type", "Return Frequency", Duration, "No.", "Return Payment Mode")
        {
        }
        key(Key7; "Project Type", "Scheme Code", "Shortcut Dimension 1 Code", "Maturity Date", "No.", Status)
        {
        }
        key(Key8; "Customer No.", "Return Bank Account Code")
        {
        }
        key(Key9; "Customer No.", "Application No.")
        {
        }
        key(Key10; "Unit Code")
        {
        }
        key(Key11; "Customer No.", "Introducer Code")
        {
        }
        key(Key12; Status, "Shortcut Dimension 2 Code", "Application No.")
        {
        }
        key(Key13; "Introducer Code", "Customer No.")
        {
        }
        key(Key14; "Shortcut Dimension 1 Code", "Application No.")
        {
        }
    }

    fieldgroups
    {
    }
}

