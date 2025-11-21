xmlport 50076 "Unit Master Update for JV"
{
    // ALLESSS 21/02/24 : Created xmlport to update Unit Master for Joint Venture

    Caption = 'Unit Master Update for Joint Venture';
    Direction = Both;
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Unit Master"; "Unit Master")
            {
                AutoSave = false;
                XmlName = 'UnitMasterUpload';
                fieldelement(No; "Unit Master"."No.")
                {
                }
                fieldelement(ProjectCode; "Unit Master"."Project Code")
                {
                }
                fieldelement(SaleableArea; "Unit Master"."Saleable Area")
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

                trigger OnBeforeInsertRecord()
                begin

                    //AppChargeType := '';
                    MemberOf.RESET;
                    MemberOf.SETRANGE("User Name", USERID);
                    MemberOf.SETRANGE("Role ID", 'A_UNITUPLOAD');
                    IF NOT MemberOf.FINDFIRST THEN
                        ERROR('You do not have permission of role : A_UNITUPLOAD');

                    UMaster.RESET;
                    UMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
                    UMaster.SETRANGE("No.", "Unit Master"."No.");
                    IF NOT UMaster.FINDFIRST THEN
                        ERROR('Unit Master does not exist for Unit No.: ' + "Unit Master"."No.")
                    ELSE BEGIN
                        //UMaster.TRANSFERFIELDS("Unit Master");
                        UMaster."Carpet Area" := "Unit Master"."Saleable Area";
                        UMaster."Lease Blocked" := TRUE;
                        UMaster."Efficiency (%)" := 100.0;
                        UMaster."Constructed Property" := 1;
                        UMaster."Creation Date" := TODAY;
                        UMaster.Description := "Unit Master"."No.";
                        UMaster."Company Name" := COMPANYNAME;
                        IF COMPANYNAME <> 'BBG India Developers LLP' THEN
                            UMaster."Special Units" := TRUE;
                        UMaster.VALIDATE("Saleable Area", "Unit Master"."Saleable Area");
                        UMaster.VALIDATE("Total Value", "Unit Master"."Total Value");
                        UMaster."Payment Plan" := "Unit Master"."Payment Plan";
                        UMaster."Min. Allotment Amount" := "Unit Master"."Min. Allotment Amount";
                        UMaster.VALIDATE(Facing, "Unit Master".Facing);
                        UMaster.VALIDATE("Size-East", "Unit Master"."Size-East");
                        UMaster.VALIDATE("Size-West", "Unit Master"."Size-West");
                        UMaster.VALIDATE("Size-North", "Unit Master"."Size-North");
                        UMaster.VALIDATE("Size-South", "Unit Master"."Size-South");
                        UMaster.VALIDATE("No. of Plots", "Unit Master"."No. of Plots");
                        UMaster.VALIDATE("Unit Category", "Unit Master"."Unit Category");
                        UMaster.VALIDATE("No. of Plots for Incentive Cal", "Unit Master"."No. of Plots for Incentive Cal");
                        UMaster.VALIDATE("PLC Applicable", "Unit Master"."PLC Applicable");
                        UMaster.VALIDATE("East Boundary", "Unit Master"."East Boundary");
                        UMaster.VALIDATE("West Boundary", "Unit Master"."West Boundary");
                        UMaster.VALIDATE("North Boundary", "Unit Master"."North Boundary");
                        UMaster.VALIDATE("South Boundary", "Unit Master"."South Boundary");
                        MinimumBookingAmt1 := 0;
                        //EVALUATE(MinimumBookingAmt1,MinimumBookingAmt);
                        //UMaster."Minimum Booking Amount" := MinimumBookingAmt1;

                        //Archived := Archived::Yes;

                        IF "Unit Master"."Unit Category" = "Unit Master"."Unit Category"::Priority THEN
                            UMaster."Non Usable" := TRUE
                        ELSE
                            UMaster."Non Usable" := FALSE;

                        PaymentDocMaster.RESET;
                        PaymentDocMaster.SETRANGE(Code, "Unit Master"."Payment Plan");
                        PaymentDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
                        PaymentDocMaster.SETRANGE("Document Type", PaymentDocMaster."Document Type"::"Payment Plan");
                        IF NOT PaymentDocMaster.FINDFIRST THEN
                            ERROR(Text002, UMaster."Project Code");

                        PaymentDocMaster.RESET;
                        PaymentDocMaster.SETCURRENTKEY("Document Type", "Project Code", "Unit Code");
                        PaymentDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
                        PaymentDocMaster.SETRANGE("Document Type", PaymentDocMaster."Document Type"::Charge);
                        PaymentDocMaster.SETFILTER("Unit Code", '%1', '');
                        IF NOT PaymentDocMaster.FINDFIRST THEN
                            ERROR(Text003, UMaster."Project Code");

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
                                UMaster."60 feet Road" := TRUE;
                            IF AppChargeCode."Charge Type" = AppChargeCode."Charge Type"::Corner THEN
                                UMaster.Corner := TRUE;
                            IF AppChargeCode."Charge Type" = AppChargeCode."Charge Type"::"Corner+60Ft" THEN BEGIN
                                UMaster."60 feet Road" := TRUE;
                                UMaster.Corner := TRUE;
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

                        UMaster.VALIDATE("Unit Category");

                        CreateUnitLifeCycle;


                        UMaster.MODIFY;
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
        MESSAGE('%1', 'Unit Master updated');
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
        MemberOf: Record "Access Control";
        UnitSetup: Record "Unit Setup";
        AreaSize: Decimal;
        NewUnitMaster: Record "Unit Master";
        CompWiseAccount: Record "Company wise G/L Account";
        ResponsibilityCenter: Record "Responsibility Center";
        MinimumBookingAmt1: Decimal;
        Text004: Label 'Ref. LLP Details does not exist for Project Code %1, Ref. LLP Name %2, Ref. LLP Item No. %3.';
        CompanyInformation: Record "Company Information";


    procedure UploadCharge()
    begin
        FromDocMaster.RESET;
        FromDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code");
        FromDocMaster.SETRANGE("Project Code", "Unit Master"."Project Code");
        FromDocMaster.SETRANGE("Document Type", FromDocMaster."Document Type"::Charge);
        FromDocMaster.SETRANGE("Unit Code", "Unit Master"."No.");
        //FromDocMaster.SETRANGE("App. Charge Code",UMaster."App. Charge Code");
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
        ToDoctMaster."Unit Code" := UMaster."No.";
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
            ToDoctMaster."Total Charge Amount" := FromDocMaster."Rate/Sq. Yd" * UMaster."Saleable Area"
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
        ToDoctMaster."Unit Code" := UMaster."No.";
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
            ToDoctMaster."Total Charge Amount" := FromDocMaster."Rate/Sq. Yd" * UMaster."Saleable Area"
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
        FromDocMaster.SETRANGE("Unit Code", UMaster."No.");
        IF UMaster."Saleable Area" < AreaSize THEN
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
                TotalValue := TotalValue + CalDocMaster."Fixed Price" + (CalDocMaster."Rate/Sq. Yd" * UMaster."Saleable Area");
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
                      ' ' + 'of Unit No-' + UMaster."No." + '.' + 'The unit upload is unsuccessful.');
            IF CalDocMaster."Fixed Price" < 0 THEN
                IF (ABS(CalDocMaster."Fixed Price") > UnitSetup."Unit R/O") THEN
                    ERROR('The difference between upload amount and Unit Amount is= ' + FORMAT(CalDocMaster."Fixed Price") +
                    ' ' + 'of Unit No-' + UMaster."No." + '.' + 'The unit upload is unsuccessful.');

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
        //FromDocMaster.SETRANGE("App. Charge Code",UMaster."App. Charge Code");
        IF FromDocMaster.FINDFIRST THEN
            ERROR(Text001);

        ToDoctMaster.INIT;
        ToDoctMaster."Document Type" := ToDoctMaster."Document Type"::Charge;
        ToDoctMaster."Project Code" := UMaster."Project Code";
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
            IF ResponsibilityCenter.GET(UMaster."Project Code") THEN
                UnitLifeCycle."Project Name" := ResponsibilityCenter.Name;
            ;
            UnitLifeCycle."Unit Cost" := "Unit Master"."Total Value";
            UnitLifeCycle."Type of Transaction" := UnitLifeCycle."Type of Transaction"::"Unit Creation";
            UnitLifeCycle.INSERT;
        END;
    end;
}

