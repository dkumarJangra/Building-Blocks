table 60812 "Ptd WhatsApp Data Push Details"
{
    Caption = 'Posted WhatsApp Data Push Details';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Plot No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "No. of Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Received Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Min. allotment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Creation Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Sent Whatsapp Message For Vend"; boolean)
        {
            Caption = 'Sent Whatsapp Message For Vendor';
            DataClassification = ToBeClassified;
        }
        field(11; "Whats Mess DateTime For Vendor"; DateTime)
        {
            Caption = 'Whatsapp Message DateTime For Vendor';
            DataClassification = ToBeClassified;
        }
        field(12; "Select for send Whatsapp"; boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Whatsup Status Code For Vendor"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Whatsup Status Desc For Vendor"; text[1024])
        {
            Caption = 'Whatsup Status Description For Vendor';
            DataClassification = ToBeClassified;
        }
        field(15; "Whatsup mid For Vendor"; text[1024])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                IF Customer.Get("Customer No.") then Begin
                    "Customer Name" := Customer.Name;
                    "Custommer Mobile No." := '91' + Customer."BBG Mobile No.";
                    "Customer Email" := Customer."E-Mail";
                End else
                    Error('Customer No is not find in Customers %1', "Customer No.");

            end;
        }
        field(17; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Project No."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
            begin
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", 'PROJECT');
                DimensionValue.SetRange(Code, "Project No.");
                IF DimensionValue.FindFirst() Then
                    "Project Name" := DimensionValue.Name
                Else
                    Error('Project No. is not find in Responsibility Centor %1', "Project No.");
            end;
        }
        field(19; "Project Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Sent Email"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = False;
        }
        field(21; "Email Err mess For Vendor"; Text[250])
        {
            Caption = 'Email Error message For Vendor';
            DataClassification = ToBeClassified;
            Editable = False;
        }
        field(22; "Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                IF Vendor.get("Associate ID") Then begin
                    "Associate Name" := Vendor.Name;
                    "Associate Mobile No." := '91' + Vendor."BBG Mob. No.";
                    "Associate E-Mail" := Vendor."E-Mail";
                end Else
                    Error('Associate ID is not find in Vendor %1', "Associate ID");
            end;

        }
        field(23; "Associate Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Associate Mobile No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Associate E-Mail"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Posting Date/DOJ"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Custommer Mobile No."; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Customer Email"; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Send Via"; Enum "Send Via")
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Select for send Email"; boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Receiver Type"; Enum "Receiver Type")
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Email Error message For Cust"; Text[250])
        {
            Caption = 'Email Error message For Customer';
            DataClassification = ToBeClassified;
            Editable = False;
        }
        field(35; "Whatsup Status Code For Cust"; Text[50])
        {
            Caption = 'Whatsup Status Code For Customer';
            DataClassification = ToBeClassified;
        }
        field(36; "Whatsup Status Desc For Cust"; text[1024])
        {
            Caption = 'Whatsup Status Description For Customer';
            DataClassification = ToBeClassified;
        }
        field(37; "Whatsup mid For Customer"; text[1024])
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Sent Whatsapp Message For Cust"; boolean)
        {
            Caption = 'Sent Whatsapp Message For Customer';
            DataClassification = ToBeClassified;
        }
        field(40; "Whats Mess DateTime For Cust"; DateTime)
        {
            Caption = 'Whatsapp Message DateTime For Customer';
            DataClassification = ToBeClassified;
        }
        field(41; "Entry ID"; Guid)
        {
            DataClassification = ToBeClassified;
        }
    }


    keys
    {
        key(Key1; "Entry ID", "Application No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}