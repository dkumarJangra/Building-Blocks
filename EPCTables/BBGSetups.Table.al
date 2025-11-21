table 60676 "BBG Setups"
{
    // //ALLEDK 210921 Added new field -21.09
    // ALLESSS 19/02/24 : Fields Added "Project Approver 1", "Project Approver 2" to approve Project Card

    Caption = 'BBG Setups';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; Acres; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Guntas; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Ankanan; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Cents; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Sq. Yard"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Jagrati Link"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Jagrati Lable"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "No. of Days for Hot Lead"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "No. of Days for Cold Lead"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Project Doc Path Save in NAV"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Project Doc Path for Mobile"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(25; SMS; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Gold/Silver New Setup StDt."; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Gold/Silver New Setup EndDt."; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Coupon Date for R001"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(33; "Coupon Date for R002"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(34; "Upload Document Jagrati Path"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Lead Approver 1"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(42; "Lead Approver 2"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(43; "Oppurtinity Approver 1"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(44; "Oppurtinity Approver 2"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(45; "Aggrement Approver 1"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(46; "Aggrement Approver 2"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(47; "Land Expense JV Temp Name"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Land Expense JV Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Land Expense Dim. No.Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Land Expense Dimension No. Series';
            TableRelation = "No. Series";
        }
        field(50; "Old Image Path"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'Serve Change 192.168.1.10 Local server';
        }
        field(51; "New Associate Doc Attach Path"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Serve Change 192.168.1.10 Local server';
        }
        field(52; "New Upload Doc. Jagrati Path"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Serve Change 192.168.1.10 Local server';
        }
        field(53; "Loan EMI No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Loan EMI';
            TableRelation = "No. Series";
        }
        field(54; "Loan Rate of Interest"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Loan EMI';
        }
        field(60; "Land Payment No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(61; "Land Bank Pmt. Template Name"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(62; "Land Bank Pmt. Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(63; "Land Lead No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(64; "Land Opportunity No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(65; "Project Approver 1"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESSS';
            TableRelation = "User Setup";
        }
        field(66; "Project Approver 2"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESSS';
            TableRelation = "User Setup";
        }
        field(100; "Associate Target Request No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(101; "Event Image Path"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Special Incentive Bonanza G/L"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(103; "Special Inct. Bonanza Cash G/L"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Beney Payment Link"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'web';
        }
        //251124 Added new fields start
        field(50002; "Land Vend Helpdesk Rcv Mail ID"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Land Vend Helpdesk Sender Mail"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "New Land Request Rcv Mail ID"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "New Land Request SenderMail ID"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Land Vend Helpdesk Sender PWD"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "New Land Request Sender PWD"; Text[30])
        {
            DataClassification = ToBeClassified;
        }

        field(50008; "Upload Doc. Path(BC)"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(50010; "Download Doc. Jagriti Path(BC)"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Project Doc Path Save in (BC)"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(50012; "Social Media Image Path"; Text[100])
        {
            DataClassification = ToBeClassified;
        }



        //251124 Added new fields END
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        //ALLECK 060313 START
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETRANGE("Role ID", 'A_UNITSETUP');
        IF NOT Memberof.FINDFIRST THEN
            ERROR('You do not have permission of role:A_UNITSETUP');
        //ALLECK 060313 End
    end;

    var
        Memberof: Record "Access Control";
}

