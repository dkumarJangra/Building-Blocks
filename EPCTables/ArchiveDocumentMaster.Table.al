table 97843 "Archive Document Master"
{
    // //ALLECK 190313 :Added Key Project Code,Unit Code,Version

    DataCaptionFields = "Document Type", "Code", Description;
    DataPerCompany = false;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = ',Unit,Zone,Charge,Brand,Payment Plan,Co-Applicants,Project Price Groups';
            OptionMembers = ,Unit,Zone,Charge,Brand,"Payment Plan","Co-Applicants","Project Price Groups";
        }
        field(3; Description; Text[30])
        {
        }
        field(4; "Project Code"; Code[20])
        {
            TableRelation = Job."No.";
        }
        field(5; "Rate/Sq. Yd"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(6; "Fixed Price"; Decimal)
        {
        }
        field(7; "BP Dependency"; Boolean)
        {
        }
        field(8; "Rate Not Allowed"; Boolean)
        {
        }
        field(9; "Project Price Dependency Code"; Code[20])
        {
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Project Price Groups"),
                                                          "Project Code" = FIELD("Project Code"),
                                                          "Sale/Lease" = FIELD("Sale/Lease"));
        }
        field(10; "Payment Plan Type"; Option)
        {
            OptionCaption = ' ,Construction Linked,Down Payment,Time Linked,Special,Others';
            OptionMembers = " ","Construction Linked","Down Payment","Time Linked",Special,Others;
        }
        field(11; "Sale/Lease"; Option)
        {
            OptionCaption = ' ,Sale,Lease';
            OptionMembers = " ",Sale,Lease;
        }
        field(16; "Commision Applicable"; Boolean)
        {
        }
        field(17; "Direct Associate"; Boolean)
        {
        }
        field(18; Sequence; Integer)
        {
        }
        field(19; "Unit Code"; Code[20])
        {
            TableRelation = "Unit Master";
        }
        field(20; "Membership Fee"; Boolean)
        {
        }
        field(50000; "App. Charge Code"; Code[20])
        {
            TableRelation = "App. Charge Code";
        }
        field(50001; "App. Charge Name"; Text[60])
        {
        }
        field(50002; "Default Setup"; Boolean)
        {
            Description = '081012';
            Editable = true;
        }
        field(50003; Status; Option)
        {
            Description = 'ALLECK 040113';
            OptionMembers = Open,Release,"Pending for Approval",Rejected;  //100625
            OptionCaption = 'Open,Release,Pending for Approval,Rejected';
        }
        field(50004; Version; Integer)
        {
            Description = 'ALLECK 040113';
            Editable = false;
        }
        field(50007; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(50008; "Archive Date"; Date)
        {
            Editable = false;
        }
        field(50009; "Archive Time"; Time)
        {
        }
        field(50100; "New Sequence 1"; Integer)
        {
        }
        field(50201; "BSP4 Plan wise Rate / Sq. Yd"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Project Code", "Code", "Sale/Lease", "Unit Code", "App. Charge Code", Version)
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Code")
        {
        }
        key(Key3; "Project Code", "Unit Code", Version)
        {
        }
    }

    fieldgroups
    {
    }

    var
        PPDRec: Record "Payment Plan Details";
        ShRec: Record "Sales Header";
        APPCharge: Record "App. Charge Code";
        UnitMaster: Record "Unit Master";
        TotalValue: Decimal;
        CalDocMaster: Record "Document Master";
        FixedValue: Decimal;
        UMaster: Record "Unit Master";
        AppPaymentEntry: Record "Application Payment Entry";
}

