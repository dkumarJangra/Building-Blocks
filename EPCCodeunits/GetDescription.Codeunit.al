codeunit 97724 GetDescription
{
    // BBG1.00 ALLEDK 060313 change the variable Data type


    trigger OnRun()
    begin
    end;

    var
        VendorChain: Record Vendor;
        Text001: Label 'Counter %1 is Blocked.';


    procedure GetSchemeDesc(SchemeCode: Code[20]; Version: Integer): Text[50]
    var
        SchemeHeader: Record "Document Type Initiator";
    begin
        //IF SchemeHeader.GET(SchemeCode,Version) THEN
        //EXIT(SchemeHeader."CC Mail - User Code");
    end;


    procedure GetVendorName(VendorCode: Code[20]): Text[50]
    var
        Vendor: Record Vendor;
    begin
        IF Vendor.GET(VendorCode) THEN
            EXIT(Vendor.Name);
    end;


    procedure GetDuration(BondDuration: Option " ","12","36","72","75","84","120","300"): Integer
    begin
        CASE BondDuration OF
            1:
                EXIT(36);
            2:
                EXIT(60);
            3:
                EXIT(72);
            4:
                EXIT(75);
            5:
                EXIT(84);
            6:
                EXIT(120);
            7:
                EXIT(300);
        END;
    end;


    procedure GetBondDuration(BondDuration: Option " ","12","36","72","75","84","120","300"): Integer
    begin
        CASE BondDuration OF
            36:
                EXIT(1);
            60:
                EXIT(2);
            72:
                EXIT(3);
            75:
                EXIT(4);
            84:
                EXIT(5);
            120:
                EXIT(6);
            300:
                EXIT(7);
        END;
    end;


    procedure GetDimensionName(DimCode: Code[20]; No: Integer): Text[50]
    var
        DimensionValue: Record "Dimension Value";
    begin
        DimensionValue.SETCURRENTKEY(Code, "Global Dimension No.");
        DimensionValue.SETRANGE("Global Dimension No.", No);
        DimensionValue.SETRANGE(Code, DimCode);
        IF DimensionValue.FINDFIRST THEN
            EXIT(DimensionValue.Name);
    end;


    procedure GetPostedPaymentSchedule(BondNo: Code[20]; InvestmentType: Option " ",RD,FD,MIS): Integer
    var
        MISPaymentScheduleBuffer: Record "Project Budget Line Buffer";
        RDPaymentScheduleBuffer: Record "Template Field";
    begin
        /*IF InvestmentType = InvestmentType::RD THEN BEGIN
          RDPaymentSchedulePosted.SETRANGE("Bond No.",BondNo);
          RDPaymentSchedulePosted.SETRANGE("Entry Type",RDPaymentSchedulePosted."Entry Type"::"1");
          RDPaymentScheduleBuffer.SETRANGE("Template Name",BondNo);
          RDPaymentScheduleBuffer.SETRANGE(Status,RDPaymentScheduleBuffer.Status::"1");
          EXIT(RDPaymentSchedulePosted.COUNT + RDPaymentScheduleBuffer.COUNT);
        END ELSE IF InvestmentType = InvestmentType::MIS THEN BEGIN
          MISPaymentSchedulePosted.SETRANGE("Bond No.",BondNo);
          MISPaymentSchedulePosted.SETRANGE("Entry Type",MISPaymentSchedulePosted."Entry Type"::"2");
          MISPaymentScheduleBuffer.SETRANGE("Job No.",BondNo);
          MISPaymentScheduleBuffer.SETRANGE("User ID",MISPaymentScheduleBuffer."User ID"::"2");
          EXIT(MISPaymentSchedulePosted.COUNT + MISPaymentScheduleBuffer.COUNT);
        END;
         */

    end;


    procedure GetPaymentSchedule(BondNo: Code[20]; InvestmentType: Option " ",RD,FD,MIS): Integer
    var
        RDPaymentSchedule: Record Terms;
        MISPaymentScheduleBuffer: Record "Project Budget Line Buffer";
        RDPaymentScheduleBuffer: Record "Template Field";
        RDPaymentScheduleBuffer2: Record "Template Field";
    begin
        /*IF InvestmentType = InvestmentType::RD THEN BEGIN
          RDPaymentSchedule.SETRANGE("Document Type",BondNo);
          RDPaymentSchedule.SETRANGE(Stopped,FALSE);
          RDPaymentScheduleBuffer.SETRANGE("Template Name",BondNo);
          RDPaymentScheduleBuffer.SETRANGE(Status,RDPaymentScheduleBuffer.Status::"1");
        
          RDPaymentScheduleBuffer2.SETRANGE("Template Name",BondNo);
          RDPaymentScheduleBuffer2.SETFILTER(RelationTableFieldNo,'<>%1',RDPaymentScheduleBuffer2.RelationTableFieldNo::"1");
          RDPaymentScheduleBuffer2.SETRANGE(Status,RDPaymentScheduleBuffer.Status::"1");
          RDPaymentScheduleBuffer2.SETRANGE("Cheque Status",RDPaymentScheduleBuffer2."Cheque Status"::"0");
        
          EXIT(RDPaymentSchedule.COUNT - RDPaymentScheduleBuffer.COUNT -  - RDPaymentScheduleBuffer2.COUNT);
        END ELSE IF InvestmentType = InvestmentType::MIS THEN BEGIN
          MISPaymentSchedule.RESET;
          MISPaymentScheduleBuffer.RESET;
          MISPaymentSchedule.SETRANGE("Bond No.",BondNo);
          MISPaymentSchedule.SETRANGE(Stopped,FALSE);
          MISPaymentScheduleBuffer.SETRANGE("Job No.",BondNo);
          MISPaymentScheduleBuffer.SETRANGE("User ID",MISPaymentScheduleBuffer."User ID"::"2");
          EXIT(MISPaymentSchedule.COUNT - MISPaymentScheduleBuffer.COUNT);
        END;
         */

    end;


    procedure GetCustomerName(CustomerCode: Code[20]): Text[50]
    var
        Customer: Record Customer;
    begin
        IF Customer.GET(CustomerCode) THEN
            EXIT(Customer.Name);
    end;


    procedure GetNODExist(VendorNo: Code[20]): Boolean
    var
        //NODNOCLines: Record 13785;//Need to check the code in UAT
        AllowedSections: Record "Allowed Sections";
    begin
        /*
        NODNOCLines.SETRANGE(Type, NODNOCLines.Type::Vendor);
        NODNOCLines.SETRANGE("No.", VendorNo);
        EXIT(NOT NODNOCLines.ISEMPTY);
        *///Need to check the code in UAT
        AllowedSections.SetRange("Vendor No", VendorNo);
        EXIT(NOT AllowedSections.ISEMPTY);
    end;


    procedure UpdateDescription(JournalTemplateName: Code[10]; JournalBatchName: Code[10]; DocumentNo: Code[20]; GenJournalLineNo: Integer; Narration: Text[200])
    var
        GenJournalNarration: Record "Gen. Journal Narration"; //"16549";
        LineNo: Integer;
    begin
        LineNo := 10000;
        GenJournalNarration.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJournalNarration.SETRANGE("Journal Batch Name", JournalBatchName);
        GenJournalNarration.SETRANGE("Document No.", DocumentNo);
        GenJournalNarration.SETRANGE("Gen. Journal Line No.", GenJournalLineNo);
        GenJournalNarration.SETRANGE("Line No.", 10000, 40000);
        GenJournalNarration.DELETEALL;
        GenJournalNarration.SETRANGE("Line No.");
        REPEAT
            GenJournalNarration.INIT;
            GenJournalNarration."Journal Template Name" := JournalTemplateName;
            GenJournalNarration."Journal Batch Name" := JournalBatchName;
            GenJournalNarration."Document No." := DocumentNo;
            GenJournalNarration."Gen. Journal Line No." := GenJournalLineNo;
            GenJournalNarration."Line No." := LineNo;
            GenJournalNarration.Narration := COPYSTR(Narration, 1, 50);
            GenJournalNarration.INSERT;
            Narration := COPYSTR(Narration, 51, 150);
            LineNo += 10000;
        UNTIL (LineNo > 40000) OR (Narration = '');
    end;


    procedure GetCustBankBranchName(CustomerNo: Code[20]; ApplicationNo: Code[20]): Text[50]
    var
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        IF CustomerBankAccount.GET(CustomerNo, ApplicationNo) THEN
            EXIT(CustomerBankAccount."Name 2")
        ELSE
            EXIT('');
    end;


    procedure GetCustBankAccountNo(CustomerNo: Code[20]; ApplicationNo: Code[20]): Text[30]
    var
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        IF CustomerBankAccount.GET(CustomerNo, ApplicationNo) THEN
            EXIT(CustomerBankAccount."Bank Account No.")
        ELSE
            EXIT('');
    end;


    procedure GetPaymentModeDesc(PaymentMode: Option " ",Cash,Cheque,"D.D.","Banker's Cheque","P.O.","Cheque by Post",NEFT,Stopped,"NEFT Updated"): Code[20]
    begin
        EXIT(FORMAT(PaymentMode));
    end;


    procedure GetMaturityAmount(BondNo: Code[20]): Decimal
    var
        Bond: Record "Confirmed Order";
    begin
        IF Bond.GET(BondNo) THEN
            EXIT(Bond."Maturity Amount");
        EXIT(0);
    end;


    procedure GetNoOfBankAc(CustomerNo: Code[20]): Integer
    var
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        CustomerBankAccount.SETRANGE("Customer No.", CustomerNo);
        IF CustomerBankAccount.ISEMPTY THEN
            EXIT(0)
        ELSE
            EXIT(CustomerBankAccount.COUNT);
    end;


    procedure GetRDNotClearedChq(BondNo: Code[20]; InvestmentType: Option " ",RD,FD,MIS): Integer
    var
        MISPaymentScheduleBuffer: Record "Project Budget Line Buffer";
        RDPaymentScheduleBuffer: Record "Template Field";
    begin
        //GetRDNotClearedChq
        /*IF InvestmentType = InvestmentType::RD THEN BEGIN
          RDPaymentScheduleBuffer.SETRANGE("Template Name",BondNo);
          RDPaymentScheduleBuffer.SETRANGE(Status,RDPaymentScheduleBuffer.Status::"1");
          RDPaymentScheduleBuffer.SETFILTER("Cheque No.",'<>%1','');
          RDPaymentScheduleBuffer.SETRANGE("Cheque Status",RDPaymentScheduleBuffer."Cheque Status"::"0");
          EXIT(RDPaymentScheduleBuffer.COUNT);
        END;
        EXIT(0);
         */

    end;


    procedure ValidateCounter(ShortcutDimCode: Code[20])
    var
        DimensionValue: Record "Dimension Value";
    begin
        DimensionValue.GET('COUNTER', ShortcutDimCode);
        IF DimensionValue.Blocked THEN
            ERROR(Text001, ShortcutDimCode)
    end;


    procedure GetFrequencyDesc(FrequencyInt: Integer): Code[20]
    begin
        CASE FrequencyInt OF
            1:
                EXIT('Monthly');
            3:
                EXIT('Quarterly');
            6:
                EXIT('HalfYearly');
            12:
                EXIT('Annually');
        END;
    end;


    procedure GetRankDesc(RankCode: Decimal): Text[50]
    var
        Rank: Record Rank;
    begin
        IF Rank.GET(RankCode) THEN    //BBG1.00 ALLEDK 060313
            EXIT(Rank.Description)
        ELSE
            EXIT('');
    end;


    procedure GetDimensionName1(GlobalDimension1Code: Code[20]): Text[50]
    var
        DimensionValue: Record "Dimension Value";
    begin
        DimensionValue.SETRANGE(Code, GlobalDimension1Code);
        DimensionValue.SETRANGE("Global Dimension No.", 1);
        IF DimensionValue.FINDFIRST THEN
            EXIT(DimensionValue.Name)
        ELSE
            EXIT('');
    end;


    procedure GetBankName(BankCode: Code[20]): Text[50]
    var
        BankAccount: Record "Bank Account";
    begin
        IF BankAccount.GET(BankCode) THEN
            EXIT(BankAccount.Name)
        ELSE
            EXIT('');
    end;


    procedure GetDocomentDate(): Date
    var
        BondSetup: Record "Unit Setup";
    begin
        BondSetup.GET;
        IF BondSetup."Allow Backdated Posting" THEN
            EXIT(BondSetup."Document Date")
        ELSE
            EXIT(TODAY);
    end;
}

