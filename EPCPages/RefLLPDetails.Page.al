page 50273 "Ref. LLP Details"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Ref. LLP Details";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                }
                field("Total Inventory"; Rec."Total Inventory")
                {
                    DrillDown = true;
                    DrillDownPageID = "Ref. LLP Item Details";
                }
            }
            part("Ref. LLP Item Details"; "Ref. LLP Item Details")
            {
                SubPageLink = "Project Code" = FIELD("Project Code");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(InsertRefLLPDetailsOnProject)
            {
                Caption = 'Insert Ref.LLP Details on Project';
                Image = Insert;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = InsertProjectUnitMaster;

                trigger OnAction()
                begin
                    Project.GET(Rec."Project Code");
                    Project.TESTFIELD("Joint Venture", true);
                    //InsertRefLLPItemDetailsOnProject;  090624 Code commented
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //ALLESSS 16/02/24---Begin
        IF Project.GET(Rec."Project Code") THEN
            IF Project."Joint Venture" THEN
                InsertProjectUnitMaster := TRUE
            ELSE
                InsertProjectUnitMaster := FALSE;

        InsertProjectUnitMaster := FALSE;  //090524 Added new code
        //ALLESSS 16/02/24---End

        //UpdateRefItemInventory;  //ALLESSS 02/02/24
    end;

    var
        Project: Record Job;
        InsertProjectUnitMaster: Boolean;
        RefLLPItemDetails: Record "Ref. LLP Item Details";
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        UnitMaster: Record "Unit Master";
        UnitMaster1: Record "Unit Master";
        LineInsertedProjectUnitMaster: Boolean;
        POQty: Decimal;
        v_PurchaseLine: Record "Purchase Line";

    local procedure UpdateRefItemInventory()
    var
        RefLLPItemDetails: Record "Ref. LLP Item Details";
        Item: Record Item;
        RefLLPItemDetails1: Record "Ref. LLP Item Details";
        CompanyInformation: Record "Company Information";
        LandAgreementHeader: Record "Land Agreement Header";
        LandAgreementLine: Record "Land Agreement Line";
        TotalSize: Decimal;
    begin
        /*
        RefLLPItemDetails.RESET;
        RefLLPItemDetails.SETRANGE("Project Code","Project Code");
        IF RefLLPItemDetails.FINDSET THEN
          REPEAT
            //090624 New code added Start
            POQty:=0;
            v_PurchaseLine.RESET;
            v_PurchaseLine.CHANGECOMPANY(RefLLPItemDetails."Ref. LLP Name");
            v_PurchaseLine.SETRANGE("No.",RefLLPItemDetails."Ref. LLP Item No.");
            IF v_PurchaseLine.FINDSET THEN BEGIN
              REPEAT
                POQty :=  POQty + v_PurchaseLine.Quantity;
              UNTIL v_PurchaseLine.NEXT =0;
              RefLLPItemDetails1 := RefLLPItemDetails;
                //RefLLPItemDetails1."Available Inventory" := POQty;
                Item.RESET;
                Item.CHANGECOMPANY(RefLLPItemDetails."Ref. LLP Name");
                Item.SETRANGE("No.",RefLLPItemDetails."Ref. LLP Item No.");
                IF Item.FINDFIRST THEN
                  RefLLPItemDetails1."Ref. LLP Item Project Code" := Item."Global Dimension 1 Code";
        
                CompanyInformation.CHANGECOMPANY(RefLLPItemDetails1."Ref. LLP Name");
                       LandAgreementHeader.RESET;
                        LandAgreementHeader.CHANGECOMPANY(RefLLPItemDetails1."Ref. LLP Name");
                        LandAgreementHeader.SETRANGE("FG Item No.",RefLLPItemDetails1."Ref. LLP Item No.");
                        IF LandAgreementHeader.FINDFIRST THEN BEGIN
                          TotalSize := 0;
                          LandAgreementLine.RESET;
                          LandAgreementLine.CHANGECOMPANY(RefLLPItemDetails1."Ref. LLP Name");
                          LandAgreementLine.SETRANGE("Document No.",LandAgreementHeader."Document No.");
                          IF LandAgreementLine.FINDSET THEN
                            REPEAT
                              TotalSize := TotalSize + LandAgreementLine."Quantity in SQYD";
                            UNTIL LandAgreementLine.NEXT = 0;
                        END;
        
                        RefLLPItemDetails1."Available Inventory" := TotalSize;
        
                CompanyInformation.GET();
                RefLLPItemDetails1."IC Partner Code" := CompanyInformation."IC Partner Code";
                RefLLPItemDetails1.MODIFY;
        
            END;
            UNTIL RefLLPItemDetails.NEXT = 0;
          COMMIT;
          */
        //090624 New code added END


        /* Old CODE commented 090624
        RefLLPItemDetails.RESET;
        RefLLPItemDetails.SETRANGE("Project Code","Project Code");
        IF RefLLPItemDetails.FINDSET THEN
          REPEAT
            Item.RESET;
            Item.CHANGECOMPANY(RefLLPItemDetails."Ref. LLP Name");
            Item.SETRANGE("No.",RefLLPItemDetails."Ref. LLP Item No.");
            IF Item.FINDFIRST THEN
              BEGIN
                RefLLPItemDetails1 := RefLLPItemDetails;
                Item.CALCFIELDS(Inventory);
                RefLLPItemDetails1."Available Inventory" := Item.Inventory;
                RefLLPItemDetails1."Ref. LLP Item Project Code" := Item."Global Dimension 1 Code";
        
                CompanyInformation.CHANGECOMPANY(RefLLPItemDetails."Ref. LLP Name");
                CompanyInformation.GET();
                RefLLPItemDetails1."IC Partner Code" := CompanyInformation."IC Partner Code";
                RefLLPItemDetails1.MODIFY;
              END;
          UNTIL RefLLPItemDetails.NEXT = 0;
          COMMIT;
        
        */ //Old code commented 090624

    end;

    local procedure InsertRefLLPItemDetailsOnProject()
    begin
        RefLLPItemDetails.RESET;
        RefLLPItemDetails.SETRANGE("Project Code", Rec."Project Code");
        IF RefLLPItemDetails.FINDFIRST THEN BEGIN
            REPEAT
                Item.RESET;
                Item.CHANGECOMPANY(RefLLPItemDetails."Ref. LLP Name");
                Item.SETRANGE("No.", RefLLPItemDetails."Ref. LLP Item No.");
                IF Item.FINDFIRST THEN BEGIN
                    ItemLedgerEntry.RESET;
                    ItemLedgerEntry.CHANGECOMPANY(RefLLPItemDetails."Ref. LLP Name");
                    ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                    ItemLedgerEntry.SETFILTER("Lot No.", '<>%1', '');
                    ItemLedgerEntry.SETFILTER("Remaining Quantity", '<>%1', 0);
                    IF ItemLedgerEntry.FINDSET THEN
                        REPEAT
                            ItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)");
                            UnitMaster1.RESET;
                            UnitMaster1.SETRANGE("No.", ItemLedgerEntry."Lot No.");
                            IF NOT UnitMaster1.FINDFIRST THEN BEGIN
                                UnitMaster.INIT;
                                UnitMaster."No." := ItemLedgerEntry."Lot No.";
                                UnitMaster."Project Code" := RefLLPItemDetails."Project Code";
                                UnitMaster.Description := ItemLedgerEntry.Description;
                                UnitMaster."Saleable Area" := ItemLedgerEntry.Quantity;
                                UnitMaster."Unit Type" := 'PLOT';
                                UnitMaster."Base Unit of Measure" := ItemLedgerEntry."Unit of Measure Code";
                                UnitMaster."Ref. LLP Name" := RefLLPItemDetails."Ref. LLP Name";
                                UnitMaster."Ref. LLP Item No." := RefLLPItemDetails."Ref. LLP Item No.";
                                UnitMaster."IC Partner Code" := RefLLPItemDetails."IC Partner Code";
                                UnitMaster.INSERT;
                                LineInsertedProjectUnitMaster := TRUE;
                            END;
                        UNTIL ItemLedgerEntry.NEXT = 0;
                END;
            UNTIL RefLLPItemDetails.NEXT = 0;
            IF LineInsertedProjectUnitMaster THEN
                MESSAGE('Ref. Item Detail lines inserted successfully')
            ELSE
                MESSAGE('Nothing to insert');
        END;
    end;
}

