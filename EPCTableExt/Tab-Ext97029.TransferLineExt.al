tableextension 97029 "EPC Transfer Line Ext" extends "Transfer Line"
{
    fields
    {
        // Add changes to table fields here
        field(50002; "Indent No."; Code[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50003; "Indent Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50012; "PO CODE"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';
            Editable = false;

            trigger OnValidate()
            begin
                //ERROR('You Can Not Make Return Transfer Order With This Location');
                purchheader.GET(purchheader."Document Type"::Order, "PO CODE");
                IF purchheader."Ending Date" < TODAY THEN
                    ERROR('The Wo has already expired. you cannot issue more quantity');

                IF ("PO CODE" <> '') THEN BEGIN
                    focitemlist.RESET;
                    focitemlist.SETRANGE(focitemlist."No.", "PO CODE");
                    focitemlist.SETRANGE(focitemlist."Item Code", "Item No.");
                    IF focitemlist.FIND('-') THEN
                        "PO Line No." := focitemlist."Line No.";
                END
            end;
        }
        field(50013; "PO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';
            Editable = true;
            TableRelation = "FOC/PO TABLE"."Line No.";

            trigger OnLookup()
            begin
                GetTransferHdr;
                cHK.SETRANGE("Document Type", cHK."Document Type"::Order);
                cHK.SETRANGE(cHK."No.", THeader."PO code");
                //cHK.SETRANGE(cHK."Item Code","Item No.");
                //IF TRHeader.GET("Document No.") THEN BEGIN
                //  IF TRHeader."Transfer FG" THEN
                //    cHK.SETRANGE(Type, cHK.Type::Finished);
                //END;
                IF PAGE.RUNMODAL(Page::"FOC LIST", cHK) = ACTION::LookupOK THEN BEGIN
                    purchheader.GET(purchheader."Document Type"::Order, cHK."No.");
                    IF purchheader."Ending Date" < TODAY THEN
                        ERROR('The Wo has already expired. you cannot issue more quantity');
                    VALIDATE("Item No.", cHK."Item Code");
                    "PO CODE" := cHK."No.";
                    "PO Line No." := cHK."Line No.";
                    "Indent No." := '';
                    Description := cHK."Item Description";
                    "Description 2" := cHK."Description 2";
                    //RAHEE1.00 210212

                    IF cHK.Type <> cHK.Type::Finished THEN BEGIN
                        PLine.RESET;
                        PLine.SETRANGE("Document Type", purchheader."Document Type");
                        PLine.SETRANGE("Document No.", purchheader."No.");
                        PLine.SETFILTER("Indent No", '<>%1', '');
                        IF PLine.FINDFIRST THEN BEGIN
                            "Indent No." := PLine."Indent No";
                            "Indent Line No." := PLine."Line No.";
                        END ELSE
                            "Indent No." := '';
                    END;
                    //RAHEE1.00 210212
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
        LocationRec: Record Location;
        LocationRec1: Record Location;
        PLine: Record "Purchase Line";
        TRHeader: Record "Transfer Header";
        GLSETUP: Record "General Ledger Setup";
        THeader: Record "Transfer Header";
        purchheader: Record "Purchase Header";
        focitemlist: Record "FOC/PO TABLE";
        COUNTX: Integer;
        COUNTY: Integer;
        TransLine: Record "Transfer Line";
        cHK: Record "FOC/PO TABLE";
        IndentLine: Record "Purchase Request Line";
        ToLineRec: Record "Transfer Line";
        DefDimRec: Record "Default Dimension";
        DefDimRec2: Record "Default Dimension";
        IndentLineForm: Page "Purchase Request Lines List";

    PROCEDURE GetTransferHdr();
    BEGIN
        IF THeader.GET("Document No.") THEN;
    END;


    PROCEDURE FillIndentLines(VAR pIndentLine: Record "Purchase Request Line"; tTransHeader: Record "Transfer Header");
    VAR
        vLineNo: Integer;
    BEGIN
        //ALLE_PKS
        //JPL09 START
        vLineNo := 0;
        ToLineRec.RESET;
        ToLineRec.SETRANGE("Document No.", tTransHeader."No.");
        IF ToLineRec.FIND('+') THEN
            vLineNo := ToLineRec."Line No.";

        IF pIndentLine.FIND('-') THEN BEGIN
            REPEAT
                vLineNo := vLineNo + 10000;
                ToLineRec.INIT;
                ToLineRec."Document No." := tTransHeader."No.";
                ToLineRec."Line No." := vLineNo + 10000;
                ToLineRec.INSERT;
                pIndentLine.CALCFIELDS("TO Qty");
                pIndentLine.CALCFIELDS("PO Qty");

                ToLineRec.VALIDATE("Item No.", pIndentLine."No.");
                ToLineRec.VALIDATE(ToLineRec."Transfer-from Code", tTransHeader."Transfer-from Code");
                ToLineRec.VALIDATE(ToLineRec."Transfer-to Code", tTransHeader."Transfer-to Code");

                ToLineRec.VALIDATE(ToLineRec."Shortcut Dimension 2 Code", tTransHeader."Shortcut Dimension 2 Code");
                ToLineRec.VALIDATE("Unit of Measure Code", pIndentLine."Purchase UOM");
                IF pIndentLine."Purch Qty Per Unit Of Measure" = 0 THEN
                    pIndentLine."Purch Qty Per Unit Of Measure" := 1;
                ToLineRec.VALIDATE(Quantity, (pIndentLine."Quantity Base" - pIndentLine."TO Qty" - pIndentLine."PO Qty")
                / pIndentLine."Purch Qty Per Unit Of Measure");
                ToLineRec.Description := pIndentLine.Description;
                ToLineRec."Description 2" := pIndentLine."Description 2";
                ToLineRec."Indent No." := pIndentLine."Document No.";
                ToLineRec."Indent Line No." := pIndentLine."Line No.";
                ToLineRec.VALIDATE("Shortcut Dimension 1 Code", tTransHeader."Shortcut Dimension 1 Code");
                // ToLineRec.VALIDATE("Shortcut Dimension 2 Code",pIndentLine."Shortcut Dimension 2 Code");
                GLSETUP.GET;   //RAHEE1.00 060412
                DefDimRec.RESET;
                DefDimRec.GET(27, pIndentLine."No.", GLSETUP."Global Dimension 2 Code");   //RAHEE1.00 060412
                ToLineRec."Shortcut Dimension 2 Code" := DefDimRec."Dimension Value Code";
                ToLineRec.VALIDATE(ToLineRec."Shortcut Dimension 2 Code");

                ToLineRec.MODIFY;
            UNTIL pIndentLine.NEXT = 0;
        END;
        //JPL09 STOP
        //ALLE_PKS
    END;

}