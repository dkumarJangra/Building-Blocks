report 50036 "Plot Vacate Auto Batch"
{
    // version Done

    //  DefaultLayout = RDLC;
    //    RDLCLayout = './Reports/Plot Vacate Auto Batch.rdl';
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("New Confirmed Order"; "New Confirmed Order")
        {
            DataItemTableView = WHERE(Status = FILTER(Open | Vacate));

            trigger OnAfterGetRecord()
            var
                FindCompany: Boolean;
                ResponsibilityCenter_1: Record "Responsibility Center 1";
                UnitMaster_1: Record "Unit Master";
                UnitMaster_2: Record "Unit Master";
                JobRec_1: Record Job;
                RecUnitMaster: Record "Unit Master";
                Versn: Integer;
                DocMaster: Record "Document Master";
                ToDoctMaster1: Record "Document Master";
                ToDoctMaster: Record "Document Master";
                FromDocMaster1: Record "Document Master";
                ArchUnitMaster: Record "Archive Unit Master";
            begin

                //IF CONFIRM('Do you want vacate this Unit -'+ "Unit Code",TRUE) THEN BEGIN
                TESTFIELD(Type, Type::Normal);
                CALCFIELDS("Amount Received");
                CALCFIELDS("Total Received Amount");
                CALCFIELDS("Amount Refunded");
                AppPayentry_2.RESET;
                AppPayentry_2.SETRANGE("Document No.", "No.");
                AppPayentry_2.SETRANGE("Cheque Status", AppPayentry_2."Cheque Status"::" ");
                IF AppPayentry_2.FINDFIRST THEN
                    ERROR('Receipt entry should be cleared Or Bounced for Application No. -' + "No.");

                RecConfORder.RESET;
                RecConfORder.CHANGECOMPANY("Company Name");
                RecConfORder.SETRANGE("No.", "No.");
                IF NOT RecConfORder.FINDFIRST THEN
                    CurrReport.SKIP
                ELSE BEGIN
                    IF NOT Forcefullvacate THEN BEGIN

                        PaymentTermsLineSale.RESET;
                        PaymentTermsLineSale.CHANGECOMPANY("Company Name");
                        PaymentTermsLineSale.SETRANGE("Document No.", "No.");
                        PaymentTermsLineSale.SETRANGE("Due Date", 20010101D, (TODAY - 1));//010101D
                        IF PaymentTermsLineSale.FINDLAST THEN BEGIN
                            EleDate := 0D;
                            TotalAmt := 0;
                            EleDate := CALCDATE(PaymentTermsLineSale."Buffer Days", PaymentTermsLineSale."Due Date");
                            PTLineSale.RESET;
                            PTLineSale.CHANGECOMPANY("Company Name");
                            PTLineSale.SETRANGE("Document No.", "No.");
                            PTLineSale.SETRANGE("Due Date", 0D, (TODAY - 1));
                            IF PTLineSale.FINDSET THEN
                                REPEAT
                                    TotalAmt := TotalAmt + PTLineSale."Due Amount";
                                UNTIL PTLineSale.NEXT = 0;
                        END;

                        IF TODAY >= EleDate THEN BEGIN
                            IF TotalAmt > "Total Received Amount" THEN BEGIN
                                ConfOrder.RESET;
                                ConfOrder.CHANGECOMPANY("Company Name");
                                ConfOrder.SETRANGE("No.", "No.");
                                IF ConfOrder.FINDFIRST THEN BEGIN
                                    ArchiveConfirmedOrder.RESET;
                                    ArchiveConfirmedOrder.CHANGECOMPANY("Company Name");
                                    ArchiveConfirmedOrder.SETRANGE("No.", "No.");
                                    IF ArchiveConfirmedOrder.FINDLAST THEN
                                        LastVersion := ArchiveConfirmedOrder."Version No."
                                    ELSE
                                        LastVersion := 0;
                                    ArchiveConfirmedOrder.INIT;
                                    ArchiveConfirmedOrder.TRANSFERFIELDS(ConfOrder);
                                    ArchiveConfirmedOrder."Version No." := LastVersion + 1;
                                    ArchiveConfirmedOrder."Amount Received" := "Amount Received";
                                    ArchiveConfirmedOrder.INSERT;
                                END;
                                UnitCode_1 := '';
                                UnitCode_1 := "Unit Code";
                                "Unit Code" := '';
                                //                                MODIFY;

                                IF UnitCode_1 <> '' THEN BEGIN
                                    IF Unitmaster.GET(UnitCode_1) THEN BEGIN
                                        ArchUnitMaster.RESET;
                                        ArchUnitMaster.SETCURRENTKEY("Project Code", "No.", Version);
                                        ArchUnitMaster.SETRANGE("No.", UnitCode_1);
                                        IF ArchUnitMaster.FINDLAST THEN
                                            Versn := ArchUnitMaster.Version
                                        ELSE
                                            Versn := 0;

                                        ArchUnitMaster.INIT;
                                        ArchUnitMaster.TRANSFERFIELDS(Unitmaster);
                                        ArchUnitMaster.Version := Versn + 1;
                                        ArchUnitMaster."User ID" := USERID;
                                        ArchUnitMaster."Archive Date" := TODAY;
                                        ArchUnitMaster."Archive Time" := TIME;
                                        ArchUnitMaster.INSERT;

                                        Unitmaster.Freeze := FALSE;
                                        Unitmaster.Status := Unitmaster.Status::Open;
                                        Unitmaster."Web Portal Status" := Unitmaster."Web Portal Status"::Available;
                                        // Unitmaster.VALIDATE(Status,Status::Open);
                                        Unitmaster."Plot Cost" := 0;
                                        Unitmaster."Customer Code" := '';
                                        Unitmaster."Customer Name" := '';
                                        Unitmaster."Registration No." := '';
                                        //Unitmaster."Company Name" := 'BBG India Developers LLP';  //code commented 08092025
                                        Unitmaster.MODIFY;
                                    END;
                                END;
                                Status := Status::Vacate;
                                MODIFY;



                                ConfOrder.RESET;
                                ConfOrder.CHANGECOMPANY("Company Name");
                                ConfOrder.SETRANGE("No.", "No.");
                                IF ConfOrder.FINDFIRST THEN BEGIN
                                    ConfOrder.Status := ConfOrder.Status::Vacate;
                                    ConfOrder."Unit Code" := '';
                                    ConfOrder."Project change Comment" := 'Payment Lag';
                                    ConfOrder."Last Unit Vacated By" := USERID;    //121021
                                    ConfOrder."Last Unit Vacate Date_Time" := CURRENTDATETIME;  //121021

                                    ConfOrder.MODIFY;
                                END;

                                RecUnitMaster.RESET;
                                RecUnitMaster.SETRANGE("No.", UnitCode_1);
                                RecUnitMaster.SETRANGE(Status, RecUnitMaster.Status::Open);
                                IF RecUnitMaster.FINDSET THEN
                                    REPEAT
                                        IF NOT CheckRates(UnitCode_1, RecUnitMaster."Project Code") THEN BEGIN

                                            ArchDocMaster.RESET;
                                            ArchDocMaster.SETRANGE("Unit Code", RecUnitMaster."No.");
                                            ArchDocMaster.SETFILTER(Code, '<>%1', 'OTH');
                                            IF ArchDocMaster.FINDLAST THEN
                                                Versn := ArchDocMaster.Version
                                            ELSE
                                                Versn := 0;

                                            DocMaster.RESET;
                                            DocMaster.SETRANGE("Unit Code", RecUnitMaster."No.");
                                            DocMaster.SETRANGE("Project Code", RecUnitMaster."Project Code");
                                            IF DocMaster.FINDSET THEN
                                                REPEAT
                                                    DocumentMaster.RESET;
                                                    DocumentMaster.SETRANGE("Document Type", DocMaster."Document Type");
                                                    DocumentMaster.SETRANGE("Project Code", DocMaster."Project Code");
                                                    DocumentMaster.SETRANGE(Code, DocMaster.Code);
                                                    DocumentMaster.SETRANGE("Sale/Lease", DocMaster."Sale/Lease");
                                                    DocumentMaster.SETRANGE("Unit Code", DocMaster."Unit Code");
                                                    DocumentMaster.SETRANGE("App. Charge Code", DocMaster."App. Charge Code");
                                                    IF DocumentMaster.FINDSET THEN BEGIN
                                                        ArchDocMaster.INIT;
                                                        ArchDocMaster.TRANSFERFIELDS(DocumentMaster);
                                                        ArchDocMaster.Version := Versn + 1;
                                                        ArchDocMaster."User ID" := USERID;
                                                        ArchDocMaster."Archive Date" := TODAY;
                                                        ArchDocMaster.INSERT;
                                                    END;
                                                UNTIL DocMaster.NEXT = 0;

                                            ToDoctMaster1.RESET;
                                            ToDoctMaster1.SETRANGE("Document Type", ToDoctMaster1."Document Type"::Charge);
                                            ToDoctMaster1.SETRANGE("Project Code", Unitmaster."Project Code");
                                            ToDoctMaster1.SETRANGE("Unit Code", RecUnitMaster."No.");
                                            ToDoctMaster1.SETFILTER(Code, '<>%1', 'BSP3');
                                            ToDoctMaster1.SETRANGE("App. Charge Code", FromDocMaster1."App. Charge Code");
                                            IF ToDoctMaster1.FINDSET THEN
                                                REPEAT
                                                    ToDoctMaster1.DELETE;
                                                UNTIL ToDoctMaster1.NEXT = 0;


                                            FromDocMaster1.RESET;
                                            FromDocMaster1.SETRANGE("Document Type", FromDocMaster1."Document Type"::Charge);
                                            FromDocMaster1.SETRANGE("Project Code", RecUnitMaster."Project Code");
                                            FromDocMaster1.SETRANGE("Unit Code", '');
                                            FromDocMaster1.SETRANGE("Sub Payment Plan", FALSE);
                                            IF FromDocMaster1.FINDFIRST THEN
                                                REPEAT
                                                    ToDoctMaster1.RESET;
                                                    ToDoctMaster1.SETRANGE("Document Type", ToDoctMaster1."Document Type"::Charge);
                                                    ToDoctMaster1.SETRANGE("Project Code", RecUnitMaster."Project Code");
                                                    ToDoctMaster1.SETRANGE("Unit Code", RecUnitMaster."No.");
                                                    ToDoctMaster1.SETRANGE(Code, FromDocMaster1.Code);
                                                    ToDoctMaster1.SETRANGE("App. Charge Code", FromDocMaster1."App. Charge Code");
                                                    IF ToDoctMaster1.FINDFIRST THEN BEGIN
                                                        ToDoctMaster1."Sale/Lease" := FromDocMaster1."Sale/Lease";
                                                        ToDoctMaster1."Unit Code" := RecUnitMaster."No.";
                                                        ToDoctMaster1.Description := FromDocMaster1.Description;
                                                        IF FromDocMaster1."Rate/Sq. Yd" <> 0 THEN
                                                            ToDoctMaster1.VALIDATE("Rate/Sq. Yd", FromDocMaster1."Rate/Sq. Yd");
                                                        IF FromDocMaster1."Rate/Sq. Yd" = 0 THEN
                                                            ToDoctMaster1.VALIDATE("Fixed Price", FromDocMaster1."Fixed Price");
                                                        ToDoctMaster1."BP Dependency" := FromDocMaster1."BP Dependency";
                                                        ToDoctMaster1."Rate Not Allowed" := FromDocMaster1."Rate Not Allowed";
                                                        ToDoctMaster1."Project Price Dependency Code" := FromDocMaster1."Project Price Dependency Code";
                                                        ToDoctMaster1."Payment Plan Type" := FromDocMaster1."Payment Plan Type";
                                                        ToDoctMaster1."Commision Applicable" := FromDocMaster1."Commision Applicable";
                                                        ToDoctMaster1."Direct Associate" := FromDocMaster1."Direct Associate";
                                                        ToDoctMaster1.Sequence := FromDocMaster1.Sequence;
                                                        ToDoctMaster1."App. Charge Code" := FromDocMaster1."App. Charge Code";
                                                        ToDoctMaster1.MODIFY;
                                                    END ELSE
                                                        IF FromDocMaster1.Code <> 'BSP3' THEN BEGIN
                                                            ToDoctMaster.INIT;
                                                            ToDoctMaster."Document Type" := FromDocMaster1."Document Type";
                                                            ToDoctMaster."Project Code" := FromDocMaster1."Project Code";
                                                            ToDoctMaster.Code := FromDocMaster1.Code;
                                                            ToDoctMaster."Sale/Lease" := FromDocMaster1."Sale/Lease";
                                                            ToDoctMaster."Unit Code" := RecUnitMaster."No.";
                                                            ToDoctMaster.Description := FromDocMaster1.Description;
                                                            ToDoctMaster."Rate/Sq. Yd" := FromDocMaster1."Rate/Sq. Yd";
                                                            ToDoctMaster."Fixed Price" := FromDocMaster1."Fixed Price";
                                                            ToDoctMaster."BP Dependency" := FromDocMaster1."BP Dependency";
                                                            ToDoctMaster."Rate Not Allowed" := FromDocMaster1."Rate Not Allowed";
                                                            ToDoctMaster."Project Price Dependency Code" := FromDocMaster1."Project Price Dependency Code";
                                                            ToDoctMaster."App. Charge Code" := FromDocMaster1."App. Charge Code";
                                                            ToDoctMaster."Payment Plan Type" := FromDocMaster1."Payment Plan Type";
                                                            ToDoctMaster."Commision Applicable" := FromDocMaster1."Commision Applicable";
                                                            ToDoctMaster."Direct Associate" := FromDocMaster1."Direct Associate";
                                                            ToDoctMaster.Sequence := FromDocMaster1.Sequence;
                                                            IF FromDocMaster1."Fixed Price" = 0 THEN
                                                                ToDoctMaster."Total Charge Amount" := FromDocMaster1."Rate/Sq. Yd" * RecUnitMaster."Saleable Area"
                                                            ELSE
                                                                ToDoctMaster."Total Charge Amount" := FromDocMaster1."Fixed Price";
                                                            ToDoctMaster.Status := ToDoctMaster.Status::Release;
                                                            ToDoctMaster.INSERT(TRUE);

                                                        END;
                                                UNTIL FromDocMaster1.NEXT = 0;
                                            UpdateRoundOFF(RecUnitMaster."Project Code", RecUnitMaster."No.");
                                        END;
                                    UNTIL RecUnitMaster.NEXT = 0;
                            END;
                        END;
                    END ELSE BEGIN
                        ConfOrder.RESET;
                        ConfOrder.CHANGECOMPANY("Company Name");
                        ConfOrder.SETRANGE("No.", "No.");
                        IF ConfOrder.FINDFIRST THEN BEGIN
                            ArchiveConfirmedOrder.RESET;
                            ArchiveConfirmedOrder.CHANGECOMPANY("Company Name");
                            ArchiveConfirmedOrder.SETRANGE("No.", "No.");
                            IF ArchiveConfirmedOrder.FINDLAST THEN
                                LastVersion := ArchiveConfirmedOrder."Version No."
                            ELSE
                                LastVersion := 0;
                            ArchiveConfirmedOrder.INIT;
                            ArchiveConfirmedOrder.TRANSFERFIELDS(ConfOrder);
                            ArchiveConfirmedOrder."Version No." := LastVersion + 1;
                            ArchiveConfirmedOrder."Amount Received" := "Amount Received";
                            ArchiveConfirmedOrder.INSERT;
                        END;
                        UnitCode_1 := '';
                        UnitCode_1 := "Unit Code";


                        "Unit Code" := '';
                        Status := Status::Vacate;
                        MODIFY;

                        //MODIFY;

                        IF UnitCode_1 <> '' THEN BEGIN
                            IF Unitmaster.GET(UnitCode_1) THEN BEGIN
                                Unitmaster.Freeze := FALSE;
                                Unitmaster.Status := Unitmaster.Status::Open;
                                Unitmaster."Web Portal Status" := Unitmaster."Web Portal Status"::Available;
                                // Unitmaster.VALIDATE(Status,Status::Open);
                                Unitmaster."Plot Cost" := 0;
                                Unitmaster."Customer Code" := '';
                                Unitmaster."Customer Name" := '';
                                Unitmaster."Registration No." := '';
                                //Unitmaster."Company Name" := 'BBG India Developers LLP';  //Code comment 08092025
                                Unitmaster.MODIFY;
                                Commit;
                                WebAppService.UpdateUnitStatus(Unitmaster);  //210624
                            END;
                        END;

                        ConfOrder.RESET;
                        ConfOrder.CHANGECOMPANY("Company Name");
                        ConfOrder.SETRANGE("No.", "No.");
                        IF ConfOrder.FINDFIRST THEN BEGIN
                            ConfOrder.Status := ConfOrder.Status::Vacate;
                            ConfOrder."Unit Code" := '';
                            ConfOrder."Project change Comment" := 'Payment Lag';
                            ConfOrder."Last Unit Vacated By" := USERID;    //121021
                            ConfOrder."Last Unit Vacate Date_Time" := CURRENTDATETIME;  //121021
                            ConfOrder.MODIFY;
                        END;

                        ToDoctMaster1.RESET;
                        ToDoctMaster1.SETRANGE("Document Type", ToDoctMaster1."Document Type"::Charge);
                        ToDoctMaster1.SETRANGE("Project Code", Unitmaster."Project Code");
                        ToDoctMaster1.SETRANGE("Unit Code", Unitmaster."No.");
                        ToDoctMaster1.SETFILTER(Code, '<>%1', 'BSP3');
                        ToDoctMaster1.SETRANGE("App. Charge Code", FromDocMaster1."App. Charge Code");
                        IF ToDoctMaster1.FINDSET THEN
                            REPEAT
                                ToDoctMaster1.DELETE;
                            UNTIL ToDoctMaster1.NEXT = 0;

                        FromDocMaster1.RESET;
                        FromDocMaster1.SETRANGE("Document Type", FromDocMaster1."Document Type"::Charge);
                        FromDocMaster1.SETRANGE("Project Code", Unitmaster."Project Code");
                        FromDocMaster1.SETRANGE("Unit Code", '');
                        FromDocMaster1.SETRANGE("Sub Payment Plan", FALSE);
                        FromDocMaster1.SETFILTER(Code, '<>%1', 'PPLAN*');  //281119
                        IF FromDocMaster1.FINDFIRST THEN
                            REPEAT
                                ToDoctMaster1.RESET;
                                ToDoctMaster1.SETRANGE("Document Type", ToDoctMaster1."Document Type"::Charge);
                                ToDoctMaster1.SETRANGE("Project Code", Unitmaster."Project Code");
                                ToDoctMaster1.SETRANGE("Unit Code", Unitmaster."No.");
                                ToDoctMaster1.SETRANGE(Code, FromDocMaster1.Code);
                                ToDoctMaster1.SETRANGE("App. Charge Code", FromDocMaster1."App. Charge Code");
                                IF ToDoctMaster1.FINDFIRST THEN BEGIN
                                    ToDoctMaster1."Sale/Lease" := FromDocMaster1."Sale/Lease";
                                    ToDoctMaster1."Unit Code" := Unitmaster."No.";
                                    ToDoctMaster1.Description := FromDocMaster1.Description;
                                    IF FromDocMaster1."Rate/Sq. Yd" <> 0 THEN
                                        ToDoctMaster1.VALIDATE("Rate/Sq. Yd", FromDocMaster1."Rate/Sq. Yd");
                                    IF FromDocMaster1."Rate/Sq. Yd" = 0 THEN
                                        ToDoctMaster1.VALIDATE("Fixed Price", FromDocMaster1."Fixed Price");
                                    ToDoctMaster1."BP Dependency" := FromDocMaster1."BP Dependency";
                                    ToDoctMaster1."Rate Not Allowed" := FromDocMaster1."Rate Not Allowed";
                                    ToDoctMaster1."Project Price Dependency Code" := FromDocMaster1."Project Price Dependency Code";
                                    ToDoctMaster1."Payment Plan Type" := FromDocMaster1."Payment Plan Type";
                                    ToDoctMaster1."Commision Applicable" := FromDocMaster1."Commision Applicable";
                                    ToDoctMaster1."Direct Associate" := FromDocMaster1."Direct Associate";
                                    ToDoctMaster1.Sequence := FromDocMaster1.Sequence;
                                    ToDoctMaster1."App. Charge Code" := FromDocMaster1."App. Charge Code";
                                    ToDoctMaster1.MODIFY;
                                END ELSE
                                    IF FromDocMaster1.Code <> 'BSP3' THEN BEGIN
                                        ToDoctMaster.INIT;
                                        ToDoctMaster."Document Type" := FromDocMaster1."Document Type";
                                        ToDoctMaster."Project Code" := FromDocMaster1."Project Code";
                                        ToDoctMaster.Code := FromDocMaster1.Code;
                                        ToDoctMaster."Sale/Lease" := FromDocMaster1."Sale/Lease";
                                        ToDoctMaster."Unit Code" := Unitmaster."No.";
                                        ToDoctMaster.Description := FromDocMaster1.Description;
                                        ToDoctMaster."Rate/Sq. Yd" := FromDocMaster1."Rate/Sq. Yd";
                                        ToDoctMaster."Fixed Price" := FromDocMaster1."Fixed Price";
                                        ToDoctMaster."BP Dependency" := FromDocMaster1."BP Dependency";
                                        ToDoctMaster."Rate Not Allowed" := FromDocMaster1."Rate Not Allowed";
                                        ToDoctMaster."Project Price Dependency Code" := FromDocMaster1."Project Price Dependency Code";
                                        ToDoctMaster."App. Charge Code" := FromDocMaster1."App. Charge Code";
                                        ToDoctMaster."Payment Plan Type" := FromDocMaster1."Payment Plan Type";
                                        ToDoctMaster."Commision Applicable" := FromDocMaster1."Commision Applicable";
                                        ToDoctMaster."Direct Associate" := FromDocMaster1."Direct Associate";
                                        ToDoctMaster.Sequence := FromDocMaster1.Sequence;
                                        IF FromDocMaster1."Fixed Price" = 0 THEN
                                            ToDoctMaster."Total Charge Amount" := FromDocMaster1."Rate/Sq. Yd" * Unitmaster."Saleable Area"
                                        ELSE
                                            ToDoctMaster."Total Charge Amount" := FromDocMaster1."Fixed Price";
                                        ToDoctMaster.Status := ToDoctMaster.Status::Release;
                                        ToDoctMaster.INSERT(TRUE);

                                    END;
                            UNTIL FromDocMaster1.NEXT = 0;
                        UpdateRoundOFF(Unitmaster."Project Code", Unitmaster."No.");

                    END;
                END;
            end;

            trigger OnPreDataItem()
            begin
                IF AppCode_2 <> '' THEN
                    SETRANGE("No.", AppCode_2);
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

    trigger OnPostReport()
    begin
        MESSAGE('%1', 'Process Done');
    end;

    var
        UnitCode_1: Code[20];
        ArchiveConfirmedOrder: Record "Archive Confirmed Order";
        LastVersion: Integer;
        Unitmaster: Record "Unit Master";
        Pcode: Code[20];
        PaymentTermsLineSale: Record "Payment Terms Line Sale";
        EleDate: Date;
        AppPEntry: Record "NewApplication Payment Entry";
        PTLineSale: Record "Payment Terms Line Sale";
        TotalAmt: Decimal;
        ConfOrder: Record "Confirmed Order";
        MSCUnitMaster: Record "Unit Master";
        ArchDocMaster: Record "Archive Document Master";
        DocumentMaster: Record "Document Master";
        DocumentMaster1: Record "Document Master";
        UMaster: Record "Unit Master";
        ReleaseUnit: Codeunit "Release Unit Application";
        RecordDiff: Boolean;
        Forcefullvacate: Boolean;
        AppCode_2: Code[20];
        RecConfORder: Record "Confirmed Order";
        AppPayentry_2: Record "Application Payment Entry";
        WebAppService: Codeunit "Web App Service";

    procedure UpdateRoundOFF(ProjectCode: Code[20]; UnitCode: Code[20])
    var
        TotalChAmt1: Decimal;
        RoundOffAmt: Decimal;
        ReviseValue: Decimal;
    begin
        TotalChAmt1 := 0;
        RoundOffAmt := 0;
        ReviseValue := 0;
        DocumentMaster.RESET;
        DocumentMaster.SETRANGE("Document Type", DocumentMaster."Document Type"::Charge);
        DocumentMaster.SETRANGE("Project Code", ProjectCode);
        DocumentMaster.SETRANGE("Unit Code", UnitCode);
        DocumentMaster.SETFILTER(Code, '<>%1&<>%2', 'OTH', 'PPLAN*');
        IF DocumentMaster.FINDFIRST THEN BEGIN
            REPEAT
                //IF DocumentMaster.Code <> 'PPLAN' THEN
                TotalChAmt1 := TotalChAmt1 + DocumentMaster."Total Charge Amount";
            UNTIL DocumentMaster.NEXT = 0;
            ReviseValue := ROUND(TotalChAmt1, 1, '>');

            RoundOffAmt := ReviseValue - TotalChAmt1;
            IF RoundOffAmt < 0 THEN
                ERROR('The Unit Rate must be greater or Equal to Charge Rate');

            IF RoundOffAmt <> 0 THEN BEGIN
                DocumentMaster1.RESET;
                DocumentMaster1.SETRANGE("Document Type", DocumentMaster1."Document Type"::Charge);
                DocumentMaster1.SETRANGE("Project Code", ProjectCode);
                DocumentMaster1.SETRANGE("Unit Code", UnitCode);
                DocumentMaster1.SETRANGE(Code, 'OTH');
                IF DocumentMaster1.FINDFIRST THEN BEGIN
                    DocumentMaster1.VALIDATE("Fixed Price", (RoundOffAmt));
                    DocumentMaster1.MODIFY;
                END;
            END;
        END;
        IF UMaster.GET(UnitCode) THEN BEGIN
            UMaster."Total Value" := ROUND(ReviseValue, 1, '>');
            UMaster.MODIFY;
            //ReleaseUnit.Updateunitmaster(UMaster);
        END;
        ReviseValue := 0;
    end;

    procedure CheckRates(UnitNo_1: Code[20]; ProjCode_1: Code[30]): Boolean
    var
        AppCharge_1: Record "Document Master";
        DocMasters_1: Record "Document Master";
    begin
        RecordDiff := FALSE;
        AppCharge_1.RESET;
        AppCharge_1.SETRANGE("Unit Code", UnitNo_1);
        AppCharge_1.SETRANGE("Project Code", ProjCode_1);
        IF AppCharge_1.FINDSET THEN
            REPEAT
                DocMasters_1.RESET;
                DocMasters_1.SETRANGE("Document Type", DocMasters_1."Document Type"::Charge);
                DocMasters_1.SETRANGE("Project Code", ProjCode_1);
                DocMasters_1.SETRANGE("Unit Code", '');
                DocMasters_1.SETFILTER("Rate/Sq. Yd", '>%1', 0);
                DocMasters_1.SETRANGE(Code, AppCharge_1.Code);
                IF DocMasters_1.FINDFIRST THEN BEGIN
                    IF ABS(AppCharge_1."Rate/Sq. Yd" - DocMasters_1."Rate/Sq. Yd") > 1 THEN
                        RecordDiff := TRUE;
                END;
            UNTIL (AppCharge_1.NEXT = 0) OR (RecordDiff);
        EXIT(RecordDiff);
    end;

    procedure ReportFilters(AppCode_1: Code[20]; ForcelyVacate: Boolean)
    begin
        AppCode_2 := AppCode_1;
        Forcefullvacate := ForcelyVacate;
    end;
}

