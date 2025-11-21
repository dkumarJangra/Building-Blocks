page 97849 "PO Terms & Conditions"
{
    PageType = Card;
    SourceTable = "PO Terms & Conditions";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("Packaging & Forwarding"; Rec."Packaging & Forwarding")
            {

                trigger OnLookup(var Text: Text): Boolean
                begin
                    StdText.RESET;
                    StdText.SETRANGE("BBG Term Type", StdText."BBG Term Type"::"Packaging & Forwarding");
                    //IF StdText.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Standard Text Codes", StdText) = ACTION::LookupOK THEN
                        Rec."Packaging & Forwarding" := StdText.Description;
                    //END;
                end;
            }
            field("Excise Duty Comments"; Rec."Excise Duty Comments")
            {

                trigger OnLookup(var Text: Text): Boolean
                begin
                    StdText.RESET;
                    StdText.SETRANGE("BBG Term Type", StdText."BBG Term Type"::"Excise Duty");
                    //IF StdText.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Standard Text Codes", StdText) = ACTION::LookupOK THEN
                        Rec."Excise Duty Comments" := StdText.Description;
                    //END;
                end;
            }
            field("Sales Tax Comments"; Rec."Sales Tax Comments")
            {

                trigger OnLookup(var Text: Text): Boolean
                begin
                    StdText.RESET;
                    StdText.SETRANGE("BBG Term Type", StdText."BBG Term Type"::"Sales Tax");
                    //IF StdText.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Standard Text Codes", StdText) = ACTION::LookupOK THEN
                        Rec."Sales Tax Comments" := StdText.Description;
                    //END;
                end;
            }
            field("Entry Tax/Octroi Terms"; Rec."Entry Tax/Octroi Terms")
            {

                trigger OnLookup(var Text: Text): Boolean
                begin
                    StdText.RESET;
                    StdText.SETRANGE("BBG Term Type", StdText."BBG Term Type"::"Service Tax-Installation");
                    //IF StdText.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Standard Text Codes", StdText) = ACTION::LookupOK THEN
                        Rec."Entry Tax/Octroi Terms" := StdText.Description;
                    //END;
                end;
            }
            field("Freight Terms"; Rec."Freight Terms")
            {

                trigger OnLookup(var Text: Text): Boolean
                begin
                    StdText.RESET;
                    StdText.SETRANGE("BBG Term Type", StdText."BBG Term Type"::"Price Basis");
                    //IF StdText.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(0, StdText) = ACTION::LookupOK THEN
                        Rec."Freight Terms" := StdText.Description;
                    //END;
                end;
            }
            field("Service Tax"; Rec."Service Tax")
            {

                trigger OnLookup(var Text: Text): Boolean
                begin
                    StdText.RESET;
                    StdText.SETRANGE("BBG Term Type", StdText."BBG Term Type"::"Service Tax");
                    //IF StdText.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Standard Text Codes", StdText) = ACTION::LookupOK THEN
                        Rec."Service Tax" := StdText.Description;
                    //END;
                end;
            }
            field("Transit Insurance"; Rec."Transit Insurance")
            {

                trigger OnLookup(var Text: Text): Boolean
                begin
                    StdText.RESET;
                    StdText.SETRANGE("BBG Term Type", StdText."BBG Term Type"::Insurance);
                    //IF StdText.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(0, StdText) = ACTION::LookupOK THEN
                        Rec."Transit Insurance" := StdText.Description;
                    //END;
                end;
            }
            field("Installation Terms"; Rec."Installation Terms")
            {

                trigger OnLookup(var Text: Text): Boolean
                begin
                    StdText.RESET;
                    StdText.SETRANGE("BBG Term Type", StdText."BBG Term Type"::"Template-1");
                    //IF StdText.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Standard Text Codes", StdText) = ACTION::LookupOK THEN
                        Rec."Installation Terms" := StdText.Description;
                    //END;
                end;
            }
            field("Service Tax-Installation"; Rec."Service Tax-Installation")
            {

                trigger OnLookup(var Text: Text): Boolean
                begin
                    StdText.RESET;
                    StdText.SETRANGE("BBG Term Type", StdText."BBG Term Type"::"Template-2");
                    //IF StdText.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Standard Text Codes", StdText) = ACTION::LookupOK THEN
                        Rec."Service Tax-Installation" := StdText.Description;
                    //END;
                end;
            }
            field("DD Comm/Bank Charges"; Rec."DD Comm/Bank Charges")
            {

                trigger OnLookup(var Text: Text): Boolean
                begin
                    StdText.RESET;
                    StdText.SETRANGE("BBG Term Type", StdText."BBG Term Type"::Freight);
                    //IF StdText.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(0, StdText) = ACTION::LookupOK THEN
                        Rec."DD Comm/Bank Charges" := StdText.Description;
                    //END;
                end;
            }
            field("Inspection Remarks"; Rec."Inspection Remarks")
            {

                trigger OnLookup(var Text: Text): Boolean
                begin
                    StdText.RESET;
                    StdText.SETRANGE("BBG Term Type", StdText."BBG Term Type"::"Inspection Authority");
                    //IF StdText.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(0, StdText) = ACTION::LookupOK THEN
                        Rec."Inspection Remarks" := StdText.Description;
                    //END;
                end;
            }
            field("Price Basis"; Rec."Price Basis")
            {
                Caption = 'Terms & Conditions';
                trigger OnLookup(var Text: Text): Boolean
                begin
                    StdText.RESET;
                    StdText.SETRANGE("BBG Term Type", StdText."BBG Term Type"::"Entry Tax/Octroi Tax");
                    //IF StdText.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(0, StdText) = ACTION::LookupOK THEN
                        Rec."Price Basis" := StdText.Description;
                    //END;
                end;
            }
            field("Terms of Payments"; Rec."Terms of Payments")
            {

                trigger OnLookup(var Text: Text): Boolean
                begin
                    StdText.RESET;
                    StdText.SETRANGE("BBG Term Type", StdText."BBG Term Type"::Payment);
                    //IF StdText.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Standard Text Codes", StdText) = ACTION::LookupOK THEN
                        Rec."Terms of Payments" := StdText.Description;
                    //END;
                end;
            }
            field("Warranty/Guarantee Terms"; Rec."Warranty/Guarantee Terms")
            {
            }
        }
    }

    actions
    {
    }

    var
        StdText: Record "Standard Text";
}

