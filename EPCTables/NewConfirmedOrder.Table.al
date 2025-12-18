table 50015 "New Confirmed Order"
{
    // Below key has been used in the PAGE 50080
    // Investment Type,Bond No.,Introducer Code,Status,Return Payment Mode,Blocked
    // ALLECK 270612: Removed "sqft" from fields names "Super Area Sqft","Saleable Area Sqft","Carpet Area Sqft",
    //                "Sales Rate sqft","Lease Rate Sqft".
    // ALLETDK021112: Changed FlowField of "Total Received Amount" field.
    //  ALLETDK231112: Changed "Penalty Amount" Editable property YES
    // ALLEDK15112022 Added new code for SMS Log details
    // 270923 Approval Workflow Functions

    Caption = 'New Confirmed Order';
    DataPerCompany = false;
    DrillDownPageID = "Confirm Order List (POC)";
    LookupPageID = "Confirm Order List (POC)";

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
            Editable = false;
            TableRelation = Customer;
        }
        field(6; "Introducer Code"; Code[20])
        {
            Caption = 'IBA Code';
            Editable = false;
            TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)" | "CP(Channel Partner)"),
                                          "BBG Status" = FILTER(Active | Provisional));
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
        }
        field(12; Status; Option)
        {
            Editable = true;
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
            Editable = false;
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
            CalcFormula = Sum("NewApplication Payment Entry".Amount WHERE("Document No." = FIELD("No."),
                                                                           "Payment Mode" = FILTER('Debit Note'),
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
            TableRelation = Vendor WHERE("BBG Status" = FILTER(Active | Provisional),
                                          "BBG Vendor Category" = FILTER("IBA(Associates)"));
        }
        field(26; "Received From Code"; Code[20])
        {
            Editable = true;
            TableRelation = IF ("Received From" = CONST("Marketing Member")) Vendor."No."
            ELSE IF ("Received From" = CONST("Bond Holder")) Customer."No.";
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
            CalcFormula = Sum("NewApplication Payment Entry".Amount WHERE("Document No." = FIELD("No."),
                                                                           Posted = CONST(true),
                                                                           "Document Type" = CONST(BOND),
                                                                           "Cheque Status" = FILTER(' ' | Cleared)));
            FieldClass = FlowField;
        }
        field(50012; "Incl. Mem. Fee"; Boolean)
        {
            Description = 'ALLETDK200313';
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
        }
        field(50102; "Forfeiture / Excess Amount"; Decimal)
        {
            Description = 'BBG1.6 311213';
        }
        field(50104; "Comm. Amt Adj. in case Forfeit"; Decimal)
        {
            Description = 'BBG1.6 311213';
        }
        field(50105; "Travel Not Generate"; Boolean)
        {
            Description = 'BBG1.4 220114';
        }
        field(50110; "Commission Hold on Full Pmt"; Boolean)
        {
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
        field(50113; "LLP Name"; Text[30])
        {
            CalcFormula = Lookup("Responsibility Center 1"."Company Name" WHERE(Code = FIELD("Shortcut Dimension 1 Code")));
            Editable = true;
            FieldClass = FlowField;
        }
        field(50114; "Team Head Id"; Code[20])
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(50115; "Filters on Team Head"; Code[20])
        {
        }
        field(50120; "Due Amount As per Plan"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG_240919';
        }
        field(50121; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG_240919';
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
            TableRelation = "App. Charge Code".Code WHERE("Sub Payment Plan" = FILTER(true));
        }
        field(50203; "Unit Plan Name"; Text[50])
        {
            Editable = false;
        }
        field(50208; "Sales Invoice booked"; Boolean)
        {
            Editable = false;
        }
        field(50212; "Sales %"; Decimal)
        {
            Editable = false;
        }
        field(50213; "InterComp Purch. Inv. Created"; Boolean)
        {
            Editable = false;
        }
        field(50214; "InterComp. Sales Inv. Created"; Boolean)
        {
            Editable = false;
        }
        field(50215; "Purchase %"; Decimal)
        {
            Editable = false;
        }
        field(50221; "Thumb Impression Form"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF UserSetup.GET(USERID) THEN
                    IF NOT "Thumb Impression Form" THEN BEGIN
                        IF NOT UserSetup."Allow Re-Send SMS" THEN
                            ERROR('Please contact Admin');
                    END ELSE BEGIN
                        IF NOT UserSetup."Thumb Impression SMS" THEN
                            ERROR('Please Contact Admin Department');
                        ComInfo.GET;
                        IF (ComInfo."Send SMS") AND ("Thumb Impression Form") THEN BEGIN
                            IF Customer.GET("Customer No.") THEN BEGIN
                                IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                    CustMobileNo := Customer."BBG Mobile No.";
                                    CustSMSText :=
                                'Dear Customer, We acknowledge the Receipt of Thumb impression form for Plot Registration. Name: Mr/Ms' +
                                Customer.Name + ', Appl No: ' + FORMAT("No.") + ' ' + ', Project: ' +
                                GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1) + ' ' + 'Date: ' + FORMAT("Posting Date") +
                                'Thank you.Team BBG.';
                                    MESSAGE('%1', CustSMSText);
                                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                    "Thumb Imp Send DateTime" := CURRENTDATETIME;
                                    "Thumb Imp Send UserID" := USERID;
                                    //ALLEDK15112022
                                    CLEAR(SMSLogDetails);
                                    SmsMessage := '';
                                    SmsMessage1 := '';
                                    SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                    SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Thumb Impression Form', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                END;
                            END;
                        END;
                    END;
            end;
        }
        field(50222; "Registration to SRO"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF UserSetup.GET(USERID) THEN
                    IF NOT "Registration to SRO" THEN BEGIN
                        IF NOT UserSetup."Allow Re-Send SMS" THEN
                            ERROR('Please contact Admin');
                    END ELSE BEGIN

                        IF NOT UserSetup."Registration to SRO SMS" THEN
                            ERROR('Please Contact Admin Department');

                        ComInfo.GET;
                        IF (ComInfo."Send SMS") AND ("Registration to SRO") THEN BEGIN
                            IF Customer.GET("Customer No.") THEN BEGIN
                                IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                    CustMobileNo := Customer."BBG Mobile No.";
                                    CustSMSText :=

                                'Dear Customer, Your Application has out for Registration @SRO office Name: Mr/Ms' +
                                Customer.Name + ', Appl No: ' + FORMAT("No.") + ' ' + ', Project: ' +
                                GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1) + ' ' + 'Date: ' + FORMAT("Posting Date") +
                                'Thank you.Team BBG.';
                                    MESSAGE('%1', CustSMSText);
                                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                    "Reg. To SRO Send DateTime" := CURRENTDATETIME;
                                    "Reg. To SRO Send UserID" := USERID;
                                    //ALLEDK15112022
                                    CLEAR(SMSLogDetails);
                                    SmsMessage := '';
                                    SmsMessage1 := '';
                                    SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                    SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Registration to SRO', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                END;
                            END;
                        END;
                    END;
            end;
        }
        field(50223; "Doc Issue from TR DESK"; Boolean)
        {
            Caption = 'SMS For CUSTOMER REGD DOC ISSUE FROM TR DESK';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF UserSetup.GET(USERID) THEN
                    IF NOT "Doc Issue from TR DESK" THEN BEGIN
                        IF NOT UserSetup."Allow Re-Send SMS" THEN
                            ERROR('Please contact Admin');
                    END ELSE BEGIN

                        IF NOT UserSetup."Doc Issue from TR DESK SMS" THEN
                            ERROR('Please Contact Admin Department');

                        ComInfo.GET;
                        IF (ComInfo."Send SMS") AND ("Doc Issue from TR DESK") THEN BEGIN
                            IF Customer.GET("Customer No.") THEN BEGIN
                                IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                    CustMobileNo := Customer."BBG Mobile No.";
                                    CustSMSText :=
                                     'Dear : Mr/Ms' + Customer.Name + 'your Registration Document has been delivered @Transaction Desk,3rd Floor,BBG Office..' +
                                        'Thanks for your Patronage with us and look forward for your future investments..Team BBG.';
                                    MESSAGE('%1', CustSMSText);
                                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                    "Doc. Issue TRDesk Datetime" := CURRENTDATETIME;
                                    "Doc. Issue TRDesk UserID" := USERID;
                                    //ALLEDK15112022
                                    CLEAR(SMSLogDetails);
                                    SmsMessage := '';
                                    SmsMessage1 := '';
                                    SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                    SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Doc Issue from TR DESK', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                END;
                            END;
                        END;
                    END;
            end;
        }
        field(50224; "Sweet Box Issue from TR DESK"; Boolean)
        {
            Caption = 'SMS For CUSTOMER SWEET BOX ISSUE FROM TR DESK';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF UserSetup.GET(USERID) THEN
                    IF NOT "Sweet Box Issue from TR DESK" THEN BEGIN
                        IF NOT UserSetup."Allow Re-Send SMS" THEN
                            ERROR('Please contact Admin');
                    END ELSE BEGIN
                        IF NOT UserSetup."Sweet Box Issuefrom TRDESk SMS" THEN
                            ERROR('Please Contact Admin Department');
                        ComInfo.GET;
                        IF (ComInfo."Send SMS") AND ("Sweet Box Issue from TR DESK") THEN BEGIN
                            IF Customer.GET("Customer No.") THEN BEGIN
                                IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                    CustMobileNo := Customer."BBg Mobile No.";
                                    CustSMSText :=
                                    'Dear : Mr/Ms' + Customer.Name + ',your Sweet Box has been issued against the Appl:' + FORMAT("No.") + ' @Transaction Desk,3rd Floor' +
                                    ',BBG Office..Thanks for your Patronage with us and look forward for your future investments..Team BBG.';

                                    MESSAGE('%1', CustSMSText);
                                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                    "SweetBox Issue Send Datetime" := CURRENTDATETIME;
                                    "SweetBox Issue Send UserID" := USERID;
                                    //ALLEDK15112022
                                    CLEAR(SMSLogDetails);
                                    SmsMessage := '';
                                    SmsMessage1 := '';
                                    SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                    SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Sweet Box Issue from TR DESK', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                END;
                            END;
                        END;
                    END;
            end;
        }
        field(50225; "Thumb Imp Send DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50226; "Reg. To SRO Send DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50227; "Doc. Issue TRDesk Datetime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50228; "SweetBox Issue Send Datetime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50229; "Thumb Imp Send UserID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50230; "Reg. To SRO Send UserID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50231; "Doc. Issue TRDesk UserID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50232; "SweetBox Issue Send UserID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50233; "Customer Mobile No."; Text[30])
        {
            CalcFormula = Lookup(Customer."BBG Mobile No." WHERE("No." = FIELD("Customer No.")));
            FieldClass = FlowField;
        }
        field(50234; "Last Receipt Date"; Date)
        {
            CalcFormula = Max("NewApplication Payment Entry"."Posting date" WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50235; "Associate Correction Narration"; Text[70])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
        field(50240; "Received Amount in LLP"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50241; "Development Company Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = Company;
        }
        field(50242; "IC Sales Order Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50243; "Allow Auto Plot Vacate"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50244; "Verita Amount Received"; Boolean)
        {
            DataClassification = ToBeClassified;
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
                v_ConfirmedOrder: Record "Confirmed Order";
            begin
                //090921
                UserSetup.RESET;
                IF UserSetup.GET(USERID) THEN
                    IF NOT UserSetup."Registration Status Modify" THEN
                        ERROR('Contact Admin');

                "Registration Initiated Date" := TODAY;


                IF "Registration Status" <> "Registration Status"::" " THEN BEGIN

                    CALCFIELDS("Total Received Amount");
                    IF Amount > "Total Received Amount" THEN
                        ERROR('Received amount should not be less than Amount');

                    v_ConfirmedOrder.RESET;
                    v_ConfirmedOrder.CHANGECOMPANY("Company Name");
                    IF v_ConfirmedOrder.GET("No.") THEN BEGIN
                        v_ConfirmedOrder."Registration Status" := "Registration Status";
                        v_ConfirmedOrder."Registration Initiated Date" := "Registration Initiated Date";
                        v_ConfirmedOrder.MODIFY;
                    END;
                END;
                //090921
            end;
        }
        field(50249; "Refund SMS Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Initiated,Verified,Approved,Submission,Rejected,Completed';
            OptionMembers = " ",Initiated,Verified,Approved,Submission,Rejected,Completed;
        }
        field(50250; "Refund Initiate Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ConfOrder.RESET;
                ConfOrder.CHANGECOMPANY("LLP Name");
                IF ConfOrder.GET("No.") THEN BEGIN
                    ConfOrder."Refund Initiate Amount" := "Refund Initiate Amount";
                    ConfOrder.MODIFY;
                END;
            end;
        }
        field(50251; "Refund Rejection Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50252; "Refund Rejection SMS Sent"; Boolean)
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
            Editable = false;
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
        field(60013; "Application Closed"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
                v_ConfirmedOrder: Record "Confirmed Order";
            begin
                UserSetup.RESET;
                IF UserSetup.GET(USERID) THEN
                    IF NOT UserSetup."Application Closed" THEN
                        ERROR('Contact Admin');

                v_ConfirmedOrder.RESET;
                v_ConfirmedOrder.CHANGECOMPANY("Company Name");
                IF v_ConfirmedOrder.GET("No.") THEN BEGIN
                    v_ConfirmedOrder."Application Closed" := "Application Closed";
                    v_ConfirmedOrder.MODIFY;
                END;
            end;
        }
        field(60014; "Sent SMS A To B"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60015; "Sent SMS B to C"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60016; "Sent SMS Auto Plot Vacate"; Boolean)
        {
            DataClassification = ToBeClassified;
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
            CalcFormula = Lookup("Unit Master".Facing WHERE("No." = FIELD("Unit Code")));
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'NA,East,West,North,South,NorthWest,SouthEast,NorthEast,SouthWest';
            OptionMembers = NA,East,West,North,South,NorthWest,SouthEast,NorthEast,SouthWest;
        }
        field(90075; "Registration Bonus Hold(BSP2)"; Boolean)
        {
            Description = 'BBG1.00 010413';
            Editable = true;

            trigger OnValidate()
            begin
                Memberof.RESET;
                Memberof.SETRANGE("User Name", USERID);
                Memberof.SETRANGE("Role ID", 'A_HOLDRB');
                IF NOT Memberof.FINDFIRST THEN
                    ERROR('You do not have permission of Role : A_HOLDRB');
                AmtComm := 0;

                "Commission Entry".RESET;
                "Commission Entry".CHANGECOMPANY("Company Name");
                "Commission Entry".SETRANGE("Commission Entry"."Application No.", "No.");
                "Commission Entry".SETRANGE("Commission Entry"."Introducer Code", "Introducer Code");
                "Commission Entry".SETRANGE("Commission Entry".Posted, TRUE);
                "Commission Entry".SETRANGE("Commission Entry"."Opening Entries", FALSE);
                "Commission Entry".SETRANGE("Commission Entry"."Direct to Associate", TRUE);
                IF "Commission Entry".FINDFIRST THEN BEGIN
                    REPEAT
                        AmtComm := AmtComm + "Commission Entry"."Commission Amount";
                    UNTIL "Commission Entry".NEXT = 0;
                    IF AmtComm > 0 THEN BEGIN
                        IF "Registration Bonus Hold(BSP2)" THEN
                            ERROR('You have already paid Registration %1', "No.");
                    END;
                END;




                IF "Registration Bonus Hold(BSP2)" = FALSE THEN BEGIN
                    "RB Release by User ID" := USERID;
                    "Date/Time of RB Release" := CURRENTDATETIME;
                END ELSE BEGIN
                    "RB Release by User ID" := '';
                    "Date/Time of RB Release" := 0DT;
                END;

                ConfOrder.RESET;
                ConfOrder.CHANGECOMPANY("Company Name");
                IF ConfOrder.GET("No.") THEN BEGIN
                    ConfOrder."Registration Bonus Hold(BSP2)" := "Registration Bonus Hold(BSP2)";
                    ConfOrder."RB Release by User ID" := "RB Release by User ID";
                    ConfOrder."Date/Time of RB Release" := "Date/Time of RB Release";
                    ConfOrder.TESTFIELD("Registration No.");
                    ConfOrder.TESTFIELD("Registration Date");
                    ConfOrder.MODIFY;
                END;
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
            CalcFormula = - Sum("Item Ledger Entry".Quantity WHERE("Application No." = FIELD("No.")));
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
                                                                      "Direct to Associate" = FILTER(false)));
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
        field(90095; "Old Project Code"; Code[20])
        {
            Editable = false;
        }
        field(90096; "JV Posting Date"; Date)
        {
            Editable = false;
        }
        field(90097; "Project change Comment"; Text[50])
        {
            Editable = false;
        }
        field(90098; "Member Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            FieldClass = FlowField;
        }
        field(90099; "Cancelled app"; Boolean)
        {
            Editable = false;
        }
        field(90110; "Send for Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90111; "Send for Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90112; "Approval Status"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90119; "Direct Incentive Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90120; "Loan File"; Boolean)     //251124 New field
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(90121; "Gold/Silver Voucher Issued"; Decimal)     //251124 New field
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50342; "Barcode"; Blob)
        {
            DataClassification = ToBeClassified;
            Caption = 'Barcode';
            SubType = Bitmap;
        }
        field(90126; "Registration No. 2"; Code[50])   //251124 Added new field
        {
            DataClassification = ToBeClassified;

        }
        field(90127; "Region Code"; Code[50])   //251124 Added new field
        {
            DataClassification = ToBeClassified;

        }
        field(90128; "Travel applicable"; Boolean)  //New field added 01072025
        {
            Editable = False;

        }
        field(90129; "Registration Bouns (BSP2)"; Boolean)  //New field added 01072025
        {
            Editable = False;

        }
        field(90060; "Customer State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;
            Editable = False;
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
        field(60044; "Aadhar No."; Code[15])  //19082025 Added new field
        {
            Caption = 'Aadhar No.';
            DataClassification = ToBeClassified;
            Editable = False;
        }
        field(60045; "New Loan File"; Option)     //251124 New field
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Yes,No;
            OptionCaption = ' ,Yes,No';
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
        key(Key4; "Introducer Code", "Posting Date")
        {
        }
        key(Key5; "Shortcut Dimension 1 Code", "Project Type", "Return Frequency", Duration, "No.", "Return Payment Mode")
        {
        }
        key(Key6; "Project Type", "Scheme Code", "Shortcut Dimension 1 Code", "Maturity Date", "No.", Status)
        {
        }
        key(Key7; "Customer No.", "Return Bank Account Code")
        {
        }
        key(Key8; "Unit Code")
        {
        }
        key(Key9; "Customer No.", "Introducer Code")
        {
        }
        key(Key10; Status, "Shortcut Dimension 2 Code", "No.")
        {
        }
        key(Key11; "Introducer Code", "Customer No.")
        {
        }
        key(Key12; "Shortcut Dimension 1 Code", "No.")
        {
        }
        key(Key13; "Introducer Code", "No.", "Posting Date")
        {
        }
        key(Key14; "Company Name", "Introducer Code", "Posting Date")
        {
        }
        key(Key15; "Unit Code", Status)
        {
        }
        key(Key16; "Posting Date")
        {
        }
        key(Key17; "Cancelled app")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ERROR('You can not delete');
        TESTFIELD("Application Closed", FALSE);
    end;

    trigger OnModify()
    begin
        IF Status = Status::Registered THEN BEGIN
            IF UserSetup.GET(USERID) THEN
                IF (UserSetup."Thumb Impression SMS") OR (UserSetup."Registration to SRO SMS") OR (UserSetup."Doc Issue from TR DESK SMS") OR
                  (UserSetup."Sweet Box Issuefrom TRDESk SMS") OR (UserSetup."Allow Re-Send SMS") THEN BEGIN
                END ELSE
                    ERROR(Text002);
        END;
    end;

    var
        SchemeHeader: Record "Document Type Initiator";
        Text001: Label 'You cannot rename a %1.';
        Text002: Label 'Order is already Registered.\Not allowed to modify or delete';
        ApplicationPaymentEntry: Record "NewApplication Payment Entry";
        TotalRcvdAmt: Decimal;
        UnitMaster: Record "Unit Master";
        ConfrimedOrder: Record "New Confirmed Order";
        Application: Record "New Application Booking";
        RecUnitMaster: Record "Unit Master";
        Job: Record Job;
        DocMaster: Record "Document Master";
        Vend: Record Vendor;
        C: Page "Company Information";
        CreditAppPayEntry: Record "Debit App. Payment Entry";
        RecUnitMaster1: Record "Unit Master";
        AmtComm: Decimal;
        AppPaymentEntry: Record "NewApplication Payment Entry";
        "Commission Entry": Record "Commission Entry";
        CompanyWise: Record "Company wise G/L Account";
        ConfOrder: Record "Confirmed Order";
        Memberof: Record "Access Control";
        UserSetup: Record "User Setup";
        ComInfo: Record "Company Information";
        Customer: Record Customer;
        CustMobileNo: Text;
        CustSMSText: Text;
        GetDescription: Codeunit GetDescription;
        PostPayment: Codeunit PostPayment;
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];


    procedure TotalApplicationAmount(): Decimal
    begin
    end;


    procedure AmountRecdAppl(ApplicationNo: Code[20]): Decimal
    var
        RecdAmount: Decimal;
        Bond: Record "New Confirmed Order";
    begin
    end;


    procedure CheckPaymentAmt(): Decimal
    var
        ApplPayEntry: Record "NewApplication Payment Entry";
        PayAmount: Decimal;
    begin
    end;

    local procedure "--------Approval Functions"()
    begin
    end;


    procedure CheckApprovalReceiptStatus(NewAppEntries: Record "NewApplication Payment Entry")
    var
        RequesttoApproveDocuments: Record "Request to Approve Documents";
    begin
        RequesttoApproveDocuments.RESET;
        RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::Receipt);
        RequesttoApproveDocuments.SETRANGE("Document No.", NewAppEntries."Document No.");
        RequesttoApproveDocuments.SETRANGE("Document Line No.", NewAppEntries."Line No.");
        IF NOT RequesttoApproveDocuments.FINDFIRST THEN BEGIN
            ERROR('Approval Pending');
        END ELSE BEGIN
            RequesttoApproveDocuments.SETRANGE(Status, RequesttoApproveDocuments.Status::" ");
            IF RequesttoApproveDocuments.FINDFIRST THEN
                ERROR('Approval Pending');
        END;
    end;


    procedure CheckApprovalMembertoMemberStatus(NewAppEntries: Record "NewApplication Payment Entry")
    var
        RequesttoApproveDocuments: Record "Request to Approve Documents";
    begin


        RequesttoApproveDocuments.RESET;
        RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Member to Member Transfer");
        RequesttoApproveDocuments.SETRANGE("Document No.", NewAppEntries."Document No.");
        RequesttoApproveDocuments.SETRANGE("Document Line No.", NewAppEntries."Line No.");
        IF NOT RequesttoApproveDocuments.FINDFIRST THEN BEGIN
            ERROR('Approval Pending');
        END ELSE BEGIN
            RequesttoApproveDocuments.SETRANGE(Status, RequesttoApproveDocuments.Status::" ");
            IF RequesttoApproveDocuments.FINDFIRST THEN
                ERROR('Approval Pending');
        END;
    end;

    // procedure BarcodeConverter(GlobalBarcodeString: Text): Text
    // var
    //     BarcodeString: Text;
    //     BarcodeSymbology: Enum "Barcode Symbology";
    //     BarcodeFontProvider: Interface "Barcode Font Provider";
    //     EncodedText: Text;
    // Begin
    //     BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
    //     BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
    //     BarcodeString := GlobalBarcodeString;
    //     BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
    //     EncodedText := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    //     exit(EncodedText);
    // End;
}

