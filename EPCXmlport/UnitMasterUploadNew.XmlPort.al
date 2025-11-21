xmlport 50075 "Unit Master Upload New"
{
    // ALLE SSS 19/12/23 : Validation error to check Ref. LLP Details

    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Unit Master"; "Unit Master")
            {
                XmlName = 'UnitMasterUpload';
                fieldelement(No; "Unit Master"."No.")
                {
                }
                fieldelement(OldNo; "Unit Master"."Old No.")
                {
                }
                fieldelement(SaleableArea; "Unit Master"."Saleable Area")
                {
                }
                fieldelement(UnitType; "Unit Master"."Unit Type")
                {
                }
                fieldelement(BaseUnitofMeasure; "Unit Master"."Base Unit of Measure")
                {
                }
                fieldelement(ProjectCode; "Unit Master"."Project Code")
                {
                }
                fieldelement(PaymentPlan; "Unit Master"."Payment Plan")
                {
                }
                fieldelement(MinAllotmentAmount; "Unit Master"."Min. Allotment Amount")
                {
                    FieldValidate = No;
                }
                fieldelement(Facing; "Unit Master".Facing)
                {
                }
                fieldelement("Size-East"; "Unit Master"."Size-East")
                {
                }
                fieldelement("Size-West"; "Unit Master"."Size-West")
                {
                }
                fieldelement("Size-North"; "Unit Master"."Size-North")
                {
                }
                fieldelement("Size-South"; "Unit Master"."Size-South")
                {
                }
                textelement(AppChargeType)
                {
                }
                fieldelement(TotalValue; "Unit Master"."Total Value")
                {
                }
                fieldelement(NoofPlots; "Unit Master"."No. of Plots")
                {
                }
                fieldelement(UnitCategory; "Unit Master"."Unit Category")
                {
                }
                fieldelement(NoofPlotsforIncentiveCal; "Unit Master"."No. of Plots for Incentive Cal")
                {
                }
                fieldelement(PLCApplicable; "Unit Master"."PLC Applicable")
                {
                }
                fieldelement(EastBoundry; "Unit Master"."East Boundary")
                {
                }
                fieldelement(WestBoundry; "Unit Master"."West Boundary")
                {
                }
                fieldelement(NorthBoundry; "Unit Master"."North Boundary")
                {
                }
                fieldelement(SouthBoundry; "Unit Master"."South Boundary")
                {
                }
                fieldelement(RefLLPName; "Unit Master"."Ref. LLP Name")
                {
                    MinOccurs = Zero;
                }
                fieldelement(RefLLPItemNo; "Unit Master"."Ref. LLP Item No.")
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    SNo := SNo + 1;

                    Job.RESET;
                    IF Job.GET("Unit Master"."Project Code") THEN BEGIN
                        IF Job."Joint Venture" THEN BEGIN
                            RefLLPItemDetails.RESET;
                            RefLLPItemDetails.SETRANGE(RefLLPItemDetails."Project Code", "Unit Master"."Project Code");
                            RefLLPItemDetails.SETRANGE("Ref. LLP Name", "Unit Master"."Ref. LLP Name");
                            RefLLPItemDetails.SETRANGE("Ref. LLP Item No.", "Unit Master"."Ref. LLP Item No.");
                            IF NOT RefLLPItemDetails.FINDFIRST THEN
                                ERROR('Ref. LLP Item Details not found');
                        END;
                    END;

                    IF SNo = 1 THEN BEGIN
                        IF Job."Joint Venture" THEN BEGIN
                            CheckUnitMaster.RESET;
                            CheckUnitMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
                            CheckUnitMaster.SETFILTER("Ref. LLP Name", "Unit Master"."Ref. LLP Name");
                            CheckUnitMaster.SETRANGE("Ref. LLP Item No.", "Unit Master"."Ref. LLP Item No.");
                            IF CheckUnitMaster.FINDSET THEN BEGIN
                                TotalPlotSize := 0;
                                REPEAT
                                    TotalPlotSize := TotalPlotSize + CheckUnitMaster."Saleable Area";
                                UNTIL CheckUnitMaster.NEXT = 0;
                            END;
                        END;
                    END;


                    //AppChargeType := '';
                    //ADBBG1.00 BEGIN
                    MemberOf.RESET;
                    MemberOf.SETRANGE("User Name", USERID);
                    MemberOf.SETRANGE("Role ID", 'A_UNITUPLOAD');
                    IF NOT MemberOf.FINDFIRST THEN
                        ERROR('You do not have permission of role : A_UNITUPLOAD');
                    //ADBBG1.00 End

                    UMaster.RESET;
                    UMaster.SETRANGE("No.", "Unit Master"."No.");
                    IF UMaster.FINDFIRST THEN
                        ERROR('Unit already exists -' + "Unit Master"."No.");

                    IF OldNo <> '' THEN BEGIN
                        UMaster.RESET;
                        UMaster.SETRANGE("Old No.", OldNo);
                        UMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
                        IF UMaster.FINDFIRST THEN
                            ERROR('Unit already exists with Old No. -' + OldNo);
                    END;
                    IF PCode <> "Unit Master"."Project Code" THEN BEGIN
                        ERROR('Project code is different to upload Unit Master Project');
                        // CreatePaymentPlan;
                        // CreateChargeType;
                    END;


                    "Unit Master"."Carpet Area" := "Unit Master"."Saleable Area";
                    "Unit Master"."Lease Blocked" := TRUE;
                    "Unit Master"."Efficiency (%)" := 100.0;
                    "Unit Master"."Constructed Property" := 1;
                    "Unit Master"."Creation Date" := TODAY;
                    "Unit Master".Description := "Unit Master"."No.";
                    "Unit Master"."Company Name" := COMPANYNAME;
                    "Unit Master"."Old No." := OldNo;
                    "Unit Master"."Special Units" := SpecialUnit;
                    MinimumBookingAmt1 := 0;
                    //EVALUATE(MinimumBookingAmt1,MinimumBookingAmt);
                    //"Unit Master"."Minimum Booking Amount" := MinimumBookingAmt1;

                    //Archived := Archived::Yes;


                    // Checking AREA---------  070624

                    IF Job."Joint Venture" THEN BEGIN
                        LandAgreementHeader.RESET;
                        LandAgreementHeader.CHANGECOMPANY("Unit Master"."Ref. LLP Name");
                        LandAgreementHeader.SETRANGE("FG Item No.", "Unit Master"."Ref. LLP Item No.");
                        IF LandAgreementHeader.FINDFIRST THEN BEGIN
                            TotalSize := 0;
                            LandAgreementLine.RESET;
                            LandAgreementLine.CHANGECOMPANY("Unit Master"."Ref. LLP Name");
                            LandAgreementLine.SETRANGE("Document No.", LandAgreementHeader."Document No.");
                            IF LandAgreementLine.FINDSET THEN
                                REPEAT
                                    TotalSize := TotalSize + LandAgreementLine."Quantity in SQYD";
                                UNTIL LandAgreementLine.NEXT = 0;
                        END;

                        TotalPlotSize := TotalPlotSize + "Unit Master"."Saleable Area";


                        IF Job."Joint Venture" THEN BEGIN
                            IF TotalPlotSize > TotalSize THEN
                                ERROR('Plot Size is greater than Land agreement size difference value is = ' + FORMAT(TotalPlotSize - TotalSize));
                        END;
                    END;

                    //Checking AREA----------070624


                    IF "Unit Master"."Unit Category" = "Unit Master"."Unit Category"::Priority THEN
                        "Unit Master"."Non Usable" := TRUE
                    ELSE
                        "Unit Master"."Non Usable" := FALSE;

                    PaymentDocMaster.RESET;
                    PaymentDocMaster.SETRANGE(Code, "Unit Master"."Payment Plan");
                    PaymentDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
                    PaymentDocMaster.SETRANGE("Document Type", PaymentDocMaster."Document Type"::"Payment Plan");
                    IF NOT PaymentDocMaster.FINDFIRST THEN
                        ERROR(Text002, "Unit Master"."Project Code");

                    PaymentDocMaster.RESET;
                    PaymentDocMaster.SETCURRENTKEY("Document Type", "Project Code", "Unit Code");
                    PaymentDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
                    PaymentDocMaster.SETRANGE("Document Type", PaymentDocMaster."Document Type"::Charge);
                    PaymentDocMaster.SETFILTER("Unit Code", '%1', '');
                    IF NOT PaymentDocMaster.FINDFIRST THEN
                        ERROR(Text003, "Unit Master"."Project Code");

                    PaymentDocMaster.RESET;
                    PaymentDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
                    PaymentDocMaster.SETRANGE("Document Type", PaymentDocMaster."Document Type"::Charge);
                    PaymentDocMaster.SETRANGE("Unit Code", '%1', '');
                    IF PaymentDocMaster.FINDFIRST THEN
                        PaymentDocMaster.TESTFIELD(Status, PaymentDocMaster.Status::Release);

                    IF NOT AppChargeCode.GET(AppChargeType) THEN
                        ERROR('Please define the App. Charge Type')
                    ELSE BEGIN
                        IF AppChargeCode."Charge Type" = AppChargeCode."Charge Type"::"60Ft" THEN
                            "Unit Master"."60 feet Road" := TRUE;
                        IF AppChargeCode."Charge Type" = AppChargeCode."Charge Type"::Corner THEN
                            "Unit Master".Corner := TRUE;
                        IF AppChargeCode."Charge Type" = AppChargeCode."Charge Type"::"Corner+60Ft" THEN BEGIN
                            "Unit Master"."60 feet Road" := TRUE;
                            "Unit Master".Corner := TRUE;
                        END;
                    END;

                    IF "Unit Master"."Unit Category" = "Unit Master"."Unit Category"::Normal THEN BEGIN
                        UploadCharge;
                        DeleteApplicationCharges;
                        CalculateUnitPrice;
                        UpdateOtherCharges;
                    END ELSE BEGIN
                        PriorityUploadCharge;
                    END;

                    "Unit Master".VALIDATE("Unit Category");  //BBG1.00 120413

                    //ALLE SSS 19/12/23---Begin
                    RefLLPItemDetails.RESET;
                    RefLLPItemDetails.SETRANGE("Project Code", "Unit Master"."Project Code");
                    RefLLPItemDetails.SETRANGE("Ref. LLP Name", "Unit Master"."Ref. LLP Name");
                    RefLLPItemDetails.SETRANGE("Ref. LLP Item No.", "Unit Master"."Ref. LLP Item No.");
                    IF RefLLPItemDetails.FINDFIRST THEN BEGIN
                        CompanyInformation.CHANGECOMPANY("Unit Master"."Ref. LLP Name");
                        CompanyInformation.GET();
                        "Unit Master"."IC Partner Code" := CompanyInformation."BBG IC Partner Code";
                    END;
                    //ALLE SSS 19/12/23---End

                    CreateUnitLifeCycle; //040919
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SpecialUnit; SpecialUnit)
                {
                    AssistEdit = true;
                    CaptionML = ENU = 'Special Unit',
                                    ENC = 'Special Unit';
                    ApplicationArea = all;


                }
            }


        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        MESSAGE('%1', 'Unit upload');
    end;

    var
        Text001: Label 'Delete existing applicable charges.';
        Text002: Label 'Please define first Payment Plan Code on Project %1.';
        Text003: Label 'Please define first Charges on Project %1.';
        FromDocMaster: Record "Document Master";
        ToDoctMaster: Record "Document Master";
        PaymentDocMaster: Record "Document Master";
        AppChargeCode: Record "App. Charge Code";
        CarpArea: Decimal;
        PCode: Code[20];
        UMaster: Record "Unit Master";
        TotalValue: Decimal;
        PayPlanMaster: Record "Document Master";
        ChargeMaster: Record "Document Master";
        OldNo: Code[20];
        MemberOf: Record "Access Control";
        UnitSetup: Record "Unit Setup";
        AreaSize: Decimal;
        NewUnitMaster: Record "Unit Master";
        CompWiseAccount: Record "Company wise G/L Account";
        ResponsibilityCenter: Record "Responsibility Center";
        MinimumBookingAmt1: Decimal;
        RefLLPItemDetails: Record "Ref. LLP Item Details";
        Text004: Label 'Ref. LLP Details does not exist for Project Code %1, Ref. LLP Name %2, Ref. LLP Item No. %3.';
        CompanyInformation: Record "Company Information";
        LandAgreementHeader: Record "Land Agreement Header";
        LandAgreementLine: Record "Land Agreement Line";
        TotalSize: Decimal;
        TotalPlotSize: Decimal;
        SNo: Integer;
        CheckUnitMaster: Record "Unit Master";
        Job: Record "Job";
        SpecialUnit: Boolean;


    procedure UploadCharge()
    begin
        FromDocMaster.RESET;
        FromDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code");
        FromDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
        FromDocMaster.SETRANGE("Document Type", FromDocMaster."Document Type"::Charge);
        FromDocMaster.SETRANGE("Unit Code", "Unit Master"."No.");
        //FromDocMaster.SETRANGE("App. Charge Code","Unit Master"."App. Charge Code");
        IF FromDocMaster.FINDFIRST THEN
            ERROR(Text001);

        //ALLEDK 230113
        FromDocMaster.RESET;
        FromDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code");
        FromDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
        FromDocMaster.SETRANGE("Document Type", FromDocMaster."Document Type"::Charge);
        FromDocMaster.SETFILTER("Unit Code", '%1', '');
        IF FromDocMaster.FINDFIRST THEN
            FromDocMaster.TESTFIELD(Status, FromDocMaster.Status::Release);
        //ALLEDK 230113

        FromDocMaster.RESET;
        FromDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
        FromDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
        FromDocMaster.SETRANGE("Document Type", FromDocMaster."Document Type"::Charge);
        FromDocMaster.SETFILTER("App. Charge Code", '=%1', '');
        FromDocMaster.SETRANGE("Unit Code", '');
        FromDocMaster.SETFILTER(Code, '<>%1', 'PB');
        FromDocMaster.SETRANGE("Sub Payment Plan", FALSE);
        IF FromDocMaster.FINDSET THEN
            REPEAT
                //InsertApplicationCharges;
                IF (FromDocMaster."Fixed Price" <> 0) THEN
                    InsertApplicationCharges;
                IF FromDocMaster.Code = 'OTH' THEN
                    InsertApplicationCharges;
                IF FromDocMaster."Rate/Sq. Yd" <> 0 THEN
                    InsertApplicationCharges;
            UNTIL FromDocMaster.NEXT = 0;

        FromDocMaster.RESET;
        FromDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
        FromDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
        FromDocMaster.SETRANGE("Document Type", FromDocMaster."Document Type"::Charge);
        FromDocMaster.SETRANGE("App. Charge Code", AppChargeType);
        FromDocMaster.SETRANGE("Unit Code", '');
        FromDocMaster.SETFILTER(Code, '<>%1', 'PB');
        FromDocMaster.SETFILTER("Rate/Sq. Yd", '>%1', 0);
        FromDocMaster.SETRANGE("Sub Payment Plan", FALSE);
        IF FromDocMaster.FINDSET THEN
            REPEAT
                InsertApplicationCharges1;
            UNTIL FromDocMaster.NEXT = 0;
    end;


    procedure InsertApplicationCharges()
    begin
        ToDoctMaster.INIT;
        ToDoctMaster."Document Type" := FromDocMaster."Document Type";
        ToDoctMaster."Project Code" := FromDocMaster."Project Code";
        ToDoctMaster.Code := FromDocMaster.Code;
        ToDoctMaster."Sale/Lease" := FromDocMaster."Sale/Lease";
        ToDoctMaster."Unit Code" := "Unit Master"."No.";
        ToDoctMaster.Description := FromDocMaster.Description;
        ToDoctMaster."Rate/Sq. Yd" := FromDocMaster."Rate/Sq. Yd";
        ToDoctMaster."Fixed Price" := FromDocMaster."Fixed Price";
        ToDoctMaster."BP Dependency" := FromDocMaster."BP Dependency";
        ToDoctMaster."Rate Not Allowed" := FromDocMaster."Rate Not Allowed";
        ToDoctMaster."Project Price Dependency Code" := FromDocMaster."Project Price Dependency Code";
        ToDoctMaster."App. Charge Code" := FromDocMaster."App. Charge Code";
        ToDoctMaster."Payment Plan Type" := FromDocMaster."Payment Plan Type";
        ToDoctMaster."Commision Applicable" := FromDocMaster."Commision Applicable";
        ToDoctMaster."Direct Associate" := FromDocMaster."Direct Associate";
        ToDoctMaster.Sequence := FromDocMaster.Sequence;
        IF FromDocMaster."Fixed Price" = 0 THEN
            ToDoctMaster."Total Charge Amount" := FromDocMaster."Rate/Sq. Yd" * "Unit Master"."Saleable Area"
        ELSE
            ToDoctMaster."Total Charge Amount" := FromDocMaster."Fixed Price";
        ToDoctMaster.Status := ToDoctMaster.Status::Release;
        ToDoctMaster.INSERT(TRUE);
    end;


    procedure InsertApplicationCharges1()
    begin
        ToDoctMaster.INIT;
        ToDoctMaster."Document Type" := FromDocMaster."Document Type";
        ToDoctMaster."Project Code" := FromDocMaster."Project Code";
        ToDoctMaster.Code := FromDocMaster.Code;
        ToDoctMaster."Sale/Lease" := FromDocMaster."Sale/Lease";
        ToDoctMaster."Unit Code" := "Unit Master"."No.";
        ToDoctMaster.Description := FromDocMaster.Description;
        ToDoctMaster."Rate/Sq. Yd" := FromDocMaster."Rate/Sq. Yd";
        ToDoctMaster."Fixed Price" := FromDocMaster."Fixed Price";
        ToDoctMaster."BP Dependency" := FromDocMaster."BP Dependency";
        ToDoctMaster."Rate Not Allowed" := FromDocMaster."Rate Not Allowed";
        ToDoctMaster."Project Price Dependency Code" := FromDocMaster."Project Price Dependency Code";
        ToDoctMaster."Payment Plan Type" := FromDocMaster."Payment Plan Type";
        ToDoctMaster."Commision Applicable" := FromDocMaster."Commision Applicable";
        ToDoctMaster."Direct Associate" := FromDocMaster."Direct Associate";
        ToDoctMaster.Sequence := FromDocMaster.Sequence;

        //ALLEDK 310013
        //ToDoctMaster.VALIDATE("App. Charge Code",AppChargeType);
        IF (FromDocMaster.Code = 'BSP3') THEN
            ToDoctMaster.VALIDATE("App. Charge Code", AppChargeType)
        ELSE
            ToDoctMaster."App. Charge Code" := '';
        //ALLEDK 310013

        IF FromDocMaster.Code = 'PPLAN' THEN
            ToDoctMaster.VALIDATE("App. Charge Code", '1008');

        ToDoctMaster.Status := ToDoctMaster.Status::Release;
        IF FromDocMaster."Fixed Price" = 0 THEN
            ToDoctMaster."Total Charge Amount" := FromDocMaster."Rate/Sq. Yd" * "Unit Master"."Saleable Area"
        ELSE
            ToDoctMaster."Total Charge Amount" := FromDocMaster."Fixed Price";
        ToDoctMaster.INSERT(TRUE);
    end;


    procedure DeleteApplicationCharges()
    begin
        FromDocMaster.RESET;
        FromDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
        FromDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
        FromDocMaster.SETRANGE("Document Type", FromDocMaster."Document Type"::Charge);
        FromDocMaster.SETRANGE("Sale/Lease", FromDocMaster."Sale/Lease"::Sale);
        FromDocMaster.SETRANGE("Unit Code", "Unit Master"."No.");
        IF "Unit Master"."Saleable Area" < AreaSize THEN
            FromDocMaster.SETFILTER(Code, '= %1', 'ADMIN2')
        ELSE
            FromDocMaster.SETFILTER(Code, '= %1', 'ADMIN');
        IF FromDocMaster.FINDFIRST THEN
            FromDocMaster.DELETE;
    end;


    procedure SetProject(var "code": Code[20])
    begin
        PCode := code;
    end;


    procedure CalculateUnitPrice()
    var
        CalDocMaster: Record "Document Master";
    begin
        TotalValue := 0;
        CalDocMaster.RESET;
        CalDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
        CalDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
        CalDocMaster.SETRANGE("Document Type", CalDocMaster."Document Type"::Charge);
        CalDocMaster.SETRANGE("Unit Code", "Unit Master"."No.");
        IF CalDocMaster.FINDFIRST THEN
            REPEAT
                TotalValue := TotalValue + CalDocMaster."Fixed Price" + (CalDocMaster."Rate/Sq. Yd" * "Unit Master"."Saleable Area");
            UNTIL CalDocMaster.NEXT = 0;
    end;


    procedure CreatePaymentPlan()
    var
        PaymentDocMaster: Record "Document Master";
    begin
        PaymentDocMaster.RESET;
        PaymentDocMaster.SETRANGE("Document Type", PaymentDocMaster."Document Type"::"Payment Plan");
        PaymentDocMaster.SETRANGE("Payment Plan Type", PaymentDocMaster."Payment Plan Type"::"Down Payment");
        PaymentDocMaster.SETRANGE("Default Setup", TRUE);
        IF PaymentDocMaster.FINDFIRST THEN
            REPEAT
                PayPlanMaster.INIT;
                PayPlanMaster."Document Type" := PaymentDocMaster."Document Type";
                PayPlanMaster."Project Code" := "Unit Master"."Project Code";
                PayPlanMaster.Code := PaymentDocMaster.Code;
                PayPlanMaster.Description := PaymentDocMaster.Description;
                PayPlanMaster."Sale/Lease" := PaymentDocMaster."Sale/Lease";
                PayPlanMaster."Payment Plan Type" := PaymentDocMaster."Payment Plan Type";
                PayPlanMaster.INSERT;
            UNTIL PaymentDocMaster.NEXT = 0;
    end;


    procedure CreateChargeType()
    var
        ChargeDocMaster: Record "Document Master";
    begin
        ChargeDocMaster.RESET;
        ChargeDocMaster.SETRANGE("Document Type", PaymentDocMaster."Document Type"::Charge);
        ChargeDocMaster.SETRANGE("Default Setup", TRUE);
        IF ChargeDocMaster.FINDFIRST THEN
            REPEAT
                ChargeMaster.INIT;
                ChargeMaster."Document Type" := ChargeDocMaster."Document Type";
                ChargeMaster."Project Code" := "Unit Master"."Project Code";
                ChargeMaster.Code := ChargeDocMaster.Code;
                ChargeMaster.Description := ChargeDocMaster.Description;
                ChargeMaster."Sale/Lease" := ChargeDocMaster."Sale/Lease";
                ChargeMaster."App. Charge Code" := ChargeDocMaster."App. Charge Code";
                ChargeMaster."App. Charge Name" := ChargeDocMaster."App. Charge Name";
                ChargeMaster.Sequence := ChargeDocMaster.Sequence;
                ChargeMaster."Commision Applicable" := ChargeDocMaster."Commision Applicable";
                ChargeMaster."Direct Associate" := ChargeDocMaster."Direct Associate";
                ChargeMaster."Rate/Sq. Yd" := ChargeDocMaster."Rate/Sq. Yd";
                ChargeMaster."Fixed Price" := ChargeDocMaster."Fixed Price";
                ChargeMaster.Status := ChargeMaster.Status::Release; //ALLEDK 030313
                ChargeMaster.INSERT;
            UNTIL ChargeDocMaster.NEXT = 0;
    end;


    procedure UpdateOtherCharges()
    var
        CalDocMaster: Record "Document Master";
    begin
        UnitSetup.GET;
        CalDocMaster.RESET;
        CalDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
        CalDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
        CalDocMaster.SETRANGE("Document Type", CalDocMaster."Document Type"::Charge);
        CalDocMaster.SETRANGE("Unit Code", "Unit Master"."No.");
        CalDocMaster.SETRANGE(CalDocMaster.Code, 'OTH');
        IF CalDocMaster.FINDFIRST THEN BEGIN
            CalDocMaster."Fixed Price" := "Unit Master"."Total Value" - TotalValue;
            CalDocMaster."Total Charge Amount" := CalDocMaster."Fixed Price";  //ALLEDK 250113
                                                                               //160213 START
                                                                               //ALLEDK 190113
            IF CalDocMaster."Fixed Price" > 0 THEN
                IF (CalDocMaster."Fixed Price" > UnitSetup."Unit R/O") THEN
                    ERROR('The difference between upload amount and Unit Amount is= ' + FORMAT(CalDocMaster."Fixed Price") +
                      ' ' + 'of Unit No-' + "Unit Master"."No." + '.' + 'The unit upload is unsuccessful.');
            IF CalDocMaster."Fixed Price" < 0 THEN
                IF (ABS(CalDocMaster."Fixed Price") > UnitSetup."Unit R/O") THEN
                    ERROR('The difference between upload amount and Unit Amount is= ' + FORMAT(CalDocMaster."Fixed Price") +
                    ' ' + 'of Unit No-' + "Unit Master"."No." + '.' + 'The unit upload is unsuccessful.');

            //ALLEDK 190113
            //160213 END
            CalDocMaster.MODIFY;
        END;
    end;


    procedure PriorityUploadCharge()
    begin
        FromDocMaster.RESET;
        FromDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code");
        FromDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
        FromDocMaster.SETRANGE("Document Type", FromDocMaster."Document Type"::Charge);
        FromDocMaster.SETRANGE("Unit Code", "Unit Master"."No.");
        //FromDocMaster.SETRANGE("App. Charge Code","Unit Master"."App. Charge Code");
        IF FromDocMaster.FINDFIRST THEN
            ERROR(Text001);

        ToDoctMaster.INIT;
        ToDoctMaster."Document Type" := ToDoctMaster."Document Type"::Charge;
        ToDoctMaster."Project Code" := "Unit Master"."Project Code";
        ToDoctMaster.Code := 'PB';
        ToDoctMaster."Sale/Lease" := ToDoctMaster."Sale/Lease"::Sale;
        ToDoctMaster."Unit Code" := "Unit Master"."No.";
        ToDoctMaster.Description := "Unit Master"."No.";
        ToDoctMaster."Fixed Price" := "Unit Master"."Total Value";
        ToDoctMaster."Payment Plan Type" := ToDoctMaster."Payment Plan Type"::"Down Payment";
        ToDoctMaster.Status := ToDoctMaster.Status::Release;  //ALLEDK 030313
        ToDoctMaster.INSERT(TRUE);
    end;

    local procedure CreateUnitLifeCycle()
    var
        UnitLifeCycle: Record "Unit Life Cycle";
        OldUnitLifeCycle: Record "Unit Life Cycle";
        LineNo: Integer;
    begin
        OldUnitLifeCycle.RESET;
        OldUnitLifeCycle.SETRANGE("Unit Code", "Unit Master"."No.");
        IF OldUnitLifeCycle.FINDLAST THEN
            LineNo := OldUnitLifeCycle."Line No."
        ELSE BEGIN
            LineNo := 0;

            UnitLifeCycle.INIT;
            UnitLifeCycle."Unit Code" := "Unit Master"."No.";
            UnitLifeCycle."Line No." := LineNo + 1;
            UnitLifeCycle."Creation Date" := TODAY;
            UnitLifeCycle."Unit Creation Time" := TIME;
            UnitLifeCycle."Unit Created By" := USERID;
            IF ResponsibilityCenter.GET("Unit Master"."Project Code") THEN
                UnitLifeCycle."Project Name" := ResponsibilityCenter.Name;
            ;
            UnitLifeCycle."Unit Cost" := "Unit Master"."Total Value";
            UnitLifeCycle."Type of Transaction" := UnitLifeCycle."Type of Transaction"::"Unit Creation";
            UnitLifeCycle.INSERT;
        END;
    end;
}

