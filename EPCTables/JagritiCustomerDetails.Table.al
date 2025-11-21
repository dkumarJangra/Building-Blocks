table 60702 "Jagriti Customer Details"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Request No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Requester ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Associate Mobile No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "P.A.N. No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Month; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Associate Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Customer Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Customer Mobile No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Customer Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Selection Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Plot No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Plot Extent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Date of Join"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Last Date of Payment"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "No. of Gold Coins"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Request Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,GOLD / SILVER,CHANGE OF PAYMENT OPTION,RE-ALLOT / CHANGE OF PLOT,FUND TRANSFER,PLOT CANCELLATION / REFUND,CUSTOMER CORRECTIONS / RECTIFICATIONS,PLOT REGISTRATION,SITE DEVELOPMENT,,,,,,,OTHER,LINK DOCUMENTS REQUEST';
            OptionMembers = " ","GOLD / SILVER","CHANGE OF PAYMENT OPTION","RE-ALLOT / CHANGE OF PLOT","FUND TRANSFER","PLOT CANCELLATION / REFUND","CUSTOMER CORRECTIONS / RECTIFICATIONS","PLOT REGISTRATION","SITE DEVELOPMENT","IBA Enquiry","Associate ID Activation","Sales ID Change","Associate Bank Update",Enquiry,Bonanza,OTHER,"LINK DOCUMENTS REQUEST";
        }
        field(19; "Reporting Leader"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Site Office"; Option)
        {
            Caption = 'Branch Office';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,South-HYD,East-HYD,West-HYD,VIZAG,Amaravati,Warangal,Khammam,Karimnagar,Kurnool,Nellore,Mahabub Nagar';
            OptionMembers = " ","South-HYD","East-HYD","West-HYD",VIZAG,Amaravati,Warangal,Khammam,Karimnagar,Kurnool,Nellore,"Mahabub Nagar";
        }
        field(21; "No. of Plates"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "No. of kamakshi"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "No. of kalasham"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Project Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "From Plot Extent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "To Plot Extent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "From Project Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "To Project Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "From Plot Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "To Plot Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "From Payment Plan"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "To Payment Plan"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Total Amount Paid"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(34; "From Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "To Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Refund Amount %"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Refund Amount Paid"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Aadhar No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(47; "Query Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Request 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Request 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(52; "Request 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(53; "Request 4"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(54; "From Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(55; "To Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(56; "From Mobile"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(57; "To Mobile"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(58; "From Email"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(59; "To Email"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "From Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(61; "To Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(62; "From CustName"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(63; "To CustName"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(64; "Relation with Customer"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(65; "Old Customer Aadhar"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(66; "New Customer Aadhar"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Co Cust Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(71; "Relation With Co Customer"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(72; "Co Customer Aadhar"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(73; "Co Customer Pan"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(74; "Customer Aadhar"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(75; "Request Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(76; "Request Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(77; "Team Code"; Code[50])
        {
            FieldClass = Normal;
        }
        field(78; "Leader Code"; Code[20])
        {
            CalcFormula = Lookup(Vendor."BBG Leader Code" WHERE("No." = FIELD("Requester ID")));
            FieldClass = FlowField;
        }
        field(79; "Sub Team Code"; Code[20])
        {
            CalcFormula = Lookup(Vendor."BBG Sub Team Code" WHERE("No." = FIELD("Requester ID")));
            FieldClass = FlowField;
        }
        field(80; "Request Status"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(81; "Request Pending From"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90; "Help desk Id"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(91; "Correction Of"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(92; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(93; "Amount To Refund"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(95; "Remarks 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(96; "Remarks 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(97; "First Approval / Reject Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(98; "First Approval / Reject Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(99; "Last Approval / Reject Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(100; "Last Approval / Reject Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(101; "Link Doc Associate Id"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '111023';
        }
        field(102; "Link Doc reg Doc Number"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '111023';
        }
    }

    keys
    {
        key(Key1; "Request No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

