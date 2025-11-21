table 60756 "Ref. LLP Item Details"
{
    DataClassification = ToBeClassified;
    DataPerCompany = false;
    DrillDownPageID = "Ref. LLP Item Details";
    LookupPageID = "Ref. LLP Item Details";

    fields
    {
        field(1; "Project Code"; Code[20])
        {
        }
        field(2; "Ref. LLP Name"; Text[30])
        {
            TableRelation = Company;

            trigger OnValidate()
            begin
                IF Rec."Ref. LLP Name" <> xRec."Ref. LLP Name" THEN
                    VALIDATE("Ref. LLP Item No.", '');
            end;
        }
        field(3; "Ref. LLP Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;

            trigger OnLookup()
            begin
                /*RefLLPItemDetails.RESET;
                RefLLPItemDetails.SETRANGE("Project Code","Project Code");
                RefLLPItemDetails.SETRANGE("Ref. LLP Name","Ref. LLP Name");
                //RefLLPItemDetails.SETRANGE("Ref. LLP Item No.","Ref. LLP Item No.");
                IF NOT RefLLPItemDetails.FINDFIRST THEN
                  BEGIN*/

                InventorySetup.CHANGECOMPANY("Ref. LLP Name");
                InventorySetup.GET;
                InventorySetup.TESTFIELD("Item Tracking for Joint Ventur");
                Item.RESET;
                Item.CHANGECOMPANY("Ref. LLP Name");
                //Item.SETRANGE("Land Item",TRUE);
                Item.SETRANGE("Land FG Item", TRUE);

                IF Project.GET("Project Code") THEN
                    IF Project."Joint Venture" THEN
                        Item.SETRANGE("Item Tracking Code", InventorySetup."Item Tracking for Joint Ventur");
                IF Item.FINDFIRST THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Item List", Item) = ACTION::LookupOK THEN BEGIN

                        //    Item.CALCFIELDS(Inventory);
                        //  IF Item.Inventory <> 0 THEN
                        //  BEGIN
                        Item.TESTFIELD("Global Dimension 1 Code");
                        "Ref. LLP Item No." := Item."No.";
                        RefLLPItemDetails.RESET;
                        RefLLPItemDetails.SETRANGE("Ref. LLP Name", "Ref. LLP Name");
                        RefLLPItemDetails.SETRANGE("Ref. LLP Item No.", "Ref. LLP Item No.");
                        IF RefLLPItemDetails.FINDFIRST THEN
                            ERROR(Text0001, RefLLPItemDetails."Project Code");

                        LandAgreementHeader.RESET;
                        LandAgreementHeader.CHANGECOMPANY("Ref. LLP Name");
                        LandAgreementHeader.SETRANGE("FG Item No.", "Ref. LLP Item No.");
                        IF LandAgreementHeader.FINDFIRST THEN BEGIN
                            TotalSize := 0;
                            LandAgreementLine.RESET;
                            LandAgreementLine.CHANGECOMPANY("Ref. LLP Name");
                            LandAgreementLine.SETRANGE("Document No.", LandAgreementHeader."Document No.");
                            IF LandAgreementLine.FINDSET THEN
                                REPEAT
                                    TotalSize := TotalSize + LandAgreementLine."Quantity in SQYD";
                                UNTIL LandAgreementLine.NEXT = 0;
                        END;
                        "Available Inventory" := TotalSize;
                        "Ref. LLP Item Project Code" := Item."Global Dimension 1 Code";

                        CompanyInformation.CHANGECOMPANY("Ref. LLP Name");
                        CompanyInformation.GET();
                        "IC Partner Code" := CompanyInformation."BBG IC Partner Code";
                    END;
                END;
                //END;

            end;

            trigger OnValidate()
            begin
                IF "Ref. LLP Item No." = '' THEN
                    "Available Inventory" := 0;
            end;
        }
        field(4; "Available Inventory"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "IC Partner Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Ref. LLP Item Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Project Code", "Ref. LLP Name", "Ref. LLP Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Rec."Ref. LLP Item No." <> '' THEN BEGIN
            UnitMaster.RESET;
            UnitMaster.SETRANGE("Ref. LLP Name", Rec."Ref. LLP Name");
            UnitMaster.SETRANGE("Ref. LLP Item No.", Rec."Ref. LLP Item No.");
            IF UnitMaster.FINDFIRST THEN
                ERROR(Text0003, UnitMaster."Project Code", UnitMaster."No.");
        END;
    end;

    var
        RefLLPItemDetails: Record "Ref. LLP Item Details";
        Text0001: Label 'Ref. LLP Item No. is already used for Project Code %1.';
        Item: Record Item;
        CompanyInformation: Record "Company Information";
        Text0002: Label 'Ref. LLP Item No. %1 has Inventory %2';
        UnitMaster: Record "Unit Master";
        Text0003: Label 'You can not delete the line, Ref. LLP Item Details Line is already tagged for Project Code %1 , Unit No. %2.';
        Project: Record Job;
        InventorySetup: Record "Inventory Setup";
        LandAgreementHeader: Record "Land Agreement Header";
        TotalSize: Decimal;
        LandAgreementLine: Record "Land Agreement Line";
}

