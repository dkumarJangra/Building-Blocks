table 50040 "Region wise Vendor12"
{
    // //NDALLE 051107
    // //Added new fields
    // ////NDALLE 051107 To Master validate
    // // ALLEAS02 >> >> To Flow Vendor Posting Group
    // ALLRE : New Field Added
    // //AlleBLK : New Field Added
    // ALLESP BCL0004 11-07-2007 : New Field Added
    // //AlleDK 130308 : using for Report
    // //added by DDS : New Field Added
    // --JPL : New Field Added
    // JPL0002 : indicator that party is related ie. group related--JPL
    // 
    // ALLERP KRN0014 19-08-2010: Field "Validity till date" added and code added for updating in product vendors
    // ALLERP AlleHF 07-09-2010: Applying HF1 to HF5
    // ALLEPG 270711 :   Added HotFix PS59643 for Service Tax.
    // ALLEPG 040712 : Added field.
    // ALLEPG 310812 : Added Fields.
    // ALLEPG 051012 : Created function CreateVendorFromWeb.
    // ALELDK 040313 Code commented

    Caption = 'Region_ Rank wise Vendor';
    DataPerCompany = false;
    DrillDownPageID = "Regin and Rank wise vendor";
    LookupPageID = "Regin and Rank wise vendor";

    fields
    {
        field(1; "Region Code"; Code[20])
        {
            TableRelation = "Rank Code Master";

            trigger OnValidate()
            begin
                IF RegionMaster.GET("Region Code") THEN
                    "Region Description" := RegionMaster.Description
                ELSE
                    "Region Description" := '';
            end;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = Vendor."No." WHERE("BBG Vendor Category" = FILTER("IBA(Associates)"));

            trigger OnValidate()
            begin
                IF Vendor.GET("No.") THEN
                    Name := Vendor.Name
                ELSE
                    Name := '';
            end;
        }
        field(4; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(5; "Parent Code"; Code[20])
        {
            TableRelation = "Region wise Vendor"."No." WHERE("Region Code" = FIELD("Region Code"));

            trigger OnValidate()
            var
                recRank: Record "Job Master";
            begin
                TESTFIELD("Rank Code");
                IF "Parent Code" = "No." THEN
                    ERROR(Text012);
                IF "Parent Code" <> '' THEN
                    IF RegionwiseVendor.GET("Region Code", "Parent Code") THEN BEGIN
                        IF Vendor.GET("Parent Code") THEN;
                        IF Vendor."BBG Status" = Vendor."BBG Status"::Inactive THEN
                            ERROR(Text013, Vendor."BBG Parent Code");
                        RegionwiseVendor.TESTFIELD("Rank Code");
                        IF "Rank Code" >= RegionwiseVendor."Rank Code" THEN
                            ERROR(Text014);
                        "Parent Rank" := RegionwiseVendor."Rank Code";
                        "Old Parent Code" := RegionwiseVendor."Old No.";
                    END;

                RankCode.RESET;
                IF RankCode.GET("Region Code", "Parent Rank") THEN
                    "Parent Description" := RankCode.Description;

                IF Vend.GET("Parent Code") THEN
                    "Parent Name" := Vend.Name;


                IF "Parent Code" = '' THEN
                    "Parent Rank" := 0;
            end;
        }
        field(6; "Rank Code"; Decimal)
        {
            TableRelation = "Rank Code".Code WHERE("Rank Batch Code" = FIELD("Region Code"));

            trigger OnValidate()
            var
                Rank: Record "Rank Code";
            begin
                IF Status IN [1, 2] THEN
                    IF Rank.GET("Region Code", "Rank Code") THEN
                        Rank.TESTFIELD("Direct Entry", TRUE);

                IF "Parent Code" = "No." THEN
                    ERROR(Text015);
                IF "Parent Code" <> '' THEN
                    IF RegionwiseVendor.GET("Region Code", "Parent Code") THEN BEGIN
                        RegionwiseVendor.TESTFIELD("Rank Code");
                        IF Rec."Rank Code" >= RegionwiseVendor."Rank Code" THEN
                            ERROR('Rank cannot be greater or equal with parent.');
                    END;

                RankCode.RESET;
                IF RankCode.GET("Region Code", "Rank Code") THEN
                    "Rank Description" := RankCode.Description;
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
    }

    keys
    {
        key(Key1; "Region Code", "No.")
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
        fieldgroup(DropDown; "Region Code", Status, "Associate Level", "Parent Rank")
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
}

