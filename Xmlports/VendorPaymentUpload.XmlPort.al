xmlport 50061 "Vendor Payment Upload"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Integer';
                textelement(VendorCode)
                {
                }
                textelement(PostingDate1)
                {
                }
                textelement(Amt1)
                {
                }
                textelement(BankCode)
                {
                }
                textelement(ChqNo)
                {
                }
                textelement(CheqDate1)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    IF Amt1 <> '' THEN
                        EVALUATE(Amt, Amt1);



                    PostedDocNo := '';
                    USERSETUP.GET(USERID);
                    BondSetup.GET;
                    BondSetup.TESTFIELD("Voucher No. Series");
                    PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Voucher No. Series", WORKDATE, TRUE);

                    AssociatePaymentHdr.INIT;
                    AssociatePaymentHdr."Document No." := PostedDocNo;
                    AssociatePaymentHdr."Line No." := LineNo + 10000;
                    AssociatePaymentHdr."Associate Code" := VendorCode;
                    IF Vend.GET(VendorCode) THEN;
                    AssociatePaymentHdr."Associate Name" := Vend.Name;
                    AssociatePaymentHdr."Company Name" := COMPANYNAME;
                    AssociatePaymentHdr.Type := AssociatePaymentHdr.Type::Commission;
                    AssociatePaymentHdr."Posting Type" := AssociatePaymentHdr."Posting Type"::ComAndTA;
                    AssociatePaymentHdr."User ID" := USERID;
                    AssociatePaymentHdr."User Branch Code" := USERSETUP."User Branch";
                    EVALUATE(PostingDate, PostingDate1);
                    AssociatePaymentHdr."Posting Date" := PostingDate;
                    AssociatePaymentHdr."Document Date" := WORKDATE;
                    AssociatePaymentHdr."Line Type" := AssociatePaymentHdr."Line Type"::Header;
                    AssociatePaymentHdr."Cut-off Date" := WORKDATE;
                    AssociatePaymentHdr."Eligible Amount" := Amt;
                    AssociatePaymentHdr."Posted on LLP Company" := TRUE;
                    AssociatePaymentHdr."Payable Amount" := Amt;
                    AssociatePaymentHdr."Net Payable (As per Actual)" := Amt;
                    AssociatePaymentHdr."Sub Type" := AssociatePaymentHdr."Sub Type"::Regular;
                    AssociatePaymentHdr."Line Type" := AssociatePaymentHdr."Line Type"::Header;
                    AssociatePaymentHdr."From MS Company" := TRUE;
                    AssociatePaymentHdr."Amt applicable for Payment" := Amt;
                    AssociatePaymentHdr."Payment Mode" := AssociatePaymentHdr."Payment Mode"::Bank;
                    AssociatePaymentHdr."Bank/G L Code" := BankCode;
                    BankACC.RESET;
                    IF BankACC.GET(AssociatePaymentHdr."Bank/G L Code") THEN
                        AssociatePaymentHdr."Bank/G L Name" := BankACC.Name
                    ELSE
                        AssociatePaymentHdr."Bank/G L Name" := '';

                    AssociatePaymentHdr."Cheque No." := ChqNo;
                    EVALUATE(CheqDate, CheqDate1);
                    AssociatePaymentHdr."Cheque Date" := CheqDate;
                    AssociatePaymentHdr.INSERT;
                    LineNo := AssociatePaymentHdr."Line No.";
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
        MESSAGE('%1', 'Process Done');
    end;

    var
        USERSETUP: Record "User Setup";
        BondSetup: Record "Unit Setup";
        PostedDocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        AssociatePaymentHdr: Record "Associate Payment Hdr";
        TotalInvAmount_1: Decimal;
        Amt: Decimal;
        LineNo: Integer;
        Vend: Record Vendor;
        BankACC: Record "Bank Account";
        PostingDate: Date;
        CheqDate: Date;
}

