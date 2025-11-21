tableextension 50071 "BBG Purch & Payables Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50007; "Work Order Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0012 11-07-2007';
            TableRelation = "No. Series";
        }
        field(50008; "Service Order Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESVM BCL0012 06-09-2007';
            TableRelation = "No. Series";
        }


        field(50011; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            Description = 'SC For Auto Indenting--JPL';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50012; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Description = 'SC--JPL';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50013; "Advice No Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "No. Series";
        }
        field(50014; "Comparison Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '--BCL';
            TableRelation = "No. Series";
        }

        field(50016; "Vendor Development Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50017; "Work Center Code Mandatory"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
        }

        field(50019; "Award Note Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
            TableRelation = "No. Series";
        }
        field(50020; "FBW Enquiry No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50021; "FBW Service Order Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50022; "FBW Subcontracting Order Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50023; "FBW Indent Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50024; "FBW Material Issue Note"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50025; "FBW Material Return Note"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50026; "FBW Outward Gate Pass"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50027; "FBW Inward Gate Pass"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50028; "FBW Credit Memo Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50029; "FBW Posted Credit Memo Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50035; "Request No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Payment Request No on Web';
            TableRelation = "No. Series".Code;
        }
        field(50036; "Reserve Associate Payment Amt"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                AccessControl: Record "Access Control";
            begin
                UserSetup.RESET;
                IF UserSetup.GET(USERID) THEN BEGIN
                    IF NOT UserSetup."Reserve Ass. Payment" THEN
                        ERROR('Please contact Admin Department');
                END;
            end;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        UserSetup: Record "User Setup";
}