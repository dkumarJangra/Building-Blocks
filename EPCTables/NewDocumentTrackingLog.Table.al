table 97752 "New Document Tracking Log"
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
        field(6; "Previous status"; Code[20])
        {
        }
        field(7; "New status"; Code[20])
        {
        }
        field(10; "Old Status"; Code[20])
        {
            TableRelation = "Document Tracking status".Code;
        }
        field(11; Status; Code[20])
        {
            TableRelation = "Document Tracking status".Code;
        }
        field(50000; "Purchase Doc No."; Code[30])
        {
        }
        field(50001; "Sales Doc No."; Code[30])
        {
        }
        field(50002; "Transmittal No."; Code[20])
        {
        }
        field(50003; "Transmittal Date"; Date)
        {
        }
        field(50004; CC1; Text[50])
        {
        }
        field(50005; "CC1 Designation"; Text[50])
        {
        }
        field(50006; CC2; Text[50])
        {
        }
        field(50007; "CC2 Designation"; Text[50])
        {
        }
        field(50008; CC3; Text[50])
        {
        }
        field(50009; "CC3 Designation"; Text[50])
        {
        }
        field(50010; CC4; Text[50])
        {
        }
        field(50011; "CC4 Designation"; Text[50])
        {
        }
        field(50012; "Client Contact"; Text[50])
        {
        }
        field(50013; "Client Contact Designation"; Text[50])
        {
        }
        field(50014; "CC1 Only Transmittal"; Boolean)
        {
            Caption = 'CC1 Only Transmittal';
        }
        field(50015; "CC2 Only Transmittal"; Boolean)
        {
            Caption = 'CC2 Only Transmittal';
        }
        field(50016; "CC3 Only Transmittal"; Boolean)
        {
            Caption = 'CC3 Only Transmittal';
        }
        field(50017; "CC4 Only Transmittal"; Boolean)
        {
            Caption = 'CC4 Only Transmittal';
        }
        field(50018; "Document Description"; Text[100])
        {
        }
        field(50019; "Transmittal Sender"; Code[20])
        {
            TableRelation = User."User Name";
        }
        field(50020; "Remarks : Enclosed"; Text[100])
        {
        }
        field(50021; "Remarks : Body"; Text[250])
        {
        }
        field(50022; Version; Integer)
        {
        }
        field(50023; "A/I"; Option)
        {
            OptionCaption = 'A,I';
            OptionMembers = A,I;
        }
        field(50024; Subject; Text[80])
        {
        }
        field(50025; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));
        }
        field(50026; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ',Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order, ';
            OptionMembers = ,Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(50028; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(50029; "Document code"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "New status")
        {
        }
    }

    fieldgroups
    {
    }
}

