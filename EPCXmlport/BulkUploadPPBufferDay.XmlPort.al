xmlport 97755 "Bulk Upload PP Buffer Day"
{
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Payment Plan Details"; "Payment Plan Details")
            {
                XmlName = 'PPDetails';
                UseTemporary = true;
                fieldelement(ProjCode; "Payment Plan Details"."Project Code")
                {
                }
                fieldelement(PPCode; "Payment Plan Details"."Payment Plan Code")
                {
                }
                fieldelement(MCode; "Payment Plan Details"."Milestone Code")
                {
                }
                fieldelement(ChargeCode; "Payment Plan Details"."Charge Code")
                {
                }
                fieldelement(DocNo; "Payment Plan Details"."Document No.")
                {
                }
                fieldelement(SalesLease; "Payment Plan Details"."Sale/Lease")
                {
                }
                fieldelement(SPPlan; "Payment Plan Details"."Sub Payment Plan")
                {
                }
                fieldelement(BufferDays; "Payment Plan Details"."Buffer Days for AutoPlot Vacat")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    PaymentPlanDetails.RESET;
                    PaymentPlanDetails.SETRANGE("Project Code", "Payment Plan Details"."Project Code");
                    PaymentPlanDetails.SETRANGE("Payment Plan Code", "Payment Plan Details"."Payment Plan Code");
                    PaymentPlanDetails.SETRANGE("Milestone Code", "Payment Plan Details"."Milestone Code");
                    PaymentPlanDetails.SETRANGE("Charge Code", "Payment Plan Details"."Charge Code");
                    PaymentPlanDetails.SETRANGE("Document No.", "Payment Plan Details"."Document No.");
                    PaymentPlanDetails.SETRANGE("Sale/Lease", "Payment Plan Details"."Sale/Lease");
                    PaymentPlanDetails.SETRANGE("Sub Payment Plan", "Payment Plan Details"."Sub Payment Plan");
                    IF PaymentPlanDetails.FINDFIRST THEN BEGIN
                        PaymentPlanDetails."Buffer Days for AutoPlot Vacat" := "Payment Plan Details"."Buffer Days for AutoPlot Vacat";
                        PaymentPlanDetails.MODIFY;
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        MESSAGE('Done');
    end;

    var
        GoldCoinHdr: Record "Gold Coin Hdr";
        PloteSize1: Decimal;
        EffectiveDAte1: Date;
        PCode1: Code[20];
        ItemCode1: Code[20];
        MinNoofGoldCoin1: Integer;
        GoldCoinonFullPmt1: Integer;
        DueDaysforMinGoldCoin1: DateFormula;
        DimValue: Record "Dimension Value";
        LedgerSsetup: Record "General ledger setup";
        Loc: Record "Location";
        Resp: Record "Responsibility Center";
        PName: Text[60];
        BranchCode: Code[20];
        BranchName: Text[60];
        Item: Record Item;
        PaymentPlanDetails: Record "Payment Plan Details";
}

