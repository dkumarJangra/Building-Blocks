table 60698 "Report Request from Web/Mb."
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Report Id"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                MobileReportList.RESET;
                IF MobileReportList.GET("Report Id") THEN
                    "Report Name" := MobileReportList."Report Name"
                ELSE
                    "Report Name" := '';
            end;
        }
        field(3; "Report Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Report Request Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Report Request Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Report Send"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Report Sending Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Request From Web Service"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Web,Mobile';
            OptionMembers = " ",Web,Mobile;
        }
        field(9; "Associate Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Vendor WHERE("No." = FILTER('IBA*'));
        }
        field(10; "Associate Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Associate Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Report Generated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(13; "To Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(14; "E-Mail"; Text[80])
        {
            CalcFormula = Lookup(Vendor."E-Mail" WHERE("No." = FIELD("Associate Code")));
            Caption = 'E-Mail';
            Editable = false;
            ExtendedDatatype = EMail;
            FieldClass = FlowField;
        }
        field(15; "Report Sending Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(16; "Error Message"; TExt[1024])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Associate Code", "Report Id", "Report Send")
        {
        }
    }

    fieldgroups
    {
    }

    var
        MobileReportList: Record "Mobile Report List";
}

