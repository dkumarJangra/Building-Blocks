tableextension 50007 "BBG Vendor Ext" extends Vendor
{
    fields
    {
        // Add changes to table fields here

        modify(Name)
        {
            trigger OnAfterValidate()
            var
                v_RegionwiseVendor: Record "Region wise Vendor";
            begin
                IF "BBG Vendor Category" = "BBG Vendor Category"::"IBA(Associates)" THEN BEGIN
                    TESTFIELD("BBG Sex");
                    TESTFIELD("BBG Nominee Name");
                    TESTFIELD("BBG Age");
                    TESTFIELD("BBG Father Name");
                    TESTFIELD(City);
                    TESTFIELD("Post Code");
                    TESTFIELD("BBG Designation");
                    TESTFIELD("E-Mail");
                    TESTFIELD("BBG Reporting Office");
                    TESTFIELD("Country/Region Code");
                    TESTFIELD("State Code");
                    TESTFIELD("BBG Presence on Social Media");
                    Memberof.RESET;
                    Memberof.SETRANGE("User Name", USERID);
                    Memberof.SETRANGE("Role ID", 'A_IBACREATION');
                    IF NOT Memberof.FINDFIRST THEN
                        ERROR('Please contact admin dept.');
                    v_RegionwiseVendor.RESET;
                    v_RegionwiseVendor.SETRANGE("No.", "No.");
                    IF v_RegionwiseVendor.FINDSET THEN
                        REPEAT
                            v_RegionwiseVendor.Name := Name;
                            v_RegionwiseVendor.MODIFY;
                        UNTIL v_RegionwiseVendor.NEXT = 0;
                END ELSE BEGIN
                    Memberof.RESET;
                    Memberof.SETRANGE("User Name", USERID);
                    Memberof.SETRANGE("Role ID", 'A_OTHERVENDCREATION');
                    IF NOT Memberof.FINDFIRST THEN
                        ERROR('Please contact admin dept.');
                END;
                IF STRLEN(Name) < 3 THEN
                    ERROR('Please define actual Name');

                //ALLEDK 100821
                IF Name <> '' THEN BEGIN
                    pos := 1;
                    WHILE (pos <= STRLEN(Name)) DO BEGIN
                        IsNumeric := Name[pos] IN ['0' .. '9', '-', '+'];
                        IF IsNumeric THEN
                            ERROR('Number not allow')
                        ELSE
                            result := result + FORMAT(Name[pos]);
                        pos += 1;
                    END;
                END;
                //ALLEDK 100821
            end;
        }
        modify("Name 2")
        {
            trigger OnAfterValidate()
            begin
                //ALLEDK 100821
                IF "Name 2" <> '' THEN BEGIN
                    pos := 1;
                    WHILE (pos <= STRLEN("Name 2")) DO BEGIN
                        IsNumeric := "Name 2"[pos] IN ['0' .. '9', '-', '+'];
                        IF IsNumeric THEN
                            ERROR('Number not allow')
                        ELSE
                            result := result + FORMAT("Name 2"[pos]);
                        pos += 1;
                    END;
                END;
                //ALLEDK 100821
            end;
        }
        modify(City)
        {
            trigger OnAfterValidate()
            begin
                //ALLEDK 100821
                IF City <> '' THEN BEGIN
                    pos := 1;
                    WHILE (pos <= STRLEN(City)) DO BEGIN
                        IsNumeric := City[pos] IN ['0' .. '9', '-', '+'];
                        IF IsNumeric THEN
                            ERROR('Number not allow')
                        ELSE
                            result := result + FORMAT(City[pos]);
                        pos += 1;
                    END;
                END;
                //ALLEDK 100821
            end;
        }
        modify("Gen. Bus. Posting Group")
        {
            trigger OnAfterValidate()
            begin
                IF "BBG Vendor Category" = "BBG Vendor Category"::"IBA(Associates)" THEN BEGIN
                    MESSAGE('First fill the Associate Credentials');
                    IF ("BBG Mob. No." = '') THEN
                        IF "E-Mail" = '' THEN
                            ERROR('Fill the Mobile No. OR E-Mail');

                    TESTFIELD("BBG Date of Birth");
                    //  TESTFIELD("Rank Code");
                    UnitSetup.GET;
                    //  IF "Rank Code" <= UnitSetup."Hierarchy Head" THEN
                    //    TESTFIELD("Parent Rank");
                    //  TESTFIELD("Associate Creation");
                    //  IF "Associate Creation" = "Associate Creation"::" " THEN
                    //    TESTFIELD("Old No.");
                    IF "P.A.N. Status" = "P.A.N. Status"::" " THEN
                        TESTFIELD("P.A.N. No.");
                END;
            end;
        }
        modify("Post Code")
        {
            trigger OnAfterValidate()
            var
                v_PostCode: Record "Post Code";
            begin
                IF STRLEN("Post Code") > 6 THEN  //ALLEDK 100821
                    ERROR('Post code can not be greater than 6 Digits');   //ALLEDK 100821
                v_PostCode.GET("Post Code", City);  //ALLEDK 100821
                "State Code" := v_PostCode."State Code";  //ALLEDK 100821
            end;
        }
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
        }
        modify("P.A.N. No.")
        {
            trigger OnAfterValidate()
            begin

                //IF "P.A.N. Status" <> 0 THEN
                // ERROR(Text16500);

                IF ("P.A.N. No." <> '') AND
                  NOT ("P.A.N. Status" IN ["P.A.N. Status"::PANAPPLIED,
                    "P.A.N. Status"::PANINVALID, "P.A.N. Status"::PANNOTAVBL])
                THEN BEGIN
                    IF STRLEN("P.A.N. No.") <> 10 THEN
                        ERROR(Text018);

                    Vendor.RESET;
                    Vendor.SETFILTER("No.", '<>%1', "No.");
                    Vendor.SETRANGE("P.A.N. No.", "P.A.N. No.");
                    Vendor.SETRANGE("BBG Vendor Category", "BBG Vendor Category");//ALLETDK120413
                    IF Vendor.FINDFIRST THEN BEGIN
                        IF Vendor."P.A.N. No." <> 'PANAPPLIED' THEN
                            ERROR(Text016, "P.A.N. No.");
                    END;
                END;

                //IF "P.A.N. No." <> xRec."P.A.N. No." THEN  //170220
                //UpdateDedPAN;  //170220


                //ALLEDK 111012
                IF "P.A.N. No." <> 'PANAPPLIED' THEN BEGIN
                    IF "P.A.N. Status" = "P.A.N. Status"::" " THEN BEGIN
                        IF "P.A.N. No." <> '' THEN BEGIN
                            StartNo := COPYSTR("P.A.N. No.", 1, 1);
                            IF EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 2, 1);
                            IF EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 3, 1);
                            IF EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 4, 1);
                            IF EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 5, 1);
                            IF EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 6, 1);
                            IF NOT EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 7, 1);
                            IF NOT EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 8, 1);
                            IF NOT EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 9, 1);
                            IF NOT EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 10, 1);
                            IF EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                        END;
                    END;
                END;
                //ALLEDK 111012
            end;
        }
        modify("P.A.N. Reference No.")
        {
            trigger OnAfterValidate()
            Begin
                IF ("P.A.N. Reference No." <> xRec."P.A.N. Reference No.") THEN
                    UpdateDedPANRefNo;
            End;
        }
        Field(50015; "BBG New Debit Amount (LCY)"; Decimal)
        {
            Caption = 'New Debit Amount (LCY)';
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                        "Entry Type" = FILTER(<> Application),
                                                                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                        "Posting Date" = FIELD("Date Filter"),
                                                                                        "Currency Code" = FIELD("Currency Filter"),
                                                                                        "Posting Type" = FIELD("BBG Posting Type Filter")));
            Description = 'AlleDK 130308 using for Report';
            FieldClass = FlowField;
        }
        field(50016; "BBG New Credit Amount (LCY)"; Decimal)
        {
            Caption = 'New Credit Amount (LCY)';
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Credit Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                         "Entry Type" = FILTER(<> Application),
                                                                                         "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                         "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                         "Posting Date" = FIELD("Date Filter"),
                                                                                         "Currency Code" = FIELD("Currency Filter"),
                                                                                         "Posting Type" = FIELD("BBG Posting Type Filter")));
            Description = 'AlleDK 130308 using for Report';
            FieldClass = FlowField;
        }

        Field(50415; "Ledger Amount"; Decimal)   //130225
        {
            Caption = 'Ledger Amount';
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount" WHERE("Vendor No." = FIELD("No."),
                                                                                        "Entry Type" = FILTER("Initial Entry"),
                                                                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                        "Posting Date" = FIELD("Date Filter"),
                                                                                        "Currency Code" = FIELD("Currency Filter"),
                                                                                        "Posting Type" = FIELD("BBG Posting Type Filter")));

            FieldClass = FlowField;
        }




        field(50031; "BBG Vendor Card Status"; Option)
        {
            Caption = 'Vendor Card Status';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(50049; "BBG Associate Responcbility Center"; Code[20])
        {
            Caption = 'Associate Responcbility Center';
            DataClassification = ToBeClassified;
        }
        field(50051; "BBG Web User_ID"; Integer)
        {
            Caption = 'Web User_ID';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50071; "BBG Associate Respcenter Code"; Code[30])
        {
            Caption = 'Associate Respcenter Code';
            DataClassification = ToBeClassified;
        }
        field(50106; "BBG Reporting Office"; Code[20])
        {
            Caption = 'Reporting Office';
            DataClassification = ToBeClassified;
            TableRelation = "Reporting Office Master";
        }
        field(50206; "BBG RERA No."; Code[20])
        {
            Caption = 'RERA No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                CharacterLength: Integer;
            begin
                IF "BBG RERA No." <> '' THEN BEGIN
                    CharacterLength := 0;
                    CharacterLength := STRLEN("BBG RERA No.");
                    IF CharacterLength >= 10 THEN
                        "BBG RERA Status" := "BBG RERA Status"::Registered;
                END ELSE
                    "BBG RERA Status" := "BBG RERA Status"::Unregistered;
            end;
        }

        field(50208; "BBG 206AB"; Boolean)
        {
            Caption = '206AB';
            DataClassification = ToBeClassified;
            Description = 'TDS Related';
        }
        field(50302; "BBG Address Proof Type"; Text[50])
        {
            Caption = 'Address Proof Type';
            DataClassification = ToBeClassified;
            Editable = false;
        }


        field(50307; "BBG Deactivate"; Boolean)
        {
            Caption = 'Deactivate';
            DataClassification = ToBeClassified;
        }
        field(50310; "BBG Associate Type"; Option)
        {
            Caption = 'Associate Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Temporary,Permanent';
            OptionMembers = "Temporary",Permanent;
        }
        field(50311; "BBG Presence on Social Media"; Text[60])
        {
            Caption = 'Presence on Social Media';
            DataClassification = ToBeClassified;
        }
        field(50312; "BBG Reporting Leader"; Boolean)
        {
            Caption = 'Reporting Leader';
            DataClassification = ToBeClassified;
        }
        field(50313; "BBG Reporting Leader Code"; Code[20])
        {
            Caption = 'Reporting Leader Code';
            DataClassification = ToBeClassified;
        }
        field(50314; "BBG Is Help Desk User"; Boolean)
        {
            Caption = 'Is Help Desk User';
            DataClassification = ToBeClassified;
        }
        field(50315; "BBG Payable G/L Account No."; Code[20])
        {
            Caption = 'Payable G/L Account No.';
            CalcFormula = Lookup("Vendor Posting Group"."Payables Account" WHERE(Code = FIELD("Vendor Posting Group")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "G/L Account";
        }
        field(50316; "BBG New Cluster Code"; Code[20])
        {
            Caption = 'New Cluster Code';
            DataClassification = ToBeClassified;
            TableRelation = "New Cluster Master";
        }
        field(50318; "Region/Districts Code"; Code[50])
        {
            Caption = 'Region/Districts Code';
            DataClassification = ToBeClassified;
            trigger OnLookup()
            var
                Region_DistrictsRankEntry: Record "Region/Districts Rank Entry";
            begin
                Region_DistrictsRankEntry.reset;
                IF Region_DistrictsRankEntry.FindSet() then begin
                    IF PAGE.RUNMODAL(50230, Region_DistrictsRankEntry) = Action::LookupOK THEN BEGIN
                        "Region/Districts Code" := Region_DistrictsRankEntry."Region_Districts Code";

                    END;
                end;


            end;

        }


        field(60002; "BBG Exists Rank Parent"; Boolean)
        {
            Caption = 'Exists Rank Parent';
            DataClassification = ToBeClassified;
        }
        field(50317; "BBG IC Partner Code"; Code[20])
        {
            Caption = 'BBG IC Partner Code';
            TableRelation = "IC Partner";

            trigger OnValidate()
            var
                VendLedgEntry: Record "Vendor Ledger Entry";
                AccountingPeriod: Record "Accounting Period";
                ICPartner: Record "IC Partner";
                ConfirmManagement: Codeunit "Confirm Management";
            begin
                if xRec."IC Partner Code" <> "IC Partner Code" then begin
                    if not VendLedgEntry.SetCurrentKey("Vendor No.", Open) then
                        VendLedgEntry.SetCurrentKey("Vendor No.");
                    VendLedgEntry.SetRange("Vendor No.", "No.");
                    VendLedgEntry.SetRange(Open, true);
                    if VendLedgEntry.FindLast() then;
                    // Error(Text010, FieldCaption("IC Partner Code"), TableCaption); //ALLEDK 140824 commented code

                    VendLedgEntry.Reset();
                    VendLedgEntry.SetCurrentKey("Vendor No.", "Posting Date");
                    VendLedgEntry.SetRange("Vendor No.", "No.");
                    AccountingPeriod.SetRange(Closed, false);
                    if AccountingPeriod.FindFirst() then begin
                        VendLedgEntry.SetFilter("Posting Date", '>=%1', AccountingPeriod."Starting Date");
                        if VendLedgEntry.FindFirst() then;
                        //if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text009, TableCaption), true) then //ALLEDK 140824 commented code
                        //   "IC Partner Code" := xRec."IC Partner Code"; //ALLEDK 140824 commented code
                    end;
                end;

                if "BBG IC Partner Code" <> '' then begin
                    ICPartner.Get("BBG IC Partner Code");
                    if (ICPartner."Vendor No." <> '') and (ICPartner."Vendor No." <> "No.") then
                        Error(Text008, FieldCaption("BBG IC Partner Code"), "BBG IC Partner Code", TableCaption(), ICPartner."Vendor No.");
                    ICPartner."Vendor No." := "No.";
                    ICPartner.Modify();
                end;

                if (xRec."BBG IC Partner Code" <> "BBG IC Partner Code") and ICPartner.Get(xRec."BBG IC Partner Code") then begin
                    ICPartner."Vendor No." := '';
                    ICPartner.Modify();
                end;
            end;
        }

        field(60003; "Sub Vendor Category"; Code[10])           //02062025 Added new field
        {
            Caption = 'Sub Vendor Category';
            DataClassification = ToBeClassified;
            TableRelation = "Rank Code Master".Code where("Use for CP only" = const(true));
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF Rec."Sub Vendor Category" <> '' then
                    TestField("BBG Vendor Category", "BBG Vendor Category"::"CP(Channel Partner)");

            end;
        }

        field(60040; "District Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'District Code';
            DataClassification = ToBeClassified;
            TableRelation = "District Details".Code where("State Code" = field("State Code"));
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Rec.TestField("Mandal Code", '');
                Rec.TestField("Village Code", '');
            end;
        }
        field(60041; "Mandal Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Mandal Code';
            DataClassification = ToBeClassified;
            TableRelation = "Mandal Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"));
            trigger OnValidate()
            var
                myInt: Integer;
            begin

                Rec.TestField("Village Code", '');
            end;
        }
        field(60042; "Village Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Village Code';
            DataClassification = ToBeClassified;
            TableRelation = "Village Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"), "Mandal Code" = field("Mandal Code"));
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        "---Alle()---": Integer;
        MasterSetup: Record "Master Mandatory Setup";
        RecRef: RecordRef;
        VendCat: Text[9];
        LastVend: Text[9];
        ProductVendor: Record "Product Vendor";
        Vendor: Record Vendor;
        StartNo: Text[10];
        VarInteger: Integer;

        Vend: Record Vendor;
        UnitSetup: Record "Unit Setup";
        CompanywiseAccount: Record "Company wise G/L Account";
        RecCompwiseAcc: Record "Company wise G/L Account";
        CKVEND: Record Vendor;
        LandvendorLoginDetails: Record "Land vendor Login Details";  //251124 
        LandVendor_GUIDDetails: Record "Land Vendor_GUID Details";  //251124 
        Text008: Label 'The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3.';
        Text016: Label 'ENU=Duplicate PAN No. %1';
        Text017: Label 'ENU=Duplicate Acknowledgement Receipt No.';
        Text018: Label 'ENU=P.A.N. No. should be of 10 digits.';
        Memberof: Record "Access Control";
        AssociateLoginDetails: Record "Associate Login Details";
        "--------------------": Integer;
        pos: Integer;
        result: Text;
        IsNumeric: Boolean;
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnAfterInsert()
    begin
        //NDALLE 051107 begin
        ////NDALLE 051107 begin
        RecRef.GETTABLE(Rec);
        MasterSetup.MasterValidate(RecRef);
        ////NDALLE 051107 END
        //"Creation Date" := TODAY;  // ALLEPG 040712
        HistoryFunction(0, 'INSERT');
        IF "BBG Date of Joining" = 0D THEN
            "BBG Date of Joining" := TODAY;
        IF "BBG Date of Birth" = 0D THEN
            "BBG Date of Birth" := 00000101D;
        "BBG Sex" := "BBG Sex"::Male;
        "BBG Marital Status" := "BBG Marital Status"::Unmarried;
        "BBG Nationality" := 'INDIAN';
        "BBG Associate Creation" := "BBG Associate Creation"::New;
        "Tax Liable" := TRUE;
        IF "BBG Creation Date" = 0D THEN
            "BBG Creation Date" := WORKDATE;//ALLECK 270313
        "BBG Print Associate Name/Mobile" := TRUE;
        "BBG Created By" := USERID; //220524
        "Country/Region Code" := 'IN';  //Code added 01082025
    end;

    trigger OnAfterModify()
    begin
        HistoryFunction(0, 'MODIFY');
    end;

    trigger OnAfterDelete()
    var
        usersetup: Record "User Setup";
    begin
        IF "No." <> '' THEN BEGIN
            usersetup.RESET;
            usersetup.GET(USERID);
            IF NOT usersetup."Vendor Delete Permission" THEN
                ERROR('Please contact Admin Department');
        End;
    end;


    LOCAL PROCEDURE UpdateDedPANRefNo();
    VAR
    //Form26Q27QEntry: Record "Form 26Q/27Q Entry";// 16505;
    BEGIN
        // Form26Q27QEntry.RESET;
        // Form26Q27QEntry.SETRANGE(Revised, FALSE);
        // Form26Q27QEntry.SETRANGE(Filed, FALSE);
        // Form26Q27QEntry.SETRANGE("Party Type", Form26Q27QEntry."Party Type"::Vendor);
        // Form26Q27QEntry.SETRANGE("Party Code", "No.");
        // IF Form26Q27QEntry.FINDFIRST THEN
        //     Form26Q27QEntry.MODIFYALL("Deductee P.A.N. Ref. No.", "P.A.N. Reference No.");
    END;







    PROCEDURE CreateVendorFromWeb(NewVendor: Record "Portal Login"; VAR VendorNo: Code[30]): Code[30];
    VAR
        Vendor1: Record Vendor;
    BEGIN
        // ALLEPG 051012 Start
        Vendor1.INIT;
        NoSeriesMgt.InitSeries('AGENT', '', 0D, Vendor1."No.", Vendor1."No. Series");
        //ALLE-RM-START
        Vendor1.Name := NewVendor.Name;
        Vendor1."E-Mail" := NewVendor.EmailID;
        Vendor1."BBG Sex" := NewVendor.Sex;
        Vendor1."BBG Date of Birth" := NewVendor."Date Of Birth";
        Vendor1."Country/Region Code" := NewVendor.Country;
        Vendor1."Post Code" := NewVendor."Postal Code";
        Vendor1."BBG Mob. No." := NewVendor."Mobile No.";
        Vendor1."P.A.N. No." := NewVendor."P.A.N No.";
        IF Vendor1.INSERT(TRUE) THEN
            VendorNo := Vendor1."No.";
        //ALLE-RM-END
        // ALLEPG 051012 End
    END;
    //251124 New Code Start

    procedure CreateLandVendorlogin()
    begin
        //081024 Create new function---
        TESTFIELD("P.A.N. No.");
        TESTFIELD("BBG Aadhar No.");
        LandvendorLoginDetails.RESET;
        LandvendorLoginDetails.SETRANGE("P.A.N. No.", "P.A.N. No.");
        LandvendorLoginDetails.SETRANGE("Aadhar No.", "BBG Aadhar No.");
        IF NOT LandvendorLoginDetails.FINDFIRST THEN BEGIN
            LandvendorLoginDetails.INIT;
            LandvendorLoginDetails."No." := "No.";
            LandvendorLoginDetails.Name := Name;
            LandvendorLoginDetails.Address := Address;
            LandvendorLoginDetails."Address 2" := "Address 2";
            LandvendorLoginDetails.City := City;
            LandvendorLoginDetails."Father Name" := "BBG Father Name";
            LandvendorLoginDetails."Country/Region Code" := "Country/Region Code";
            LandvendorLoginDetails."Post Code" := "Post Code";
            LandvendorLoginDetails."P.A.N. No." := "P.A.N. No.";
            LandvendorLoginDetails."State Code" := "State Code";
            LandvendorLoginDetails."Mob. No." := "BBG Mob. No.";
            LandvendorLoginDetails."Date of Birth" := "BBG Date of Birth";
            IF "BBG Associate Password" = '' THEN
                LandvendorLoginDetails."Associate Password" := 'BBG@1234'
            ELSE
                LandvendorLoginDetails."Associate Password" := "BBG Associate Password";
            LandvendorLoginDetails."Aadhar No." := "BBG Aadhar No.";
            LandvendorLoginDetails."Is Verified" := TRUE;
            //Code added Start 23072025
            LandvendorLoginDetails."District Code" := "District Code";
            LandvendorLoginDetails."State Code" := "State Code";
            LandvendorLoginDetails."Mandal Code" := "Mandal Code";
            LandvendorLoginDetails."Village Code" := "Village Code";
            LandvendorLoginDetails."Aadhar No." := "BBG Aadhar No.";
            //Code added END 23072025
            LandvendorLoginDetails.INSERT;

            LandVendor_GUIDDetails.INIT;
            LandVendor_GUIDDetails.Token_ID := CREATEGUID;
            LandVendor_GUIDDetails.USER_ID := "No.";
            LandVendor_GUIDDetails.INSERT;
        END;
    END;
    //251124 New Code END
}