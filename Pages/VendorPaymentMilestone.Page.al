page 50158 "Vendor Payment Milestone"
{
    AutoSplitKey = true;
    Editable = false;
    InsertAllowed = false;
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
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Allow Payment"; Rec."Allow Payment")
                {
                }
                field("Land Document Line No."; Rec."Land Document Line No.")
                {
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Vendor Land Value"; Rec."Vendor Land Value")
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
                field("Payment Released Amount"; Rec."Payment Released Amount")
                {
                }
                field("Balance Amount"; Rec."Due Amount" - Rec."Payment Released Amount")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Release)
            {

                trigger OnAction()
                begin
                    LandVendorPaymentTermsLine.RESET;
                    LandVendorPaymentTermsLine.SETRANGE("Land Document No.", Rec."Land Document No.");
                    LandVendorPaymentTermsLine.SETRANGE("Vendor No.", Rec."Vendor No.");
                    IF LandVendorPaymentTermsLine.FINDSET THEN
                        REPEAT
                            LandVendorPaymentTermsLine.Status := LandVendorPaymentTermsLine.Status::Release;
                            LandVendorPaymentTermsLine.MODIFY;
                        UNTIL LandVendorPaymentTermsLine.NEXT = 0;

                    MESSAGE('%1', 'Document Released');
                end;
            }
            action("Re-Open")
            {

                trigger OnAction()
                begin
                    LandVendorPaymentTermsLine.RESET;
                    LandVendorPaymentTermsLine.SETRANGE("Land Document No.", Rec."Land Document No.");
                    LandVendorPaymentTermsLine.SETRANGE("Vendor No.", Rec."Vendor No.");
                    IF LandVendorPaymentTermsLine.FINDSET THEN
                        REPEAT
                            LandVendorPaymentTermsLine.Status := LandVendorPaymentTermsLine.Status::Open;
                            LandVendorPaymentTermsLine.MODIFY;
                        UNTIL LandVendorPaymentTermsLine.NEXT = 0;
                    MESSAGE('%1', 'Document Re-Open');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CALCFIELDS("Payment Released Amount");
    end;

    var
        LandVendorPaymentTermsLine: Record "Land Vendor Payment Terms Line";
}

