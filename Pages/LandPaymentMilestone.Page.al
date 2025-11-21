page 50159 "Land Payment Milestone"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Land Vendor Payment Terms Line";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Land Document No."; Rec."Land Document No.")
                {
                    Editable = false;
                }
                field("Land Value"; Rec."Land Value")
                {
                }
                field("Fixed Amount"; Rec."Fixed Amount")
                {
                }
                field("Payment Term Code"; Rec."Payment Term Code")
                {
                }
                field("Actual Milestone"; Rec."Actual Milestone")
                {
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                }
                field("Calculation Value"; Rec."Calculation Value")
                {
                }
                field("Due Date Calculation"; Rec."Due Date Calculation")
                {
                }
                field("Due Amount"; Rec."Due Amount")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Payment Type"; Rec."Payment Type")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Allot Payment Milestone")
            {

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to Allot Payment Milestone') THEN BEGIN
                        LandDocumentMasterLine.RESET;
                        LandDocumentMasterLine.SETRANGE("Document No.", Rec."Land Document No.");
                        IF LandDocumentMasterLine.FINDSET THEN
                            REPEAT
                                v_LandVendorPaymentTermsLine.RESET;
                                v_LandVendorPaymentTermsLine.SETRANGE("Land Document No.", Rec."Land Document No.");
                                v_LandVendorPaymentTermsLine.SETRANGE("Vendor No.", LandDocumentMasterLine."Vendor Code");
                                v_LandVendorPaymentTermsLine.SETRANGE("Land Document Line No.", LandDocumentMasterLine."Line No.");
                                IF v_LandVendorPaymentTermsLine.FINDSET THEN
                                    REPEAT
                                        v_LandVendorPaymentTermsLine.DELETEALL;
                                    UNTIL v_LandVendorPaymentTermsLine.NEXT = 0;

                                LandVendorPaymentTermsLine.RESET;
                                LandVendorPaymentTermsLine.SETRANGE("Land Document No.", Rec."Land Document No.");
                                LandVendorPaymentTermsLine.SETRANGE("Vendor No.", '');
                                IF LandVendorPaymentTermsLine.FINDSET THEN
                                    REPEAT
                                        v_LandVendorPaymentTermsLine.INIT;
                                        v_LandVendorPaymentTermsLine.TRANSFERFIELDS(LandVendorPaymentTermsLine);
                                        v_LandVendorPaymentTermsLine."Vendor No." := LandDocumentMasterLine."Vendor Code";
                                        v_LandVendorPaymentTermsLine."Land Document Line No." := LandDocumentMasterLine."Line No.";
                                        IF LandVendorPaymentTermsLine."Fixed Amount" = 0 THEN
                                            v_LandVendorPaymentTermsLine."Due Amount" := (LandDocumentMasterLine."Land Value" * LandVendorPaymentTermsLine."Calculation Value" / 100);
                                        v_LandVendorPaymentTermsLine.INSERT;
                                    UNTIL LandVendorPaymentTermsLine.NEXT = 0;
                            UNTIL LandDocumentMasterLine.NEXT = 0;
                        MESSAGE('%1', 'Updated');
                    END;
                end;
            }
        }
    }

    var
        LandVendorPaymentTermsLine: Record "Land Vendor Payment Terms Line";
        v_LandVendorPaymentTermsLine: Record "Land Vendor Payment Terms Line";
        LandDocumentMasterLine: Record "Land Agreement Line";
}

