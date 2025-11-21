codeunit 50033 "Batch Comm/TA Invoice Creation"
{

    trigger OnRun()
    begin
        v_CommissionEntry_1.RESET;
        v_CommissionEntry_1.SETCURRENTKEY("Application No.", "Associate Code", "Commission %");
        v_CommissionEntry_1.SETRANGE(Posted, FALSE);
        v_CommissionEntry_1.SETRANGE("Opening Entries", FALSE);
        v_CommissionEntry_1.SETRANGE(Discount, FALSE);
        IF v_CommissionEntry_1.FINDSET THEN
            REPEAT
                CommBaseRcvAmt := 0;
                V_PaymentTermsLineSale.RESET;
                V_PaymentTermsLineSale.SETRANGE("Document No.", v_CommissionEntry_1."Application No.");
                V_PaymentTermsLineSale.SETRANGE("Commision Applicable", TRUE);
                IF V_PaymentTermsLineSale.FINDSET THEN
                    REPEAT
                        CommBaseRcvAmt := CommBaseRcvAmt + V_PaymentTermsLineSale."Criteria Value / Base Amount";
                    UNTIL V_PaymentTermsLineSale.NEXT = 0;

                CommEntryBaseAmount := 0;
                V_CEntry.RESET;
                V_CEntry.SETCURRENTKEY("Application No.", "Associate Code");
                V_CEntry.SETRANGE("Application No.", v_CommissionEntry_1."Application No.");
                V_CEntry.SETRANGE("Associate Code", v_CommissionEntry_1."Associate Code");
                V_CEntry.SETRANGE("Direct to Associate", FALSE);
                V_CEntry.SETRANGE("Remaining Amt of Direct", FALSE);
                V_CEntry.SETRANGE("Opening Entries", FALSE);
                V_CEntry.SETRANGE(Discount, FALSE);
                IF V_CEntry.FINDSET THEN
                    REPEAT
                        CommEntryBaseAmount := CommEntryBaseAmount + V_CEntry."Base Amount";
                    UNTIL V_CEntry.NEXT = 0;

                AllowInvoicing := TRUE;
                CommissionDifference := 0;

                CommissionDifference := CommBaseRcvAmt - CommEntryBaseAmount;

                IF CommBaseRcvAmt > CommEntryBaseAmount THEN
                    AllowInvoicing := TRUE
                ELSE
                    IF ABS(CommissionDifference) > 2 THEN
                        AllowInvoicing := FALSE;


                IF AllowInvoicing THEN BEGIN
                    CommAmount := 0;
                    Vendor_1.RESET;
                    IF Vendor_1.GET(v_CommissionEntry_1."Associate Code") THEN
                        IF NOT Vendor_1."BBG Black List" THEN BEGIN
                            IF (Vendor_1."P.A.N. No." <> '') AND (Vendor_1."P.A.N. Status" = Vendor_1."P.A.N. Status"::" ") THEN BEGIN
                                UnitReversal.CreateCommCreditMemo(v_CommissionEntry_1."Application No.", FALSE);
                                COMMIT;
                            END;
                        END;
                END;
            UNTIL v_CommissionEntry_1.NEXT = 0;

        AllowInvoicing := FALSE;

        "Travel Payment Entry".RESET;
        "Travel Payment Entry".SETCURRENTKEY("Application No.", "Sub Associate Code", "Post Payment", Approved);
        "Travel Payment Entry".SETRANGE("Post Payment", FALSE);
        "Travel Payment Entry".SETFILTER("Amount to Pay", '<>%1', 0);
        "Travel Payment Entry".SETRANGE(Approved, TRUE);
        IF "Travel Payment Entry".FINDSET THEN
            REPEAT
                CreatInvoice := TRUE;
                CommAmount := 0;
                Vendor_1.RESET;
                IF Vendor_1.GET("Travel Payment Entry"."Sub Associate Code") THEN
                    IF NOT Vendor_1."BBG Black List" THEN BEGIN
                        IF (Vendor_1."P.A.N. No." <> '') AND (Vendor_1."P.A.N. Status" = Vendor_1."P.A.N. Status"::" ") THEN BEGIN
                            ////030321
                            CompanyInformation.GET;
                            /* //251121
                            IF CompanyInformation."Development Company Name" = COMPANYNAME THEN BEGIN
                              IF Vendor_1."RERA Status" = Vendor_1."RERA Status"::Unregistered THEN
                                CreatInvoice := FALSE;
                            END;
                            */
                            CreatInvoice := TRUE;  //251121
                                                   //030321
                            IF CreatInvoice THEN BEGIN     //030321

                                TPEntry_1.RESET;
                                TPEntry_1.SETRANGE("Document No.", "Travel Payment Entry"."Document No.");
                                TPEntry_1.SETRANGE("Line No.", "Travel Payment Entry"."Line No.");
                                TPEntry_1.SETRANGE("Post Payment", FALSE);
                                IF TPEntry_1.FINDSET THEN BEGIN
                                    CommAmount := CommAmount + TPEntry_1."Amount to Pay";
                                    TPEntry_1."Post Payment" := TRUE;
                                    TPEntry_1."Pmt User ID" := USERID;
                                    TPEntry_1."Pmt Date Time" := CURRENTDATETIME;
                                    TPEntry_1."Invoice Date" := TODAY;
                                    TPEntry_1.MODIFY;
                                END;
                                Type_1 := Type_1::TA;

                                IF CommAmount <> 0 THEN BEGIN
                                    IF CommAmount > 0 THEN
                                        CreateCommInvoice.CreateVoucherHeader("Travel Payment Entry"."Sub Associate Code", CommAmount, Type_1, WORKDATE, "Travel Payment Entry"."Application No.", "Travel Payment Entry"."Project Code")
                                    ELSE
                                        UnitReversal.PostTACreditMemo("Travel Payment Entry"."Sub Associate Code", CommAmount, TRUE, WORKDATE, "Travel Payment Entry"."Application No.", "Travel Payment Entry"."Project Code");
                                END;
                            END;  //030321
                        END;
                    END;
            UNTIL "Travel Payment Entry".NEXT = 0;

    end;

    var
        Vendor_1: Record Vendor;
        CommAmount: Decimal;
        InvCommEntry_1: Record "Commission Entry";
        RecConforder: Record "Confirmed Order";
        Type_1: Option " ",Incentive,Commission,TA,ComAndTA;
        CreateCommInvoice: Codeunit "UpdateCharges /Post/Rev AssPmt";
        UnitReversal: Codeunit "Unit Reversal";
        TPEntryDetails: Record "Travel Payment Details";
        TPEntry_1: Record "Travel Payment Entry";
        CEntry: Record "Commission Entry";
        LCommAmount: Decimal;
        v_ConfOrder: Record "Confirmed Order";
        PaymentTermsLineSale: Record "Payment Terms Line Sale";
        V_PaymentTermsLineSale: Record "Payment Terms Line Sale";
        CommBaseRcvAmt: Decimal;
        CommEntryBaseAmount: Decimal;
        V_CEntry: Record "Commission Entry";
        v_CommissionEntry_1: Record "Commission Entry";
        CommissionDifference: Decimal;
        CreatInvoice: Boolean;
        AllowInvoicing: Boolean;
        "Travel Payment Entry": Record "Travel Payment Entry";
        CompanyInformation: Record "Company Information";
}

