table 60677 "Archive Region wise Vendor"
{
    Caption = 'Region_ Rank wise Vendor';
    DataPerCompany = false;
    DrillDownPageID = "Regin and Rank wise vendor";
    LookupPageID = "Regin and Rank wise vendor";

    fields
    {
        field(1; "Region Code"; Code[20])
        {
            TableRelation = "Rank Code Master";
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = Vendor."No." WHERE("BBG Vendor Category" = FILTER("IBA(Associates)"));
        }
        field(4; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(5; "Parent Code"; Code[20])
        {

            trigger OnValidate()
            var
                recRank: Record "Job Master";
            begin
            end;
        }
        field(6; "Rank Code"; Decimal)
        {
            TableRelation = "Rank Code".Code WHERE("Rank Batch Code" = FIELD("Region Code"));

            trigger OnValidate()
            var
                Rank: Record "Rank Code";
            begin
            end;
        }
        field(7; Status; Option)
        {
            Editable = true;
            OptionCaption = ' ,Provisional,Active,Inactive';
            OptionMembers = " ",Provisional,Active,Inactive;
        }
        field(8; "Parent Rank"; Decimal)
        {
            Editable = false;
            TableRelation = "Rank Code".Code WHERE("Rank Batch Code" = FIELD("Region Code"));

            trigger OnValidate()
            var
                recRank: Record "Job Master";
            begin
            end;
        }
        field(9; "Associate Level"; Integer)
        {
        }
        field(10; "Old No."; Code[10])
        {
        }
        field(13; "Old Parent Code"; Code[10])
        {
        }
        field(14; "Region Description"; Text[50])
        {
        }
        field(15; "Vendor Check Status"; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(16; "Parent Description"; Text[30])
        {
            Editable = false;
        }
        field(17; "Rank Description"; Text[30])
        {
            Editable = false;
        }
        field(18; "Parent Name"; Text[50])
        {
            Editable = false;
        }
        field(19; Priority; Integer)
        {
            Caption = 'Priority';
        }
        field(20; "E-Mail"; Text[30])
        {
        }
        field(50001; "Associate DOJ"; Date)
        {
            CalcFormula = Lookup(Vendor."BBG Date of Joining" WHERE("No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50002; "Parent Associate DOJ"; Date)
        {
            CalcFormula = Lookup(Vendor."BBG Date of Joining" WHERE("No." = FIELD("Parent Code")));
            FieldClass = FlowField;
        }
        field(50003; "New Region Code"; Code[20])
        {
        }
        field(50004; "Introducer Update on Vendor"; Boolean)
        {
            Editable = false;
        }
        field(50005; "Team Head"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(50006; "Print Team Head"; Code[20])
        {
            Editable = true;
        }
        field(50007; "Version No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(60000; "Creation Date"; Date)   //Added new field 17122025 
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50304; "Team Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Team Master";
        }
        field(50305; "Leader Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Leader Master";
        }
        field(50306; "Sub Team Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub Team Master";
        }
        field(50307; "CP Team Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "CP Team Master";
        }
        field(50308; "CP Leader Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "CP Leader Master";
        }

    }

    keys
    {
        key(Key1; "Region Code", "No.", "Version No.")
        {
            Clustered = true;
        }
        key(Key2; "No.")
        {
        }
        key(Key3; "Rank Code")
        {
        }
        key(Key4; "Region Code", "Parent Code")
        {
        }
        key(Key5; Priority, "No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, "Region Code", "Parent Rank")
        {
        }
    }

    trigger OnDelete()
    var
        ItemVendor: Record "Item Vendor";
        PurchPrice: Record "Purchase Price";
        PurchLineDiscount: Record "Purchase Line Discount";
        PurchPrepmtPct: Record "Purchase Prepayment %";
    begin
    end;

    var
        Text012: Label 'Parent code should not be same as Code.';
        Text013: Label 'MM %1 is Inactive.';
        Text014: Label 'Rank cannot be greater or equal with parent.';
        Text015: Label 'Parent code should not be same as Code.';
        RegionwiseVendor: Record "Region wise Vendor";
        Vendor: Record Vendor;
        RankForm: Page "Rank Code";
        RankCode: Record "Rank Code";
        RegionMaster: Record "Rank Code Master";
        Vend: Record Vendor;
        RegionwiseVend_1: Record "Region wise Vendor";
        UserSetup: Record "User Setup";
}

