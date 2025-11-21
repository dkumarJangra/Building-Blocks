report 50094 "Generate Travel hierarchy"
{
    // version Done

    ProcessingOnly = true;
    UseRequestPage = false;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));

            trigger OnAfterGetRecord()
            begin
                IF Number = 1 THEN
                    Chain.FIND('-')
                ELSE
                    Chain.NEXT;
                CLEAR(Vend);
                Designation := '';

                IF Vend.GET(RegionCode1, Chain."No.") THEN;

                UnitSetup.GET;
                IF Chain."Rank Code" > UnitSetup."Hierarchy Head" THEN
                    CurrReport.SKIP
                ELSE BEGIN

                    SlNo += 1;

                    SNo := SNo;
                    UnitSetup.GET;
                    //DocNo := NoSeriesMgt.GetNextNo(UnitSetup."Travel No. Series",WORKDATE,TRUE);

                    TravelPayDetails.RESET;
                    TravelPayDetails.SETRANGE("Document No.", DocNo);
                    IF TravelPayDetails.FINDSET THEN
                        REPEAT
                            TravelPayDetails.TESTFIELD("Project Code");
                            TravelPaymentEntry1.INIT;
                            TravelPaymentEntry1."Document No." := DocNo;
                            TravelPaymentEntry1."Line No." := SNo + 10000;
                            TravelPaymentEntry1.VALIDATE("Project Code", PCode);
                            TravelPaymentEntry1.VALIDATE("Team Lead", AssociateCode);
                            TravelPaymentEntry1.VALIDATE("Sub Associate Code", Chain."No.");
                            TravelPaymentEntry1.VALIDATE("Parent Code", Chain."Parent Code");
                            //TravelPaymentEntry1."Activity Break down Str" := Chain."E-Mail";
                            TravelPaymentEntry1."Creation Date" := TODAY;
                            TravelPaymentEntry1."Project Code" := TravelPayDetails."Project Code";
                            TravelPaymentEntry1.Month := Month1;
                            TravelPaymentEntry1.Year := Year1;
                            TravelPaymentEntry1."Application No." := TravelPayDetails."Application No.";
                            TravelPaymentEntry1."Total Area" := TravelPayDetails."Saleable Area";
                            TravelPaymentEntry1."Appl. Not Show on Travel Form" := TRUE;
                            TravelPaymentEntry1.INSERT;
                            SNo := TravelPaymentEntry1."Line No.";
                        UNTIL TravelPayDetails.NEXT = 0;
                    FindEntry := TRUE;
                END;



                IF Vend2.GET(RegionCode1, Chain."No.") THEN
                    VendStatus := Vend2.Status;
            end;

            trigger OnPreDataItem()
            begin
                ChainMgt.NewInitChain;
                ChainMgt.NewChainFromToUp(AssociateCode, TODAY, FALSE, RegionCode1);
                ChainMgt.NewUpdateChainRank(TODAY, RegionCode1);
                ChainMgt.NewReturnChain(Chain);
                Chain.SETCURRENTKEY("Rank Code");
                Chain.ASCENDING(FALSE);
                SETRANGE(Number, 1, Chain.COUNT);

                FindEntry := FALSE;
            end;
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

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    trigger OnPostReport()
    var
        TPEntry_1: Record "Travel Payment Entry";
        Vendor_2: Record Vendor;
    begin
        IF FindEntry THEN BEGIN
            TravelPaymentEntry1.INIT;
            TravelPaymentEntry1."Document No." := DocNo;
            TravelPaymentEntry1."Line No." := SNo + 1000;
            TravelPaymentEntry1.VALIDATE("Project Code", PCode);
            //TravelPaymentEntry1.VALIDATE("Team Lead",AssociateCode);
            Vendor_2.RESET;
            IF Vendor_2.GET(AssociateCode) THEN BEGIN
                IF Vendor_2."BBG Vendor Category" = Vendor_2."BBG Vendor Category"::"CP(Channel Partner)" THEN
                    TravelPaymentEntry1.VALIDATE("Sub Associate Code", 'CP99999999')
                ELSE
                    TravelPaymentEntry1.VALIDATE("Sub Associate Code", 'IBA9999999');
            END;
            //TravelPaymentEntry1.VALIDATE("Sub Associate Code",'IBA9999999');
            //TravelPaymentEntry1.VALIDATE("Parent Code",Chain."Parent Code");
            //TravelPaymentEntry1."Activity Break down Str" := Chain."E-Mail";
            TravelPaymentEntry1."Creation Date" := TODAY;
            TravelPaymentEntry1.Month := Month1;
            TravelPaymentEntry1.Year := Year1;
            TravelPaymentEntry1."Appl. Not Show on Travel Form" := FALSE;
            TravelPaymentEntry1.INSERT;
        END;
        SubAssCode := '';
        TPEntry_1.RESET;
        TPEntry_1.SETCURRENTKEY("Sub Associate Code");
        TPEntry_1.SETRANGE("Document No.", DocNo);
        IF TPEntry_1.FINDSET THEN
            REPEAT
                IF SubAssCode <> TPEntry_1."Sub Associate Code" THEN BEGIN
                    SubAssCode := TPEntry_1."Sub Associate Code";
                    TPEntry_1."Appl. Not Show on Travel Form" := FALSE;
                    TPEntry_1.MODIFY;
                END;
            UNTIL TPEntry_1.NEXT = 0
    end;

    trigger OnPreReport()
    begin
        IF AssociateCode = '' THEN
            ERROR(Text000);
    end;

    var
        CompanyInfo: Record "Company Information";
        Filters: Text[30];
        AssociateCode: Code[20];
        ChainMgt: Codeunit "Unit Post";
        Chain: Record "Region wise Vendor" temporary;
        LastRank: Integer;
        Vend: Record "Region wise Vendor";
        GetDesc: Codeunit GetDescription;
        SlNo: Integer;
        Rank: Record Rank;
        Designation: Text[30];
        Vend2: Record "Region wise Vendor";
        VendStatus: Option " ",Provisional,Active,Inactive;
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UnitSetup: Record "Unit Setup";
        TravelPaymentEntry1: Record "Travel Payment Entry";
        SNo: Integer;
        PCode: Code[20];
        ToDate: Date;
        StDate: Date;
        Month1: Integer;
        Year1: Integer;
        FindEntry: Boolean;
        RegionCode1: Code[10];
        TravelPayDetails: Record "Travel Payment Details";
        SubAssCode: Code[20];
        Text000: Label 'Invalid Parameters.';

    procedure InitializeValues(var CustomerNoFilter: Code[20]; var StartDate: Date; var EndDate: Date; var ProjectCode: Code[20]; var TADocNo: Code[20]; var Month: Integer; var Year: Integer; RegionCode: Code[10])
    begin
        // BBG1.01 261012 START
        AssociateCode := CustomerNoFilter;
        PCode := ProjectCode;
        StDate := StartDate;
        ToDate := EndDate;
        DocNo := TADocNo;
        Month1 := Month;
        Year1 := Year;
        RegionCode1 := RegionCode;
        // BBG1.01 261012 END
    end;
}

