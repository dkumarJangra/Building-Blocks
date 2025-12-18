table 97793 "Confirmed Order"
{
    // Below key has been used in the PAGE 50080
    // Investment Type,Bond No.,Introducer Code,Status,Return Payment Mode,Blocked
    // ALLECK 270612: Removed "sqft" from fields names "Super Area Sqft","Saleable Area Sqft","Carpet Area Sqft",
    //                "Sales Rate sqft","Lease Rate Sqft".
    // ALLETDK021112: Changed FlowField of "Total Received Amount" field.
    //  ALLETDK231112: Changed "Penalty Amount" Editable property YES
    // //BBG2.01 221214 Added code for sink confirmed order to MSCompany
    // ALLE 031015 This field 'Gold Coin Transfer in Trading' used for how many gold coin issued in LLP company
    // ALLESSS 14/03/24 : Fields added "Purchase Invoice Unit Cost" and "Sales Invoice Unit Price"

    Caption = 'Confirmed Order';
    DrillDownPageID = "Unit List";
    LookupPageID = "Unit List";

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
        }
        field(3; "Project Type"; Code[20])
        {
            Editable = true;
            TableRelation = "Unit Type".Code;
        }
        field(4; Duration; Integer)
        {
            Editable = false;
        }
        field(5; "Customer No."; Code[20])
        {
            Editable = true;
            TableRelation = Customer;
        }
        field(6; "Introducer Code"; Code[20])
        {
            Caption = 'IBA Code';
            Editable = false;
            TableRelation = Vendor."No.";
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

            trigger OnValidate()
            begin
                IF "Shortcut Dimension 1 Code" <> '' THEN BEGIN
                    "Unit Code" := '';
                END;
            end;
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
            OptionCaption = 'Open,,,,,,,,,,,,Registered,Cancelled,Vacate,Forfeit';
            OptionMembers = Open,Documented,"Cash Dispute","Documentation Dispute",Verified,Active,"Death Claim","Maturity Claim","Maturity Dispute",Matured,Dispute,"Blocked (Loan)",Registered,Cancelled,Vacate,Forfeit;
        }
        field(13; "User Id"; Code[50])
        {
            Editable = false;
            TableRelation = User;
        }
        field(14; Amount; Decimal)
        {
            Description = 'Investment Amount';

            trigger OnValidate()
            begin
                CALCFIELDS("Total Received Amount");
                "Net Due Amount" := Amount + "Service Charge Amount" - "Discount Amount" - "Total Received Amount" - "BBG Discount" -
                "Amount Adj. Associate";
            end;
        }
        field(15; "Posting Date"; Date)
        {
            Editable = true;
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
            Editable = true;
            OptionMembers = " ","Marketing Member","Bond Holder";
        }
        field(26; "Received From Code"; Code[20])
        {
            Editable = true;
            TableRelation = Vendor."No.";
        }
        field(27; "Version No."; Integer)
        {
            CalcFormula = Max("Archive Confirmed Order"."Version No." WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
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
            Editable = true;
            TableRelation = "Customer Posting Group";
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
            CalcFormula = Sum("Unit Payment Entry".Amount WHERE("Document Type" = FILTER(BOND),
                                                                 "Document No." = FIELD("No."),
                                                                 Posted = CONST(true)));
            Caption = 'Amount Received';
            Editable = false;
            FieldClass = FlowField;
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
            CalcFormula = Sum("Application Payment Entry".Amount WHERE("Document No." = FIELD("Application No."),
                                                                        Posted = CONST(true),
                                                                        "Document Type" = CONST(BOND),
                                                                        "Cheque Status" = FILTER(<> Bounced)));
            FieldClass = FlowField;
        }
        field(50012; "Incl. Mem. Fee"; Boolean)
        {
            Description = 'ALLETDK200313';
        }
        field(50020; "Old Process"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50021; "Comm hold for Old Process"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50099; "Actual Registration Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Maping with Plot Registraton';
        }
        field(50100; "Incentive Calculate"; Boolean)
        {
        }
        field(50101; "Discount Payment Type"; Option)
        {
            Description = 'BBG1.6 311213';
            OptionCaption = ' ,Forfeit,Excess Payment';
            OptionMembers = " ",Forfeit,"Excess Payment";

            trigger OnValidate()
            begin
                IF "Discount Payment Type" = "Discount Payment Type"::Forfeit THEN BEGIN
                    CALCFIELDS("Total Received Amount");
                    AppPaymentEntry.RESET;
                    AppPaymentEntry.SETRANGE("Application No.", "No.");
                    AppPaymentEntry.SETRANGE("Cheque Status", AppPaymentEntry."Cheque Status"::" ");
                    IF AppPaymentEntry.FINDFIRST THEN
                        AppPaymentEntry.TESTFIELD("Cheque Status");

                    IF "Forfeiture / Excess Amount" = 0 THEN
                        "Forfeiture / Excess Amount" := "Total Received Amount";
                END;
            end;
        }
        field(50102; "Forfeiture / Excess Amount"; Decimal)
        {
            Description = 'BBG1.6 311213';

            trigger OnValidate()
            begin
                TESTFIELD("Discount Payment Type");

                CALCFIELDS("Total Received Amount");
                IF "Total Received Amount" < "Forfeiture / Excess Amount" THEN
                    ERROR('Amount can not be greater than Total Received Amount');
            end;
        }
        field(50104; "Comm. Amt Adj. in case Forfeit"; Decimal)
        {
            Description = 'BBG1.6 311213';

            trigger OnValidate()
            begin
                IF "Comm. Amt Adj. in case Forfeit" <> 0 THEN BEGIN
                    CreditAppPayEntry.RESET;
                    CreditAppPayEntry.SETRANGE("Document No.", "No.");
                    CreditAppPayEntry.SETRANGE(Posted, FALSE);
                    IF NOT CreditAppPayEntry.FINDSET THEN
                        ERROR('First Generate Discount Line Entries from Function');

                    IF "BBG Discount" < 0 THEN
                        ERROR('Amount should be in +ve value');
                END;
            end;
        }
        field(50105; "Travel Not Generate"; Boolean)
        {
            Description = 'BBG1.4 220114';
        }
        field(50106; "No. of Plots"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50110; "Commission Hold on Full Pmt"; Boolean)
        {

            trigger OnValidate()
            begin
                //ALLEDK 200213
                MemberOf.RESET;
                MemberOf.SETRANGE("User Name", USERID);
                MemberOf.SETRANGE("Role ID", 'A_CommHold');
                IF NOT MemberOf.FINDFIRST THEN
                    ERROR('You are not authorised to perform this task');
                //ALLEDK 200213
                IF NOT "Commission Hold on Full Pmt" THEN BEGIN
                    UnitCommBuffer.RESET;
                    UnitCommBuffer.SETRANGE(UnitCommBuffer."Unit No.", "No.");
                    IF UnitCommBuffer.FINDSET THEN
                        REPEAT
                            UnitCommBuffer."Comm Not Release after FullPmt" := FALSE;
                            UnitCommBuffer.MODIFY;
                        UNTIL UnitCommBuffer.NEXT = 0;
                    "Comm hold for Old Process" := FALSE;
                END;
            end;
        }
        field(50111; "Company Name"; Text[30])
        {
            Editable = false;
            TableRelation = Company;
        }
        field(50112; "Application Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Trading,Non Trading';
            OptionMembers = Trading,"Non Trading";
        }
        field(50113; "Application Transfered"; Boolean)
        {
            Editable = false;
        }
        field(50114; "Total Elegibility Amount"; Decimal)
        {
            Editable = false;
        }
        field(50115; "Filters on Team Head"; Code[20])
        {
        }
        field(50120; "Silver Coin Generated"; Boolean)
        {
            Editable = false;
        }
        field(50121; "Silver Coin Eligible"; Boolean)
        {

            trigger OnValidate()
            begin
                MemberOf.RESET;
                MemberOf.SETRANGE("User Name", USERID);
                MemberOf.SETRANGE("Role ID", 'A_SilverCoin');
                IF NOT MemberOf.FINDFIRST THEN
                    ERROR('You do not have permission of Role : A_SilverCoin');
            end;
        }
        field(50200; "Total Clear App. Amt"; Decimal)
        {
            CalcFormula = Sum("Application Payment Entry".Amount WHERE("Document No." = FIELD("No."),
                                                                        "Cheque Status" = CONST(Cleared)));
            Description = 'ALLE 241014';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50201; "Unit Payment Plan"; Code[20])
        {
            TableRelation = "App. Charge Code".Code WHERE("Sub Payment Plan" = FILTER(true),
                                                           "Show Payment Plan on Receipt" = FILTER(true));
        }
        field(50202; "New Unit Payment Plan"; Code[20])
        {
            TableRelation = "App. Charge Code".Code WHERE("Sub Payment Plan" = const(true));

            trigger OnValidate()
            begin
                IF UnitMaster.GET("New Unit No.") THEN BEGIN
                    IF UnitMaster."PLC Applicable" THEN
                        IF "New Unit Payment Plan" <> '' THEN
                            IF "New Unit Payment Plan" <> '1006' THEN
                                ERROR('Please select Unit Payment Plan - 1006');
                END;
            end;
        }
        field(50203; "Unit Plan Name"; Text[50])
        {
            Editable = false;
        }
        field(50204; "Gold Coin Transfer in Trading"; Decimal)
        {
            Description = '031315 ALLE';
            Editable = false;
        }
        field(50205; "Silver Coin Issued"; Decimal)
        {
            CalcFormula = - Sum("Item Ledger Entry".Quantity WHERE("Application No." = FIELD("No."),
                                                                   "Item Type" = FILTER(Silver)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50206; "Gold Coin Value"; Decimal)
        {
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Application No." = FIELD("No."),
                                                                          "Gen. Prod. Posting Group" = FILTER('GOLDCOIN')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50207; "Silver Coin Value"; Decimal)
        {
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Application No." = FIELD("No."),
                                                                          "Gen. Prod. Posting Group" = FILTER('SILVERKALA')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50208; "Sales Invoice booked"; Boolean)
        {
            Editable = false;
        }
        field(50209; "Posted Sales Inv. Doc. No."; Code[20])
        {
            CalcFormula = Lookup("Sales Invoice Header"."No." WHERE("External Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50210; "Method Applicable"; Option)
        {
            OptionCaption = ' ,COD Method,Normal Method';
            OptionMembers = " ","COD Method","Normal Method";
        }
        field(50211; "Sales Invoice Applicable"; Boolean)
        {

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Registered);
                TESTFIELD("Sales Invoice booked", FALSE);
            end;
        }
        field(50236; "Development Charges"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50237; "Total Received Dev. Charges"; Decimal)
        {
            CalcFormula = Sum("New Application DevelopmntLine".Amount WHERE("Document No." = FIELD("No."),
                                                                             Posted = CONST(true),
                                                                             "Document Type" = CONST(BOND),
                                                                             "Cheque Status" = FILTER(' ' | Cleared)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50239; "IC Purchase Order Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50245; "60 feet road"; Boolean)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(50246; "100 feet road"; Boolean)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(50247; "Registration Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Initiated,Completed';
            OptionMembers = " ",Initiated,Completed;

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
                v_NConfirmedOrder: Record "New Confirmed Order";
            begin
                UserSetup.RESET;
                IF UserSetup.GET(USERID) THEN
                    IF NOT UserSetup."Registration Status Modify" THEN
                        ERROR('Contact Admin');

                v_NConfirmedOrder.RESET;
                IF v_NConfirmedOrder.GET("No.") THEN BEGIN
                    v_NConfirmedOrder."Registration Status" := "Registration Status";
                    v_NConfirmedOrder.MODIFY;
                END;
            end;
        }
        field(50249; "Refund SMS Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Initiated,Verified,Approved';
            OptionMembers = " ",Initiated,Verified,Approved;
        }
        field(50250; "Refund Initiate Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50334; "Last Receipt Date"; Date)
        {
            CalcFormula = Max("NewApplication Payment Entry"."Posting date" WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
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
        field(50339; "Purchase Invoice Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESSS';
        }
        field(50340; "Sales Invoice Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESSS';
        }
        field(50341; "Registration Initiated Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                v_NConfirmedOrder: Record "New Confirmed Order";
            begin
            end;
        }
        field(50501; "Gold Generated for R2"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60012; "Min. Allotment Amount"; Decimal)
        {
            Editable = false;
        }
        field(60013; "Application Closed"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
                v_NConfirmedOrder: Record "New Confirmed Order";
            begin
                UserSetup.RESET;
                IF UserSetup.GET(USERID) THEN
                    IF NOT UserSetup."Application Closed" THEN
                        ERROR('Contact Admin');


                v_NConfirmedOrder.RESET;
                IF v_NConfirmedOrder.GET("No.") THEN BEGIN
                    v_NConfirmedOrder."Application Closed" := "Application Closed";
                    v_NConfirmedOrder.MODIFY;
                END;
            end;
        }
        field(90000; "Unit Code"; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Unit Code" <> '' THEN BEGIN
                    IF UnitMaster.GET("Unit Code") THEN BEGIN
                        "Payment Plan" := UnitMaster."Payment Plan";
                        "No. of Plots" := UnitMaster."No. of Plots";
                    END;
                END ELSE
                    "Payment Plan" := '';
            end;
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

            trigger OnValidate()
            begin
                //ALLETDK231112..BEGIN
                IF (Status = Status::Cancelled) THEN
                    ERROR('Status must not be %1', Status);
                //ALLETDK231112..END
            end;
        }
        field(90005; "Travel Calculated"; Boolean)
        {
            Editable = false;
        }
        field(90006; "Amount Refunded"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("BBG Order Ref No." = FIELD("Application No."),
                                                        "Document Type" = FILTER(Refund)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90007; "Penalty Document No."; Code[20])
        {
            Editable = false;
        }
        field(90008; "Saleable Area"; Decimal)
        {
            Editable = false;
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
        field(90012; "New Unit No."; Code[20])
        {
            TableRelation = "Unit Master" WHERE(Status = FILTER(Open),
                                                 Freeze = FILTER(false),
                                                 "Project Code" = FIELD("New Project"));
            //Archived = CONST(Yes));

            trigger OnValidate()
            var
                OldConforder: Record "Confirmed Order";
            begin

                RecApplication.RESET;
                RecApplication.SETRANGE("Application No.", "No.");
                IF RecApplication.FINDFIRST THEN BEGIN
                    RecApplication.DELETE;
                END;

                IF "New Unit No." <> '' THEN BEGIN
                    RecApplication.RESET;
                    RecApplication.SETCURRENTKEY("Unit Code");
                    RecApplication.SETRANGE("Unit Code", "New Unit No.");
                    IF RecApplication.FINDFIRST THEN BEGIN
                        RecApplication.DELETE;
                    END;
                END;
                COMMIT;

                UnitMaster.RESET;
                IF UnitMaster.GET("New Unit No.") THEN BEGIN
                    UnitMaster.TESTFIELD("Unit Category", UnitMaster."Unit Category"::Normal);
                    IF UnitMaster."PLC Applicable" THEN BEGIN
                        "New Unit Payment Plan" := '1006';
                        "No. of Plots" := UnitMaster."No. of Plots"; //090620
                        "60 feet road" := UnitMaster."60 feet Road"; //090921
                        "100 feet road" := UnitMaster."100 feet Road";  //090921
                        VALIDATE("New Unit Payment Plan");
                    END;

                    IF Job.GET(UnitMaster."Project Code") THEN
                        Job.TESTFIELD(Job."Default Project Type");
                    IF Type = Type::Priority THEN
                        IF "Shortcut Dimension 1 Code" <> UnitMaster."Project Code" THEN
                            ERROR('Please select unit with same project code');
                    //ALLEDK 250113
                    DocMaster.RESET;
                    DocMaster.SETRANGE("Project Code", UnitMaster."Project Code");
                    DocMaster.SETRANGE("Unit Code", "New Unit No.");
                    IF DocMaster.FINDFIRST THEN
                        DocMaster.TESTFIELD(Status, DocMaster.Status::Release);
                    //ALLEDK 250113
                END;



                IF "New Unit No." <> '' THEN BEGIN
                    Rec.TestField("New Project");  //Code added 01072025 
                    REc.TestField("New Region code");  //Code added 01072025 
                    ConfrimedOrder.RESET;
                    ConfrimedOrder.SETRANGE("Application Transfered", FALSE);
                    ConfrimedOrder.SETRANGE("Unit Code", "New Unit No.");
                    IF ConfrimedOrder.FINDFIRST THEN
                        ERROR('You have already used this Unit against this Confirmed Order No.' + '' + ConfrimedOrder."No.");

                    Application.RESET;
                    Application.SETRANGE("Unit Code", "New Unit No.");
                    IF Application.FINDFIRST THEN
                        ERROR('You have already used this Unit against this Application No. ' + '' + Application."Application No.");
                    /*
                    IF Type = Type::Normal THEN BEGIN
                      IF RecUnitMaster1.GET("New Unit No.") THEN BEGIN
                        ArchiveConforder.RESET;
                        ArchiveConforder.SETCURRENTKEY("No.","Version No.");
                        ArchiveConforder.SETRANGE("No.","No.");
                        ArchiveConforder.SETFILTER("Unit Code",'<>%1','');
                        IF ArchiveConforder.FINDLAST THEN BEGIN
                          IF RecUnitMaster1."Saleable Area"< ArchiveConforder."Saleable Area" THEN
                            ERROR('The New Unit Extent is Less than existing Unit Extent. Please select same extent or Higher Extent ');
                        END;
                      END;
                    END;
                    */
                END;

            end;
        }
        field(90013; "Payment Plan"; Code[20])
        {
            Description = 'ALLEDK 010113 length change';
        }
        field(90014; "New Project"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "IS Project" = CONST(true));

            trigger OnValidate()
            var
                CompanyWise_1: Record "Company wise G/L Account";
                RecJob_1: Record Job;
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.GET;
                CompanyWise_1.RESET;
                CompanyWise_1.SETRANGE("MSC Company", TRUE);
                IF CompanyWise_1.FINDFIRST THEN BEGIN
                    IF CompanyWise_1."Company Code" = COMPANYNAME THEN BEGIN
                        RecJob_1.RESET;
                        RecJob_1.SETRANGE("No.", "New Project");
                        RecJob_1.SETRANGE(Trading, TRUE);
                        IF NOT RecJob_1.FINDFIRST THEN
                            ERROR('Please select Right Project code');
                    END;
                END;
            end;
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

            trigger OnValidate()
            begin
                //ALLEDK 200213
                MemberOf.RESET;
                MemberOf.SETRANGE("User Name", USERID);
                MemberOf.SETRANGE("Role ID", 'A_CommHold');
                IF NOT MemberOf.FINDFIRST THEN
                    ERROR('You are not authorised to perform this task');
                //ALLEDK 200213
            end;
        }
        field(90020; "Comm. Base Amt. to be Adj."; Decimal)
        {
            Description = 'ALLEDK 090113';

            trigger OnValidate()
            begin

                IF "Comm. Base Amt. to be Adj." < 0 THEN
                    ERROR('Amount must be +Ve');

                IF "Comm. Base Amt. to be Adj." > 0 THEN BEGIN
                    CALCFIELDS("Commission Base Amount");
                    IF "Comm. Base Amt. to be Adj." > "Commission Base Amount" THEN
                        ERROR('Comm. Base Amt to be Adj must be Equal OR Less to Commission Base Amount');
                END;
            end;
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

            trigger OnValidate()
            begin
                IF "Amount Adj. Associate" <> 0 THEN BEGIN
                    CreditAppPayEntry.RESET;
                    CreditAppPayEntry.SETRANGE("Document No.", "No.");
                    CreditAppPayEntry.SETRANGE(Posted, FALSE);
                    IF NOT CreditAppPayEntry.FINDSET THEN
                        ERROR('First Generate Discount Line Entries from Function');

                    IF "Amount Adj. Associate" < 0 THEN
                        ERROR('Amount should be in +ve value');



                    CALCFIELDS("Total Received Amount");
                    "Net Due Amount" := Amount + "Service Charge Amount" - "Discount Amount" - "Total Received Amount" - "BBG Discount" -
                    "Amount Adj. Associate";

                    IF "Net Due Amount" < 0 THEN BEGIN
                        ERROR('Net Due Amount can not be less than 0 value');
                    END;
                END;
            end;
        }
        field(90026; "BBG Discount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "BBG Discount" <> 0 THEN BEGIN
                    CreditAppPayEntry.RESET;
                    CreditAppPayEntry.SETRANGE("Document No.", "No.");
                    CreditAppPayEntry.SETRANGE(Posted, FALSE);
                    IF NOT CreditAppPayEntry.FINDSET THEN
                        ERROR('First Generate Discount Line Entries from Function');

                    IF "BBG Discount" < 0 THEN
                        ERROR('Amount should be in +ve value');


                    CALCFIELDS("Total Received Amount");
                    "Net Due Amount" := Amount + "Service Charge Amount" - "Discount Amount" - "Total Received Amount" - "BBG Discount" -
                    "Amount Adj. Associate";

                    IF "Net Due Amount" < 0 THEN BEGIN
                        ERROR('Net Due Amount can not be less than 0 value');
                    END;
                END;
            end;
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
            Editable = true;
        }
        field(90030; "AJVM Associate Code"; Code[20])
        {
            Description = 'ALLEDK 270113';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                TotalInvAmount_1: Decimal;
                CompanyWiseGL_2: Record "Company wise G/L Account";
                VLEntry_2: Record "Vendor Ledger Entry";
            begin
                TESTFIELD("Application Closed", FALSE);
                "AJVM Associate Balance" := 0;
                IF Vend.GET("AJVM Associate Code") THEN BEGIN
                    Vend.TESTFIELD("BBG Black List", FALSE);
                    //  Vend.CALCFIELDS(Vend."Commission Amount Qualified");
                    //  Vend.CALCFIELDS(Vend."Travel Amount Qualified");
                    //  Vend.CALCFIELDS(Vend."Incentive Amount Qualified");
                    Vend.CALCFIELDS(Vend."BBG Balance at Date (LCY)");

                    //"AJVM Associate Balance" := Vend."Commission Amount Qualified" + Vend."Travel Amount Qualified" + Vend.
                    //"Incentive Amount Qualified"-
                    //                            Vend."Balance at Date (LCY)";

                    "AJVM Associate Balance" := Vend."BBG Balance at Date (LCY)";

                    TotalInvAmount_1 := 0;
                    CompanyWiseGL_2.RESET;
                    IF CompanyWiseGL_2.FINDSET THEN
                        REPEAT
                            VLEntry_2.RESET;
                            VLEntry_2.CHANGECOMPANY(CompanyWiseGL_2."Company Code");
                            VLEntry_2.SETCURRENTKEY("Vendor No.", "Posting Date");
                            VLEntry_2.SETFILTER("Vendor No.", "AJVM Associate Code");
                            VLEntry_2.SETRANGE("Posting Date", 0D, TODAY);
                            VLEntry_2.SETFILTER("Posting Type", '<>%1', VLEntry_2."Posting Type"::Incentive);
                            IF VLEntry_2.FINDSET THEN
                                REPEAT
                                    VLEntry_2.CALCFIELDS(VLEntry_2."Remaining Amt. (LCY)");
                                    TotalInvAmount_1 := TotalInvAmount_1 + VLEntry_2."Remaining Amt. (LCY)";
                                UNTIL VLEntry_2.NEXT = 0;
                        UNTIL CompanyWiseGL_2.NEXT = 0;
                    IF TotalInvAmount_1 < 0 THEN
                        "Total Elegibility Amount" := ABS(TotalInvAmount_1);
                END;
            end;
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
            FieldClass = Normal;
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
        field(90059; "Unit Facing"; Option)
        {
            Editable = false;
            OptionCaption = 'NA,East,West,North,South,NorthWest,SouthEast,NorthEast,SouthWest';
            OptionMembers = NA,East,West,North,South,NorthWest,SouthEast,NorthEast,SouthWest;
        }
        field(90075; "Registration Bonus Hold(BSP2)"; Boolean)
        {
            Description = 'BBG1.00 010413';

            trigger OnValidate()
            begin
                MemberOf.RESET;
                MemberOf.SETRANGE("User Name", USERID);
                MemberOf.SETRANGE("Role ID", 'A_HOLDRB');
                IF NOT MemberOf.FINDFIRST THEN
                    ERROR('You do not have permission of Role : A_HOLDRB');

                AmtComm := 0;

                "Commission Entry".RESET;
                "Commission Entry".SETRANGE("Commission Entry"."Application No.", "No.");
                "Commission Entry".SETRANGE("Commission Entry"."Introducer Code", "Introducer Code");
                "Commission Entry".SETRANGE("Commission Entry".Posted, TRUE);
                "Commission Entry".SETRANGE("Commission Entry"."Opening Entries", FALSE);
                "Commission Entry".SETRANGE("Commission Entry"."Direct to Associate", TRUE);
                IF "Commission Entry".FINDFIRST THEN BEGIN
                    REPEAT
                        AmtComm := AmtComm + "Commission Entry"."Commission Amount";
                    UNTIL "Commission Entry".NEXT = 0;
                    IF AmtComm > 0 THEN
                        ERROR('You have already paid Registration %1', "No.");
                END;

                TESTFIELD("Registration No.");
                TESTFIELD("Registration Date");



                IF "Registration Bonus Hold(BSP2)" = FALSE THEN BEGIN
                    "RB Release by User ID" := USERID;
                    "Date/Time of RB Release" := CURRENTDATETIME;
                END ELSE BEGIN
                    "RB Release by User ID" := '';
                    "Date/Time of RB Release" := 0DT;
                END;

                CommEntry.RESET;
                CommEntry.SETRANGE("Application No.", "No.");
                IF CommEntry.FINDSET THEN
                    REPEAT
                        CommEntry."Registration Bonus Hold(BSP2)" := "Registration Bonus Hold(BSP2)";
                        CommEntry.MODIFY;
                    UNTIL CommEntry.NEXT = 0;

                //BBG2.01 221214
                IF "Application Type" = "Application Type"::"Non Trading" THEN BEGIN
                    CompanyWise.RESET;
                    CompanyWise.SETRANGE(CompanyWise."MSC Company", TRUE);
                    IF CompanyWise.FINDFIRST THEN BEGIN
                        IF CompanyWise."Company Code" <> COMPANYNAME THEN BEGIN
                            NewConfOrder.RESET;
                            IF NewConfOrder.GET("No.") THEN BEGIN
                                NewConfOrder."Registration Bonus Hold(BSP2)" := "Registration Bonus Hold(BSP2)";
                                NewConfOrder.MODIFY;
                            END;
                        END ELSE
                            ERROR('This activity will do from Respective Company');
                    END;
                END;
                //BBG2.01 221214
            end;
        }
        field(90076; MinAmt; Decimal)
        {
        }
        field(90077; "RB Amount"; Decimal)
        {
            CalcFormula = Sum("Payment Terms Line Sale"."Due Amount" WHERE("Document No." = FIELD("No."),
                                                                            "Direct Associate" = CONST(true)));
            Description = 'ALLECK 040613';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90078; "Received RB Amount"; Decimal)
        {
            CalcFormula = Sum("Unit Payment Entry".Amount WHERE("Document No." = FIELD("No."),
                                                                 "Direct Associate" = CONST(true)));
            Description = 'ALLECK 040613';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90079; "Commission RB Amount"; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Commission Amount" WHERE("Application No." = FIELD("No."),
                                                                            "Direct to Associate" = CONST(true)));
            Description = 'BBG1.00 060613';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90080; "Gold Coin Issued"; Decimal)
        {
            CalcFormula = - Sum("Item Ledger Entry".Quantity WHERE("Application No." = FIELD("No."),
                                                                   "Item Type" = FILTER(Gold)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90081; "Registration SMS Sent"; Boolean)
        {
            Description = 'BBG1.00 270613';
            Editable = false;
        }
        field(90082; "Before Registration SMS Sent"; Boolean)
        {
            Description = 'BBG1.00 270613';
            Editable = false;
        }
        field(90083; "Sent SMS on Plot Cancellation"; Boolean)
        {
            Description = 'BBG2.00 080814';
        }
        field(90084; "Sent SMS on Full Amount"; Boolean)
        {
            Description = 'BBG2.00 110814';
        }
        field(90085; "Sent SMS on Acknoledgement"; Boolean)
        {
            Description = 'BBG2.00 120814';
        }
        field(90086; "Sent SMS on Full Pmt Gold Coin"; Boolean)
        {
            Description = 'BBG2.00 120814';
        }
        field(90087; "Sent SMS on Partial Gold Coin"; Boolean)
        {
            Description = 'BBG2.00 120814';
        }
        field(90088; "App Consider on Comm Elg Repor"; Boolean)
        {
            Editable = false;
        }
        field(90089; "RB Release by User ID"; Code[20])
        {
            Editable = false;
        }
        field(90090; "Date/Time of RB Release"; DateTime)
        {
            Editable = false;
        }
        field(90091; "commission calculated"; Boolean)
        {
        }
        field(90092; "Commission Base amt"; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Base Amount" WHERE("Application No." = FIELD("No."),
                                                                      "Business Type" = FILTER(SELF),
                                                                      "Opening Entries" = FILTER(false),
                                                                      "Direct to Associate" = FILTER(false),
                                                                      "Commission Amount" = FILTER(<> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90093; "Commission applicable base amt"; Decimal)
        {
            CalcFormula = Sum("Applicable Charges"."Net Amount" WHERE("Document No." = FIELD("No."),
                                                                       "Commision Applicable" = FILTER(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90094; "Project Change"; Boolean)
        {
            Editable = false;
        }
        field(90095; "Project change Comment"; Text[50])
        {
        }
        field(90096; "Check RB Reg"; Boolean)
        {
        }
        field(90097; "Vizag datA"; Boolean)
        {
            Editable = false;
        }
        field(90098; "For Checking Collection"; Boolean)
        {
        }
        field(90099; "LLP Name"; Text[30])
        {
            Editable = true;
        }
        field(90100; "Total Commission Amt."; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Commission Amount" WHERE("Application No." = FIELD("No."),
                                                                            "Opening Entries" = FILTER(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90101; Findentry; Boolean)
        {
            Editable = false;
        }
        field(90102; "App Transfer in LLPs"; Boolean)
        {
            Editable = false;
        }
        field(90103; "Amount Difference"; Boolean)
        {
            Editable = false;
        }
        field(90104; "Regi. Update Dt."; Date)
        {
            Editable = false;
        }
        field(90105; "Regi. Update Time"; Time)
        {
            Editable = false;
        }
        field(90106; "Regi. Update"; Boolean)
        {

            trigger OnValidate()
            begin
                MemberOf.RESET;
                MemberOf.SETRANGE("User Name", USERID);
                MemberOf.SETRANGE("Role ID", 'A_UNITREGISTRATION');
                IF NOT MemberOf.FINDFIRST THEN
                    ERROR('You do not have permission of Role :A_UNITREGISTRATION');

                "Regi. Update Dt." := TODAY;
                "Regi. Update Time" := TIME;
            end;
        }
        field(90107; "Received more than 25"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90108; "New Total Received Amount"; Decimal)
        {
            CalcFormula = Sum("NewApplication Payment Entry".Amount WHERE("Document No." = FIELD("Application No."),
                                                                           Posted = CONST(true),
                                                                           "Document Type" = CONST(BOND),
                                                                           "Cheque Status" = FILTER(<> Bounced)));
            FieldClass = FlowField;
        }
        field(90109; "GST Base Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90110; "Send for Approval (Unit Allot)"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90111; "Send for Aproval Dt (UnitAllt)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90112; "Approval Status (Unit Allot)"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
        }
        field(90113; "Send for Approval (Unit Vacte)"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90114; "Send for Aproval Dt (UnitVct)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90115; "Approval Status (Unit Vacte)"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
        }
        field(90116; "Send for Approval (Member)"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90117; "Send for Aproval Dt (Member)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90118; "Approval Status (Member)"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
        }
        field(90119; "Direct Incentive Amount"; Decimal)
        {
            CalcFormula = Sum("G/L Entry"."Debit Amount" WHERE("BBG Direct Incentive App. No." = FIELD("No."),
                                                                "Source Type" = CONST(Vendor),
                                                                "Source No." = FIELD("Introducer Code"),
                                                                "Bal. Account No." = FILTER(''),
                                                                "BBG Posting Type" = CONST(Incentive),
                                                                "BBG Special Incentive Bonanza" = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90120; "Loan File"; Boolean)   //251124 Added new field
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60045; "New Loan File"; Option)     //251124 New field
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Yes,No;
            OptionCaption = ' ,Yes,No';
        }

        field(90122; "Gold/Silver Voucher Issued"; Decimal)   //080425 New field added
        {
            CalcFormula = Sum("Item LEdger Entry"."Quantity" WHERE("Application No." = FIELD("No."),
                                                                "Item Type" = filter('Gold_SilverVoucher')));
            Editable = false;
            FieldClass = FlowField;

        }

        field(90123; "R194 Gift Issued"; Boolean)   //251124 Added new field
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(90124; "Total Cleared Received Amount"; Decimal)
        {
            CalcFormula = Sum("Application Payment Entry".Amount WHERE("Document No." = FIELD("Application No."),
                                                                        Posted = CONST(true),
                                                                        "Document Type" = CONST(BOND),
                                                                        "Cheque Status" = FILTER(Cleared)));
            FieldClass = FlowField;
        }

        field(90125; "App. applicable for issue R194"; Boolean)   //251124 Added new field
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90126; "Registration No. 2"; Code[50])   //251124 Added new field
        {
            DataClassification = ToBeClassified;

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

        }
        field(90060; "Customer State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;
        }
        field(60040; "District Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'District Code';
            DataClassification = ToBeClassified;
            TableRelation = "District Details".Code where("State Code" = field("Customer State Code"));
            Editable = False;
        }
        field(60041; "Mandal Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Mandal Code';
            DataClassification = ToBeClassified;
            TableRelation = "Mandal Details".Code where("State Code" = field("Customer State Code"), "District Code" = field("District Code"));
            Editable = False;
        }
        field(60042; "Village Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Village Name';
            DataClassification = ToBeClassified;
            TableRelation = "Village Details".Code where("State Code" = field("Customer State Code"), "District Code" = field("District Code"), "Mandal Code" = field("Mandal Code"));
            Editable = False;
        }

    }

    keys
    {
        key(Key1; "No.")
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
        key(Key15; "Introducer Code", "No.", "Posting Date")
        {
        }
        key(Key16; "Shortcut Dimension 1 Code")
        {
        }
        key(Key17; "Pass Book No.")
        {
        }
        key(Key18; "App Consider on Comm Elg Repor")
        {
        }
        key(Key19; "Sent SMS on Full Pmt Gold Coin")
        {
        }
        key(Key20; "Commission Not Generate", "Commission Hold on Full Pmt", "Posting Date")
        {
        }
        key(Key21; "Sales Invoice Applicable", "Registration Date", Status)
        {
        }
        key(Key22; "Commission Hold on Full Pmt", Status)
        {
        }
        key(Key23; "Old Process", "Commission Hold on Full Pmt", Status)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ERROR('Unit No cannot be deleted');

        IF Status = Status::Registered THEN
            ERROR(Text002);

        TESTFIELD("Application Closed", FALSE);
    end;

    trigger OnModify()
    begin
        //IF Status = Status::Registered THEN  220724
        //ERROR(Text002);
    end;

    var
        SchemeHeader: Record "Document Type Initiator";
        Text001: Label 'You cannot rename a %1.';
        Text002: Label 'Order is already Registered.\Not allowed to modify or delete';
        BondPmtLine: Record "Unit Payment Entry";
        ApplicationPaymentEntry: Record "Application Payment Entry";
        TotalRcvdAmt: Decimal;
        UnitMaster: Record "Unit Master";
        ConfrimedOrder: Record "Confirmed Order";
        Application: Record Application;
        RecUnitMaster: Record "Unit Master";
        Job: Record Job;
        DocMaster: Record "Document Master";
        Vend: Record Vendor;
        CreditAppPayEntry: Record "Debit App. Payment Entry";
        RecUnitMaster1: Record "Unit Master";
        ArchiveConforder: Record "Archive Confirmed Order";
        "Commission Entry": Record "Commission Entry";
        AmtComm: Decimal;
        AppPaymentEntry: Record "Application Payment Entry";
        UnitCommBuffer: Record "Unit & Comm. Creation Buffer";
        CreatingUnitPaymentEntries: Codeunit "Creat UPEry from ConfOrder/APP";
        PostPayment: Codeunit PostPayment;
        CompanyWise: Record "Company wise G/L Account";
        NewConfOrder: Record "New Confirmed Order";
        CommEntry: Record "Commission Entry";
        MemberOf: Record "Access Control";
        RecApplication: Record Application;


    procedure TotalApplicationAmount(): Decimal
    begin
    end;


    procedure AmountRecdAppl(ApplicationNo: Code[20]): Decimal
    var
        RecdAmount: Decimal;
        Bond: Record "Confirmed Order";
    begin
        Bond.GET("Application No.");
        BondPmtLine.RESET;
        BondPmtLine.SETRANGE("Document Type", BondPmtLine."Document Type"::BOND);
        BondPmtLine.SETRANGE("Document No.", Bond."Application No.");
        BondPmtLine.SETRANGE("Cheque Status", BondPmtLine."Cheque Status"::Cleared); //ALLETDK220213
        BondPmtLine.SETRANGE("Priority Payment", FALSE); //ALLEDK 221112
        IF BondPmtLine.FINDSET THEN
            REPEAT
                /*
                IF BondPmtLine."Payment Mode" = BondPmtLine."Payment Mode" :: Cash THEN
                  RecdAmount := RecdAmount + BondPmtLine.Amount;
                IF BondPmtLine."Payment Mode" = BondPmtLine."Payment Mode" :: AJVM THEN
                  RecdAmount := RecdAmount + BondPmtLine.Amount;

                IF BondPmtLine."Payment Mode" = BondPmtLine."Payment Mode" :: MJVM THEN
                  RecdAmount := RecdAmount + BondPmtLine.Amount;

                IF BondPmtLine."Payment Mode" = BondPmtLine."Payment Mode" :: "Refund Cash" THEN
                  RecdAmount := RecdAmount + BondPmtLine.Amount;
                IF (((BondPmtLine."Payment Mode" = BondPmtLine."Payment Mode" :: Bank) OR
                   (BondPmtLine."Payment Mode" = BondPmtLine."Payment Mode" ::"D.C./C.C./Net Banking")) AND
                   (BondPmtLine."Cheque Status" =  BondPmtLine."Cheque Status" ::Cleared)) THEN
                  RecdAmount := RecdAmount + BondPmtLine.Amount;
                IF (BondPmtLine."Payment Mode" = BondPmtLine."Payment Mode" :: "D.D.") THEN
                */
                RecdAmount := RecdAmount + BondPmtLine.Amount;
            UNTIL BondPmtLine.NEXT = 0;
        EXIT(RecdAmount);

    end;


    procedure CheckPaymentAmt(): Decimal
    var
        ApplPayEntry: Record "Application Payment Entry";
        PayAmount: Decimal;
    begin
        //BBG1.00 ALLEDK 050313
        CLEAR(PayAmount);
        ApplPayEntry.RESET;
        ApplPayEntry.SETRANGE("Document No.", "Application No.");
        ApplPayEntry.SETRANGE(Posted, FALSE);
        IF ApplPayEntry.FINDSET THEN
            REPEAT
                PayAmount += ApplPayEntry.Amount;
            UNTIL ApplPayEntry.NEXT = 0;
        EXIT(PayAmount);
        //BBG1.00 ALLEDK 050313
    end;


    procedure PostReceipt(NewConfOrderReceipt: Record "Confirmed Order")
    var
        ExcessAmount: Decimal;
    begin

        CLEAR(ExcessAmount);
        ExcessAmount := CreatingUnitPaymentEntries.CheckExcessAmount(NewConfOrderReceipt);
        IF ExcessAmount <> 0 THEN
            CreatingUnitPaymentEntries.CreateExcessPaymentTermsLine(NewConfOrderReceipt."No.", ExcessAmount);

        CreatingUnitPaymentEntries.RUN(NewConfOrderReceipt);
        PostPayment.PostBondPayment(NewConfOrderReceipt, TRUE);
    end;

    local procedure "-------------"()
    begin
    end;


    procedure CheckApprovalMembertoMemberStatus(NewAppEntries: Record "Application Payment Entry")
    var
        RequesttoApproveDocuments: Record "Request to Approve Documents";
    begin
        RequesttoApproveDocuments.RESET;
        RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Member to Member Transfer");
        RequesttoApproveDocuments.SETRANGE("Document No.", NewAppEntries."Document No.");
        RequesttoApproveDocuments.SETRANGE("Document Line No.", NewAppEntries."Line No.");
        RequesttoApproveDocuments.SETRANGE(Status, RequesttoApproveDocuments.Status::" ");
        IF RequesttoApproveDocuments.FINDFIRST THEN
            ERROR('Approval Pending');
    end;
}

