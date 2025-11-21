table 60720 "Customers Lead_2"
{
    Caption = 'Contact';
    DataCaptionFields = "No.", Name;
    DrillDownPageID = "Contact List";
    LookupPageID = "Contact List";
    Permissions = TableData "Sales Header" = rm,
                  TableData "Contact Alt. Address" = rd,
                  TableData "Contact Alt. Addr. Date Range" = rd,
                  TableData "Contact Business Relation" = rd,
                  TableData "Contact Mailing Group" = rd,
                  TableData "Contact Industry Group" = rd,
                  TableData "Contact Web Source" = rd,
                  TableData "Rlshp. Mgt. Comment Line" = rd,
                  TableData "Interaction Log Entry" = rm,
                  TableData "Contact Job Responsibility" = rd,
                  TableData "To-do" = rm,
                  TableData "Contact Profile Answer" = rd,
                  TableData Opportunity = rm,
                  TableData "Opportunity Entry" = rm;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    RMSetup.GET;
                    NoSeriesMgt.TestManual(RMSetup."Contact Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(7; City; Text[30])
        {
            Caption = 'City';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(10; "Telex No."; Text[20])
        {
            Caption = 'Telex No.';
        }
        field(15; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(22; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(24; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(29; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(38; Comment; Boolean)
        {
            CalcFormula = Exist("Rlshp. Mgt. Comment Line" WHERE("Table Name" = CONST(Contact),
                                                                  "No." = FIELD("No."),
                                                                  "Sub No." = CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(84; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(85; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(86; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
                VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
            begin
            end;
        }
        field(89; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(92; County; Text[30])
        {
            Caption = 'County';
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                IF ("Search E-Mail" = UPPERCASE(xRec."E-Mail")) OR ("Search E-Mail" = '') THEN
                    "Search E-Mail" := "E-Mail";
            end;
        }
        field(103; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(150; "Privacy Blocked"; Boolean)
        {
            Caption = 'Privacy Blocked';

            trigger OnValidate()
            begin
                IF NOT "Privacy Blocked" THEN
                    IF Minor THEN
                        IF NOT "Parental Consent Received" THEN
                            ERROR(ParentalConsentReceivedErr, "No.");
            end;
        }
        field(151; Minor; Boolean)
        {
            Caption = 'Minor';

            trigger OnValidate()
            begin
                IF Minor THEN
                    VALIDATE("Privacy Blocked", TRUE);
            end;
        }
        field(152; "Parental Consent Received"; Boolean)
        {
            Caption = 'Parental Consent Received';

            trigger OnValidate()
            begin
                VALIDATE("Privacy Blocked", TRUE);
            end;
        }
        field(5050; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Company,Person';
            OptionMembers = Company,Person;

            trigger OnValidate()
            begin
                IF (CurrFieldNo <> 0) AND ("No." <> '') THEN BEGIN
                    TypeChange;
                    MODIFY;
                END;
            end;
        }
        field(5051; "Company No."; Code[20])
        {
            Caption = 'Company No.';
            TableRelation = Contact WHERE(Type = CONST(Company));

            trigger OnValidate()
            var
                Opp: Record Opportunity;
                OppEntry: Record "Opportunity Entry";
                Todo: Record "To-do";
                InteractLogEntry: Record "Interaction Log Entry";
                SegLine: Record "Segment Line";
                SalesHeader: Record "Sales Header";
                OriginalEmail: Text[80];
            begin
            end;
        }
        field(5052; "Company Name"; Text[50])
        {
            Caption = 'Company Name';
            Editable = false;
        }
        field(5053; "Lookup Contact No."; Code[20])
        {
            Caption = 'Lookup Contact No.';
            Editable = false;
            TableRelation = Contact;
        }
        field(5054; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(5055; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
        }
        field(5056; Surname; Text[30])
        {
            Caption = 'Surname';
        }
        field(5058; "Job Title"; Text[30])
        {
            Caption = 'Job Title';
        }
        field(5059; Initials; Text[30])
        {
            Caption = 'Initials';
        }
        field(5060; "Extension No."; Text[30])
        {
            Caption = 'Extension No.';
        }
        field(5061; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(5062; Pager; Text[30])
        {
            Caption = 'Pager';
        }
        field(5063; "Organizational Level Code"; Code[10])
        {
            Caption = 'Organizational Level Code';
            TableRelation = "Organizational Level";
        }
        field(5064; "Exclude from Segment"; Boolean)
        {
            Caption = 'Exclude from Segment';
        }
        field(5065; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5066; "Next To-do Date"; Date)
        {
            CalcFormula = Min("To-do".Date WHERE("Contact Company No." = FIELD("Company No."),
                                                "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                Closed = CONST(false),
                                                "System To-do Type" = CONST("Contact Attendee")));
            Caption = 'Next To-do Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5067; "Last Date Attempted"; Date)
        {
            CalcFormula = Max("Interaction Log Entry".Date WHERE("Contact Company No." = FIELD("Company No."),
                                                                  "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                                  "Initiated By" = CONST(Us),
                                                                  Postponed = CONST(false)));
            Caption = 'Last Date Attempted';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5068; "Date of Last Interaction"; Date)
        {
            CalcFormula = Max("Interaction Log Entry".Date WHERE("Contact Company No." = FIELD("Company No."),
                                                                  "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                                  "Attempt Failed" = CONST(false),
                                                                  Postponed = CONST(false)));
            Caption = 'Date of Last Interaction';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5069; "No. of Job Responsibilities"; Integer)
        {
            CalcFormula = Count("Contact Job Responsibility" WHERE("Contact No." = FIELD("No.")));
            Caption = 'No. of Job Responsibilities';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5070; "No. of Industry Groups"; Integer)
        {
            CalcFormula = Count("Contact Industry Group" WHERE("Contact No." = FIELD("Company No.")));
            Caption = 'No. of Industry Groups';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5071; "No. of Business Relations"; Integer)
        {
            CalcFormula = Count("Contact Business Relation" WHERE("Contact No." = FIELD("Company No.")));
            Caption = 'No. of Business Relations';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5072; "No. of Mailing Groups"; Integer)
        {
            CalcFormula = Count("Contact Mailing Group" WHERE("Contact No." = FIELD("No.")));
            Caption = 'No. of Mailing Groups';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5073; "External ID"; Code[20])
        {
            Caption = 'External ID';
        }
        field(5074; "No. of Interactions"; Integer)
        {
            CalcFormula = Count("Interaction Log Entry" WHERE("Contact Company No." = FIELD(FILTER("Company No.")),
                                                               Canceled = CONST(false),
                                                               "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                               Date = FIELD("Date Filter"),
                                                               Postponed = CONST(false)));
            Caption = 'No. of Interactions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5076; "Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Interaction Log Entry"."Cost (LCY)" WHERE("Contact Company No." = FIELD("Company No."),
                                                                          Canceled = CONST(false),
                                                                          "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                                          Date = FIELD("Date Filter"),
                                                                          Postponed = CONST(false)));
            Caption = 'Cost (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5077; "Duration (Min.)"; Decimal)
        {
            CalcFormula = Sum("Interaction Log Entry"."Duration (Min.)" WHERE("Contact Company No." = FIELD("Company No."),
                                                                               Canceled = CONST(false),
                                                                               "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                                               Date = FIELD("Date Filter"),
                                                                               Postponed = CONST(false)));
            Caption = 'Duration (Min.)';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5078; "No. of Opportunities"; Integer)
        {
            CalcFormula = Count("Opportunity Entry" WHERE(Active = CONST(true),
                                                           "Contact Company No." = FIELD("Company No."),
                                                           "Estimated Close Date" = FIELD("Date Filter"),
                                                           "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                           "Action Taken" = FIELD("Action Taken Filter")));
            Caption = 'No. of Opportunities';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5079; "Estimated Value (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Opportunity Entry"."Estimated Value (LCY)" WHERE(Active = CONST(true),
                                                                                 "Contact Company No." = FIELD("Company No."),
                                                                                 "Estimated Close Date" = FIELD("Date Filter"),
                                                                                 "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                                                 "Action Taken" = FIELD("Action Taken Filter")));
            Caption = 'Estimated Value (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5080; "Calcd. Current Value (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Opportunity Entry"."Calcd. Current Value (LCY)" WHERE(Active = CONST(true),
                                                                                      "Contact Company No." = FIELD("Company No."),
                                                                                      "Estimated Close Date" = FIELD("Date Filter"),
                                                                                      "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                                                      "Action Taken" = FIELD("Action Taken Filter")));
            Caption = 'Calcd. Current Value (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5082; "Opportunity Entry Exists"; Boolean)
        {
            CalcFormula = Exist("Opportunity Entry" WHERE(Active = CONST(true),
                                                           "Contact Company No." = FIELD("Company No."),
                                                           "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                           "Sales Cycle Code" = FIELD("Sales Cycle Filter"),
                                                           "Sales Cycle Stage" = FIELD("Sales Cycle Stage Filter"),
                                                           "Salesperson Code" = FIELD("Salesperson Filter"),
                                                           "Campaign No." = FIELD("Campaign Filter"),
                                                           "Action Taken" = FIELD("Action Taken Filter"),
                                                           "Estimated Value (LCY)" = FIELD("Estimated Value Filter"),
                                                           "Calcd. Current Value (LCY)" = FIELD("Calcd. Current Value Filter"),
                                                           "Completed %" = FIELD("Completed % Filter"),
                                                           "Chances of Success %" = FIELD("Chances of Success % Filter"),
                                                           "Probability %" = FIELD("Probability % Filter"),
                                                           "Estimated Close Date" = FIELD("Date Filter"),
                                                           "Close Opportunity Code" = FIELD("Close Opportunity Filter")));
            Caption = 'Opportunity Entry Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5083; "To-do Entry Exists"; Boolean)
        {
            CalcFormula = Exist("To-do" WHERE("Contact Company No." = FIELD("Company No."),
                                             "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                             "Team Code" = FIELD("Team Filter"),
                                             "Salesperson Code" = FIELD("Salesperson Filter"),
                                             "Campaign No." = FIELD("Campaign Filter"),
                                             Date = FIELD("Date Filter"),
                                             Status = FIELD("To-do Status Filter"),
                                             Priority = FIELD("Priority Filter"),
                                             Closed = FIELD("To-do Closed Filter")));
            Caption = 'To-do Entry Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5084; "Salesperson Filter"; Code[20])
        {
            Caption = 'Salesperson Filter';
            FieldClass = FlowFilter;
            TableRelation = "Salesperson/Purchaser";
        }
        field(5085; "Campaign Filter"; Code[20])
        {
            Caption = 'Campaign Filter';
            FieldClass = FlowFilter;
            TableRelation = Campaign;
        }
        field(5087; "Action Taken Filter"; Option)
        {
            Caption = 'Action Taken Filter';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Next,Previous,Updated,Jumped,Won,Lost';
            OptionMembers = " ",Next,Previous,Updated,Jumped,Won,Lost;
        }
        field(5088; "Sales Cycle Filter"; Code[10])
        {
            Caption = 'Sales Cycle Filter';
            FieldClass = FlowFilter;
            TableRelation = "Sales Cycle";
        }
        field(5089; "Sales Cycle Stage Filter"; Integer)
        {
            Caption = 'Sales Cycle Stage Filter';
            FieldClass = FlowFilter;
            TableRelation = "Sales Cycle Stage".Stage WHERE("Sales Cycle Code" = FIELD("Sales Cycle Filter"));
        }
        field(5090; "Probability % Filter"; Decimal)
        {
            Caption = 'Probability % Filter';
            DecimalPlaces = 1 : 1;
            FieldClass = FlowFilter;
            MaxValue = 100;
            MinValue = 0;
        }
        field(5091; "Completed % Filter"; Decimal)
        {
            Caption = 'Completed % Filter';
            DecimalPlaces = 1 : 1;
            FieldClass = FlowFilter;
            MaxValue = 100;
            MinValue = 0;
        }
        field(5092; "Estimated Value Filter"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Estimated Value Filter';
            FieldClass = FlowFilter;
        }
        field(5093; "Calcd. Current Value Filter"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Calcd. Current Value Filter';
            FieldClass = FlowFilter;
        }
        field(5094; "Chances of Success % Filter"; Decimal)
        {
            Caption = 'Chances of Success % Filter';
            DecimalPlaces = 0 : 0;
            FieldClass = FlowFilter;
            MaxValue = 100;
            MinValue = 0;
        }
        field(5095; "To-do Status Filter"; Option)
        {
            Caption = 'To-do Status Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Not Started,In Progress,Completed,Waiting,Postponed';
            OptionMembers = "Not Started","In Progress",Completed,Waiting,Postponed;
        }
        field(5096; "To-do Closed Filter"; Boolean)
        {
            Caption = 'To-do Closed Filter';
            FieldClass = FlowFilter;
        }
        field(5097; "Priority Filter"; Option)
        {
            Caption = 'Priority Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Low,Normal,High';
            OptionMembers = Low,Normal,High;
        }
        field(5098; "Team Filter"; Code[10])
        {
            Caption = 'Team Filter';
            FieldClass = FlowFilter;
            TableRelation = Team;
        }
        field(5099; "Close Opportunity Filter"; Code[10])
        {
            Caption = 'Close Opportunity Filter';
            FieldClass = FlowFilter;
            TableRelation = "Close Opportunity Code";
        }
        field(5100; "Correspondence Type"; Option)
        {
            Caption = 'Correspondence Type';
            OptionCaption = ' ,Hard Copy,E-Mail,Fax';
            OptionMembers = " ","Hard Copy","E-Mail",Fax;
        }
        field(5101; "Salutation Code"; Code[10])
        {
            Caption = 'Salutation Code';
            TableRelation = Salutation;
        }
        field(5102; "Search E-Mail"; Code[80])
        {
            Caption = 'Search E-Mail';
        }
        field(5104; "Last Time Modified"; Time)
        {
            Caption = 'Last Time Modified';
        }
        field(5105; "E-Mail 2"; Text[80])
        {
            Caption = 'E-Mail 2';
            ExtendedDatatype = EMail;
        }
        field(50001; "CRM ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(50002; "CRM Name"; Text[50])
        {
            CalcFormula = Lookup(Employee."First Name" WHERE("No." = FIELD("CRM ID")));
            FieldClass = FlowField;
        }
        field(50003; "Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50004; "Associate Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Associate ID")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; Gender; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Male,Female,Other';
            OptionMembers = " ",Male,Female,Other;
        }
        field(50006; "Parent Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; Occupation; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Salaried,Government Job,Business';
            OptionMembers = " ",Salaried,"Government Job",Business;
        }
        field(50008; "Income Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Upto 2 lac,2 lac  - 5 lac,5 lacs - 15 lacs,16 lacs - 40 lacs,50 lacs - 1cr,1.5cr - 7cr,7 cr - 100 cr,Above 100cr';
            OptionMembers = " ","Upto 2 lac","2 lac  - 5 lac","5 lacs - 15 lacs","16 lacs - 40 lacs","50 lacs - 1cr","1.5cr - 7cr","7 cr - 100 cr","Above 100cr";
        }
        field(50009; "Mode Of Approach"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Ads,Friends,Referral,Self';
            OptionMembers = " ",Ads,Friends,Referral,Self;
        }
        field(50010; "Customer Vehicle"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Car,Bike,None Of These';
            OptionMembers = " ",Car,Bike,"None Of These";
        }
        field(50011; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Close,Pending,Approved,Rejected';
            OptionMembers = Open,Close,Pending,Approved,Rejected;
        }
        field(50012; "Lead Type"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Hot,Cold,Failed';
            OptionMembers = " ",Hot,Cold,Failed;
        }
        field(50013; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; DOB; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; Relation; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Land Mark"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "State Code"; Code[5])
        {
            DataClassification = ToBeClassified;
        }
        field(50021; "Request From"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '//Added new option Channel Partner';
            Editable = false;
            OptionCaption = ' ,Vendor,Customer,Channel Partner';
            OptionMembers = " ",Vendor,Customer,"Channel Partner";
        }
        field(50022; "Aadhaar Number"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50023; "Pan Number"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50024; Verified; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50025; "Aadhaar URL"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50026; "PAN URL"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50027; ProfileURL; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50028; Remarks; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "Re-Open Comment"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "Parent ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50031; "Region Code"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50032; Rank_Code; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50033; Designation; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50034; "Customer Campiagn Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '171023';
            Editable = false;
        }
        field(50035; "Reporting Office ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50036; "Reporting Office Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50037; "Lead Associate / Customer Id"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50039; "Lead Associate / Customer Name"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50040; "Cluster Code"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50041; "Cluster Description"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90116; "Communication Address"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90117; "Communication Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90118; "CP Designation"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            OptionCaption = ' ,Firm,Platinum,Gold,Silver';
            OptionMembers = " ",Firm,Platinum,Gold,Silver;
        }
        field(90124; "Membership of association"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            OptionCaption = ' ,CREDAI,TREDA,RERA,Other';
            OptionMembers = " ",CREDAI,TREDA,RERA,Other;
        }
        field(90125; "Membership Number"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90126; "Registration No"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90127; "Expiry date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90128; "ESI NO"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90129; "PF No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90130; "Communication City"; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(90131; "Communication State Code"; Code[10])
        {
            Caption = 'State Code';
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            TableRelation = State;
        }
        field(90132; "Communication Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                v_PostCode: Record "Post Code";
            begin
            end;
        }
        field(90133; "GST Registration No."; Code[15])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90134; "Bank Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90135; "Bank Address"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90136; "Bank Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90137; "Benificiary Name as per Bank"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90138; "IFSC Code"; Code[20])
        {
            Caption = 'SWIFT Code';
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90139; "MICR Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90140; "Account Type"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90152; "Entity Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            OptionCaption = ' ,individual,sales propritorship,partenership firm,LLP,public limited,private Limited,other any';
            OptionMembers = " ",individual,"sales propritorship","partenership firm",LLP,"public limited","private Limited","other any";
        }
        field(90153; "CP Team Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            TableRelation = "CP Team Master"."Team Code";
        }
        field(90154; "CP Leader Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            TableRelation = "CP Leader Master"."Leader Code";
        }
        field(90155; "Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90156; "Firm Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50318; "Region/Districts Code"; Code[50])   //260325 New field added
        {
            Caption = 'Region/Districts Code';
            DataClassification = ToBeClassified;
            Editable = False;
        }
        field(60040; "District Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'District Code';
            DataClassification = ToBeClassified;
            TableRelation = "District Details".Code where("State Code" = field("State Code"));
            Editable = false;
        }
        field(60041; "Mandal Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Mandal Code';
            DataClassification = ToBeClassified;
            TableRelation = "Mandal Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"));
            Editable = false;
        }
        field(60042; "Village Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Village Code';
            DataClassification = ToBeClassified;
            TableRelation = "Village Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"), "Mandal Code" = field("Mandal Code"));
            Editable = false;
        }

        field(60043; "New Region Code"; Code[10])           //06102025 Added new field
        {
            Caption = 'New Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Rank Code Master".Code;
        }

    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; "Company Name", "Company No.", Type, Name)
        {
        }
        key(Key4; "Company No.")
        {
        }
        key(Key5; "Territory Code")
        {
        }
        key(Key6; "Salesperson Code")
        {
        }
        key(Key7; "VAT Registration No.")
        {
        }
        key(Key8; "Search E-Mail")
        {
        }
        key(Key9; Name)
        {
        }
        key(Key10; City)
        {
        }
        key(Key11; "Post Code")
        {
        }
        key(Key12; "Phone No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, Type, City, "Post Code", "Phone No.")
        {
        }
    }

    trigger OnDelete()
    var
        Todo: Record "To-do";
        SegLine: Record "Segment Line";
        ContIndustGrp: Record "Contact Industry Group";
        ContactWebSource: Record "Contact Web Source";
        ContJobResp: Record "Contact Job Responsibility";
        ContMailingGrp: Record "Contact Mailing Group";
        ContProfileAnswer: Record "Contact Profile Answer";
        RMCommentLine: Record "Rlshp. Mgt. Comment Line";
        ContAltAddr: Record "Contact Alt. Address";
        ContAltAddrDateRange: Record "Contact Alt. Addr. Date Range";
        InteractLogEntry: Record "Interaction Log Entry";
        Opp: Record Opportunity;
        //DOPaymentCreditCard: Record 827;
        CompanyInformation: Record "Company Information";
        CampaignTargetGrMgt: Codeunit "Campaign Target Group Mgt";
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
    begin
        TESTFIELD(Status, Status::Open);
    end;

    trigger OnInsert()
    begin
        RMSetup.GET;

        IF "No." = '' THEN BEGIN
            RMSetup.TESTFIELD("Contact Nos.");
            NoSeriesMgt.InitSeries(RMSetup."Contact Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        IF NOT SkipDefaults THEN BEGIN
            IF "Salesperson Code" = '' THEN
                "Salesperson Code" := RMSetup."Default Salesperson Code";
            IF "Territory Code" = '' THEN
                "Territory Code" := RMSetup."Default Territory Code";
            IF "Country/Region Code" = '' THEN
                "Country/Region Code" := RMSetup."Default Country/Region Code";
            IF "Language Code" = '' THEN
                "Language Code" := RMSetup."Default Language Code";
            IF "Correspondence Type" = "Correspondence Type"::" " THEN
                "Correspondence Type" := RMSetup."Default Correspondence Type";
            IF "Salutation Code" = '' THEN
                IF Type = Type::Company THEN
                    "Salutation Code" := RMSetup."Def. Company Salutation Code"
                ELSE
                    "Salutation Code" := RMSetup."Default Person Salutation Code";
        END;

        TypeChange;

        "Last Date Modified" := TODAY;
        "Last Time Modified" := TIME;
        "Document Date" := TODAY;
    end;

    trigger OnRename()
    begin
        VALIDATE("Lookup Contact No.");
    end;

    var
        Text000: Label 'You cannot delete the %2 record of the %1 because there are one or more to-dos open.';
        Text001: Label 'You cannot delete the %2 record of the %1 because the contact is assigned one or more unlogged segments.';
        Text002: Label 'You cannot delete the %2 record of the %1 because one or more opportunities are in not started or progress.';
        Text003: Label '%1 cannot be changed because one or more interaction log entries are linked to the contact.';
        Text005: Label '%1 cannot be changed because one or more to-dos are linked to the contact.';
        Text006: Label '%1 cannot be changed because one or more opportunities are linked to the contact.';
        Text007: Label '%1 cannot be changed because there are one or more related people linked to the contact.';
        Text009: Label 'The %2 record of the %1 has been created.';
        Text010: Label 'The %2 record of the %1 is not linked with any other table.';
        RMSetup: Record "Marketing Setup";
        Salesperson: Record "Salesperson/Purchaser";
        Cont: Record "Customers Lead_2";
        ContBusRel: Record "Contact Business Relation";
        PostCode: Record "Post Code";
        DuplMgt: Codeunit DuplicateManagement;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UpdateCustVendBank: Codeunit "CustVendBank-Update";
        CampaignMgt: Codeunit "Campaign Target Group Mgt";
        ContChanged: Boolean;
        SkipDefaults: Boolean;
        Text012: Label 'You cannot change %1 because one or more unlogged segments are assigned to the contact.';
        Text019: Label 'The %2 record of the %1 already has the %3 with %4 %5.';
        Text020: Label 'Do you want to create a contact %1 %2 as a customer using a customer template?';
        Text021: Label 'You have to set up formal and informal salutation formulas in %1  language for the %2 contact.';
        HideValidationDialog: Boolean;
        Text022: Label 'The creation of the customer has been aborted.';
        Text029: Label 'The total length of first name, middle name and surname is %1 character(s)longer than the maximum length allowed for the Name field.';
        Text032: Label 'The length of %1 is %2 character(s)longer than the maximum length allowed for the %1 field.';
        Text033: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        PrivacyBlockedPostErr: Label 'You cannot post this type of document because contact %1 is blocked due to privacy.', Comment = '%1=contact no.';
        PrivacyBlockedCreateErr: Label 'You cannot create this type of document because contact %1 is blocked due to privacy.', Comment = '%1=contact no.';
        PrivacyBlockedGenericErr: Label 'You cannot use contact %1 because they are marked as blocked due to privacy.', Comment = '%1=contact no.';
        ParentalConsentReceivedErr: Label 'Privacy Blocked cannot be cleared until Parental Consent Received is set to true for minor contact %1.', Comment = '%1=contact no.';
        ProfileForMinorErr: Label 'You cannot use profiles for contacts marked as Minor.';


    procedure OnModify(xRec: Record Contact)
    var
        OldCont: Record Contact;
    begin
        "Last Date Modified" := TODAY;
        "Last Time Modified" := TIME;
    end;


    procedure TypeChange()
    var
        InteractLogEntry: Record "Interaction Log Entry";
        Opp: Record Opportunity;
        Todo: Record "To-do";
        CampaignTargetGrMgt: Codeunit "Campaign Target Group Mgt";
    begin
    end;


    procedure AssistEdit(OldCont: Record "Customers Lead_2"): Boolean
    begin
        Cont := Rec;
        RMSetup.GET;
        RMSetup.TESTFIELD("Contact Nos.");
        IF NoSeriesMgt.SelectSeries(RMSetup."Contact Nos.", OldCont."No. Series", Cont."No. Series") THEN BEGIN
            RMSetup.GET;
            RMSetup.TESTFIELD("Contact Nos.");
            NoSeriesMgt.SetSeries(Cont."No.");
            Rec := Cont;
            EXIT(TRUE);
        END;
    end;


    procedure CreateCustomer(CustomerTemplate: Code[10])
    var
        Cust: Record Customer;
        ContComp: Record "Customers Lead_2";
        CustTemplate: Record "Customer Templ.";
        DefaultDim: Record "Default Dimension";
        DefaultDim2: Record "Default Dimension";
    begin
        TESTFIELD("Company No.");
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Customers");

        ContBusRel.RESET;
        ContBusRel.SETRANGE("Contact No.", "No.");
        ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
        IF ContBusRel.FINDFIRST THEN
            ERROR(
              Text019,
              TABLECAPTION, "No.", ContBusRel.TABLECAPTION, ContBusRel."Link to Table", ContBusRel."No.");

        IF CustomerTemplate <> '' THEN
            //CustTemplate.GET(CustomerTemplate);

        CLEAR(Cust);
        Cust.SetInsertFromContact(TRUE);
        Cust.INSERT(TRUE);
        Cust.SetInsertFromContact(FALSE);

        IF Type = Type::Company THEN
            ContComp := Rec
        ELSE
            ContComp.GET("Company No.");

        ContBusRel."Contact No." := ContComp."No.";
        ContBusRel."Business Relation Code" := RMSetup."Bus. Rel. Code for Customers";
        ContBusRel."Link to Table" := ContBusRel."Link to Table"::Customer;
        ContBusRel."No." := Cust."No.";
        ContBusRel.INSERT(TRUE);

        //UpdateCustVendBank.UpdateCustomer(ContComp,ContBusRel);

        Cust.GET(ContBusRel."No.");
        Cust.VALIDATE(Name, "Company Name");
        Cust.MODIFY;
        //Need to check the code in UAT

        IF CustTemplate.Code <> '' THEN BEGIN
            IF "Territory Code" = '' THEN
                Cust."Territory Code" := CustTemplate."Territory Code"
            ELSE
                Cust."Territory Code" := "Territory Code";
            IF "Currency Code" = '' THEN
                Cust."Currency Code" := CustTemplate."Currency Code"
            ELSE
                Cust."Currency Code" := "Currency Code";
            IF "Country/Region Code" = '' THEN
                Cust."Country/Region Code" := CustTemplate."Country/Region Code"
            ELSE
                Cust."Country/Region Code" := "Country/Region Code";
            Cust."Customer Posting Group" := CustTemplate."Customer Posting Group";
            Cust."Customer Price Group" := CustTemplate."Customer Price Group";
            IF CustTemplate."Invoice Disc. Code" <> '' THEN
                Cust."Invoice Disc. Code" := CustTemplate."Invoice Disc. Code";
            Cust."Customer Disc. Group" := CustTemplate."Customer Disc. Group";
            Cust."Allow Line Disc." := CustTemplate."Allow Line Disc.";
            Cust."Gen. Bus. Posting Group" := CustTemplate."Gen. Bus. Posting Group";
            Cust."VAT Bus. Posting Group" := CustTemplate."VAT Bus. Posting Group";
            Cust."Payment Terms Code" := CustTemplate."Payment Terms Code";
            Cust."Payment Method Code" := CustTemplate."Payment Method Code";
            Cust."Shipment Method Code" := CustTemplate."Shipment Method Code";
            Cust.MODIFY;

            DefaultDim.SETRANGE("Table ID", DATABASE::"Customer Templ.");
            DefaultDim.SETRANGE("No.", CustTemplate.Code);
            IF DefaultDim.FIND('-') THEN
                REPEAT
                    CLEAR(DefaultDim2);
                    DefaultDim2.INIT;
                    DefaultDim2.VALIDATE("Table ID", DATABASE::Customer);
                    DefaultDim2."No." := Cust."No.";
                    DefaultDim2.VALIDATE("Dimension Code", DefaultDim."Dimension Code");
                    DefaultDim2.VALIDATE("Dimension Value Code", DefaultDim."Dimension Value Code");
                    DefaultDim2."Value Posting" := DefaultDim."Value Posting";
                    DefaultDim2.INSERT(TRUE);
                UNTIL DefaultDim.NEXT = 0;
        END;
        //Need to check the code in UAT

        //CampaignMgt.ConverttoCustomer(Rec,Cust);
        MESSAGE(Text009, Cust.TABLECAPTION, Cust."No.");
    end;


    procedure CreateVendor()
    var
        Vend: Record Vendor;
        ContComp: Record "Customers Lead_2";
    begin
        TESTFIELD("Company No.");
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Vendors");

        CLEAR(Vend);
        Vend.SetInsertFromContact(TRUE);
        Vend.INSERT(TRUE);
        Vend.SetInsertFromContact(FALSE);

        IF Type = Type::Company THEN
            ContComp := Rec
        ELSE
            ContComp.GET("Company No.");

        ContBusRel."Contact No." := ContComp."No.";
        ContBusRel."Business Relation Code" := RMSetup."Bus. Rel. Code for Vendors";
        ContBusRel."Link to Table" := ContBusRel."Link to Table"::Vendor;
        ContBusRel."No." := Vend."No.";
        ContBusRel.INSERT(TRUE);

        //UpdateCustVendBank.UpdateVendor(ContComp,ContBusRel);

        MESSAGE(Text009, Vend.TABLECAPTION, Vend."No.");
    end;


    procedure CreateBankAccount()
    var
        BankAcc: Record "Bank Account";
        ContComp: Record "Customers Lead_2";
    begin
        TESTFIELD("Company No.");
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Bank Accs.");

        CLEAR(BankAcc);
        BankAcc.SetInsertFromContact(TRUE);
        BankAcc.INSERT(TRUE);
        BankAcc.SetInsertFromContact(FALSE);

        IF Type = Type::Company THEN
            ContComp := Rec
        ELSE
            ContComp.GET("Company No.");

        ContBusRel."Contact No." := ContComp."No.";
        ContBusRel."Business Relation Code" := RMSetup."Bus. Rel. Code for Bank Accs.";
        ContBusRel."Link to Table" := ContBusRel."Link to Table"::"Bank Account";
        ContBusRel."No." := BankAcc."No.";
        ContBusRel.INSERT(TRUE);


        //UpdateCustVendBank.UpdateBankAccount(ContComp,ContBusRel);

        MESSAGE(Text009, BankAcc.TABLECAPTION, BankAcc."No.");
    end;


    procedure ArchiveDuplicateLeadwithMobileNo(P_CustomersLead_2: Record "Customers Lead_2")
    var
        ArchiveCustomersLead_2: Record "Archive Customers Lead_2";
        OldCustomersLead_2: Record "Customers Lead_2";
        DeleteCustomersLead_2: Record "Customers Lead_2";
    begin
        OldCustomersLead_2.RESET;
        OldCustomersLead_2.SETCURRENTKEY("Mobile Phone No.");
        OldCustomersLead_2.SETRANGE("Mobile Phone No.", P_CustomersLead_2."Mobile Phone No.");
        OldCustomersLead_2.SETRANGE(Status, OldCustomersLead_2.Status::Pending);
        OldCustomersLead_2.SETFILTER("No.", '<>%1', P_CustomersLead_2."No.");
        IF OldCustomersLead_2.FINDSET THEN
            REPEAT
                ArchiveCustomersLead_2.INIT;
                ArchiveCustomersLead_2.TRANSFERFIELDS(OldCustomersLead_2);
                ArchiveCustomersLead_2.INSERT;
            UNTIL OldCustomersLead_2.NEXT = 0;

        DeleteCustomersLead_2.RESET;
        DeleteCustomersLead_2.SETCURRENTKEY("Mobile Phone No.");
        DeleteCustomersLead_2.SETRANGE("Mobile Phone No.", P_CustomersLead_2."Mobile Phone No.");
        DeleteCustomersLead_2.SETRANGE(Status, DeleteCustomersLead_2.Status::Pending);
        DeleteCustomersLead_2.SETFILTER("No.", '<>%1', P_CustomersLead_2."No.");
        IF DeleteCustomersLead_2.FINDSET THEN
            REPEAT
                DeleteCustomersLead_2.DELETE;
            UNTIL DeleteCustomersLead_2.NEXT = 0;
    end;
}

