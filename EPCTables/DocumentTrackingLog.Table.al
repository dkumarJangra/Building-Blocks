table 97745 "Document Tracking Log"
{
    // KLND1.00 ALLEPG 190510 : Created new table.


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Job No."; Code[20])
        {
        }
        field(3; "Document No."; Code[20])
        {
        }
        field(4; "User ID"; Code[20])
        {
        }
        field(5; "Date Changed"; Date)
        {
        }
        field(6; "Previous Status"; Option)
        {
            OptionCaption = ' ,Received from Vendor,Forwarded to Customer,Returned by Customer,Return to Vendor,Approved,Forwarded to Dept,Recieved From Dept,Released to Site';
            OptionMembers = " ","Received from Vendor","Forwarded to Customer","Returned by Customer","Return to Vendor",Approved,"Forwarded to Dept","Recieved From Dept","Released to Site";
        }
        field(7; "New Status"; Option)
        {
            OptionCaption = ' ,Received from Vendor,Forwarded to Customer,Returned by Customer,Return to Vendor,Approved,Forwarded to Dept,Recieved From Dept,Released to Site';
            OptionMembers = " ","Received from Vendor","Forwarded to Customer","Returned by Customer","Return to Vendor",Approved,"Forwarded to Dept","Recieved From Dept","Released to Site";
        }
        field(50000; "Vendor Drawing No."; Code[30])
        {
            Description = 'ALLEAA';
        }
        field(50001; "Customer Drawing No."; Code[30])
        {
            Description = 'ALLEAA';
        }
        field(50002; "Transmittal No."; Code[20])
        {
            Description = 'ALLEAA';
        }
        field(50003; "Transmittal Date"; Date)
        {
            Description = 'ALLEAA';
        }
        field(50004; CC1; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50005; "CC1 Designation"; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50006; CC2; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50007; "CC2 Designation"; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50008; CC3; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50009; "CC3 Designation"; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50010; CC4; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50011; "CC4 Designation"; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50012; "Client Contact"; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50013; "Client Contact Designation"; Text[50])
        {
            Description = 'ALLEAA';
        }
        field(50014; "CC1 Only Transmittal"; Boolean)
        {
            Caption = 'CC1 Only Transmittal';
            Description = 'ALLEAA';
        }
        field(50015; "CC2 Only Transmittal"; Boolean)
        {
            Caption = 'CC2 Only Transmittal';
            Description = 'ALLEAA';
        }
        field(50016; "CC3 Only Transmittal"; Boolean)
        {
            Caption = 'CC3 Only Transmittal';
            Description = 'ALLEAA';
        }
        field(50017; "CC4 Only Transmittal"; Boolean)
        {
            Caption = 'CC4 Only Transmittal';
            Description = 'ALLEAA';
        }
        field(50018; "Document Description"; Text[100])
        {
            Description = 'ALLEAA';
        }
        field(50019; "Transmittal Sender"; Code[20])
        {
            Description = 'ALLEAA';
            TableRelation = User."User Name";
        }
        field(50020; "Remarks : Enclosed"; Text[100])
        {
            Description = 'ALLEAA';
        }
        field(50021; "Remarks : Body"; Text[250])
        {
            Description = 'ALLEAA';
        }
        field(50022; Version; Integer)
        {
            Description = 'ALLEAA';
        }
        field(50023; "A/I"; Option)
        {
            Description = 'ALLEAA';
            OptionCaption = 'A,I';
            OptionMembers = A,I;
        }
        field(50024; Subject; Text[80])
        {
            Description = 'ALLEAA';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "New Status")
        {
        }
    }

    fieldgroups
    {
    }
}

