tableextension 97032 "EPC Transfer Header Ext" extends "Transfer Header"
{
    fields
    {
        // Add changes to table fields here
        field(50003; Approved; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';

            trigger OnValidate()
            var
                PurchLineRec: Record "Purchase Line";
                DocSetup: Record "Document Type Setup";
            begin
            end;
        }
        field(50099; "Workflow Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            OptionCaption = ' ,FA,Regular,Direct,WorkOrder,Inward,Outward';
            OptionMembers = " ",FA,Regular,Direct,WorkOrder,Inward,Outward;
        }
        field(50100; "Initiator User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
        }
        field(50004; "Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50005; "Approved Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50010; Initiator; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'BLK-ALLEAB';
        }
        field(50016; "Sent for Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';

            trigger OnValidate()
            begin
                CheckRequired; //JPL03 START
            end;
        }
        field(50019; "Sent for Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50020; "Sent for Approval Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50009; "Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionCaption = ' ,WO-ICB,WO-NICB,Regular PO,Repeat PO,Confirmatory PO,Direct PO,GRN for PO,GRN for JSPL,GRN for Packages,GRN for Fabricated Material for WO,JES for WO,GRN-Direct Purchase,Freight Advice,Order,Invoice,Direct TO,Regular TO';
            OptionMembers = " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice","Order",Invoice,"Direct TO","Regular TO";
        }
        field(50027; "Responsibility Center"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE-PKS13';
            TableRelation = "Responsibility Center 1";

            trigger OnValidate()
            begin
                /*//ALLE-SR-051107 >>
                IF NOT UserMgt.CheckRespCenter(1,"Responsibility Center") THEN
                  ERROR (
                    Text028,
                     RespCenter.TABLECAPTION,UserMgt.GetPurchasesFilter());
                
                VALIDATE("Location code",UserMgt.GetLocation(1,'',"Responsibility Center"));
                
                //ALLE-SR-051107 <<
                 */

            end;
        }
        field(50029; Remarks; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50021; Amended; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50022; "Amendment Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';

            trigger OnValidate()
            begin
                CheckRequired; //JPL03 START
            end;
        }
        field(50025; "Amendment Initiator"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = Employee;
        }
        field(50130; "PO code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';

            trigger OnLookup()
            begin

                PHdr.RESET;
                PHdr.SETRANGE("Document Type", PHdr."Document Type"::Order);
                PHdr.SETRANGE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                PHdr.SETRANGE("Sub Document Type", PHdr."Sub Document Type"::"WO-NICB");
                PHdr.SETRANGE(Approved, TRUE);
                IF PHdr.FINDFIRST THEN
                    REPEAT
                        IF (PHdr.Amended = TRUE) AND (PHdr."Amendment Approved" = TRUE) THEN
                            PHdr.MARK := TRUE
                        ELSE IF (PHdr.Amended = FALSE) THEN
                            PHdr.MARK := TRUE;
                    UNTIL PHdr.NEXT = 0;

                PHdr.MARKEDONLY(TRUE);
                IF PHdr.FIND('-') THEN BEGIN
                    CLEAR(PHdrForm);
                    //PHdrForm.SETTABLEVIEW(PHdr);
                    //PHdrForm.LOOKUPMODE := TRUE;
                    //  PHdrForm.RUNMODAL;

                    IF PAGE.RUNMODAL(Page::"Purchase List", PHdr) = ACTION::LookupOK THEN
                        VALIDATE("PO code", PHdr."No.");
                END;
            end;

            trigger OnValidate()
            begin
                //MP1.0
                IF "PO code" <> '' THEN BEGIN
                    purchheader.GET(purchheader."Document Type"::Order, "PO code");
                    IF purchheader."Ending Date" < TODAY THEN
                        ERROR('The Wo has already expired. you cannot issue more quantity');
                    PRLine.RESET;
                    PRLine.SETRANGE("Document No.", "No.");
                    IF PRLine.FINDSET THEN
                        REPEAT
                            PRLine."PO CODE" := "PO code";
                            PRLine.MODIFY;
                        UNTIL PRLine.NEXT = 0;
                END;
                //MP1.0
            end;
        }
        field(50002; "Order Status"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Field Added to show Order Status as Cancelled, short closed or Completed--JPL';
            Editable = false;
            OptionMembers = " ",Cancelled,"Short Closed",Completed;
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
        RecUserSetup: Record "User Setup";
        RecRespCenter: Record "Responsibility Center 1";
        DocSetup: Record "Document Type Setup";
        DocInitiator: Record "Document Type Initiator";
        DocApproval: Record "Document Type Approval";
        DocumentApproval: Record "Document Type Approval";
        DimValue: Record "Dimension Value";
        TranslineRec: Record "Transfer Line";
        UserMgt: Codeunit "EPC User Setup Management";
        purchheader: Record "Purchase Header";
        PRLine: Record "Transfer Line";
        TransferRoute1: Record "Transfer Route";
        RespCenter: Record "Responsibility Center 1";
        PHdr: Record "Purchase Header";
        PHdrForm: Page "Purchase List";
        Resp: Record "Responsibility Center 1";


    PROCEDURE CheckRequired();
    VAR
        PurchLineRec: Record "Purchase Line";
        DocSetup: Record "Document Type Setup";
        vJobAllocationReq: Boolean;
        vJobAllocation: Record "Job Allocation";
        vPurchLine: Record "Purchase Line";
        vJobAmt: Decimal;
        POHdrL: Record "Purchase Header";
        OldVendLedgEntry: Record "Vendor Ledger Entry";
    BEGIN
        //ALLE-PKS02

        DocSetup.GET(DocSetup."Document Type"::"Transfer Order", "Sub Document Type");
        TESTFIELD("Shortcut Dimension 1 Code");
        // TESTFIELD("Shortcut Dimension 2 Code" );
        TESTFIELD("Posting Date");
        TranslineRec.RESET;
        TranslineRec.SETRANGE("Document No.", "No.");
        IF TranslineRec.FIND('-') THEN BEGIN
            REPEAT
                IF DocSetup."Indent Required" THEN BEGIN
                    TranslineRec.TESTFIELD("Indent Line No.");
                    TranslineRec.TESTFIELD("Indent No.");
                    // TransLineRec.CheckIndentT;
                END;
                // may 1.0 added condition
                IF TranslineRec."Quantity Received" = 0 THEN
                    TranslineRec.TESTFIELD("Outstanding Quantity");
            UNTIL TranslineRec.NEXT = 0;
        END;
        //ALLE-PKS02
    END;
}