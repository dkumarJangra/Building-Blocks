page 50293 "Associate Target Request"
{
    Caption = 'Associate Target Request';
    PageType = List;
    SourceTable = "Target View Entry Table";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Matrix Filters")
            {
                field(Monthly; Rec.Monthly)
                {
                }
                field(Year; Rec.Year)
                {

                    trigger OnValidate()
                    begin
                        Year1 := 0;
                        Year1 := DATE2DMY(TODAY, 3);
                        IF Rec.Year < Year1 THEN
                            ERROR('Year can not be less than current year');

                        IF NOT Rec.Monthly THEN
                            ERROR('Monthly should be Tick');
                    end;
                }
                field(Month; Rec.Month)
                {

                    trigger OnValidate()
                    begin

                        IF NOT Rec.Monthly THEN
                            ERROR('Monthly should be Tick');

                        IF Rec.Year = 0 THEN
                            ERROR('Year can not be blank');

                        IF Rec.Month = Rec.Month::" " THEN BEGIN
                            FromDate := 0D;
                            ToDate := 0D;
                        END;


                        IF Rec.Month = Rec.Month::Jan THEN
                            MonthNo := 1
                        ELSE
                            IF Rec.Month = Rec.Month::Feb THEN
                                MonthNo := 2
                            ELSE
                                IF Rec.Month = Rec.Month::March THEN
                                    MonthNo := 3
                                ELSE
                                    IF Rec.Month = Rec.Month::April THEN
                                        MonthNo := 4
                                    ELSE
                                        IF Rec.Month = Rec.Month::May THEN
                                            MonthNo := 5
                                        ELSE
                                            IF Rec.Month = Rec.Month::June THEN
                                                MonthNo := 6
                                            ELSE
                                                IF Rec.Month = Rec.Month::July THEN
                                                    MonthNo := 7
                                                ELSE
                                                    IF Rec.Month = Rec.Month::Aug THEN
                                                        MonthNo := 8
                                                    ELSE
                                                        IF Rec.Month = Rec.Month::Sept THEN
                                                            MonthNo := 9
                                                        ELSE
                                                            IF Rec.Month = Rec.Month::Oct THEN
                                                                MonthNo := 10
                                                            ELSE
                                                                IF Rec.Month = Rec.Month::Nov THEN
                                                                    MonthNo := 11
                                                                ELSE
                                                                    IF Rec.Month = Rec.Month::Dec THEN
                                                                        MonthNo := 12;


                        IF (MonthNo = 1) OR (MonthNo = 3) OR (MonthNo = 5) OR (MonthNo = 7) OR (MonthNo = 8) OR (MonthNo = 10) OR (MonthNo = 12) THEN BEGIN
                            FromDate := DMY2DATE(1, MonthNo, Rec.Year);
                            ToDate := DMY2DATE(31, MonthNo, Rec.Year);
                        END ELSE
                            IF (MonthNo = 4) OR (MonthNo = 6) OR (MonthNo = 9) OR (MonthNo = 11) THEN BEGIN
                                FromDate := DMY2DATE(1, MonthNo, Rec.Year);
                                ToDate := DMY2DATE(30, MonthNo, Rec.Year);
                            END ELSE
                                IF MonthNo = 2 THEN BEGIN
                                    IF (Rec.Year MOD 4) = 0 THEN BEGIN
                                        FromDate := DMY2DATE(1, MonthNo, Rec.Year);
                                        ToDate := DMY2DATE(28, MonthNo, Rec.Year);
                                    END ELSE BEGIN
                                        FromDate := DMY2DATE(1, MonthNo, Rec.Year);
                                        ToDate := DMY2DATE(29, MonthNo, Rec.Year);
                                    END;


                                END;
                    end;
                }
                field("From Date"; FromDate)
                {

                    trigger OnValidate()
                    begin
                        IF Rec.Month <> Rec.Month::" " THEN
                            ERROR('First delet the Month');
                    end;
                }
                field("To Date"; ToDate)
                {

                    trigger OnValidate()
                    begin
                        IF Rec.Month <> Rec.Month::" " THEN
                            ERROR('First delet the Month');
                    end;
                }
                field("No. of Days"; NoofDays)
                {

                    trigger OnValidate()
                    begin
                        RequestClosingDate := CALCDATE(NoofDays, TODAY);
                    end;
                }
                field("Request Closing Date"; RequestClosingDate)
                {
                    Editable = false;
                }
                field("Request Closing Time"; RequestClosingTime)
                {
                }
                field("Leader Code Filter"; LeaderCodeFilter)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LeaderMasterList: Page "Leader Master";
                    begin
                        LeaderMasterList.LOOKUPMODE(TRUE);
                        IF LeaderMasterList.RUNMODAL = ACTION::LookupOK THEN
                            LeaderCodeFilter := LeaderMasterList.GetSelectionFilter;
                    end;
                }
                field("Team Name"; TeamName)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        TeamMasterList: Page "Team Master List";
                    begin

                        TeamMasterList.LOOKUPMODE(TRUE);
                        IF TeamMasterList.RUNMODAL = ACTION::LookupOK THEN
                            TeamName := TeamMasterList.GetSelectionFilter;
                    end;
                }
                field(Designation; AssociateDesignation)
                {
                }
                field("Designation Name"; DesignationName)
                {
                    Visible = false;
                }
                field("Associate Filter"; AssociateFilter)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        VendorList: Page "Vendor List";
                        Vendor_L: Record Vendor;
                    begin
                        Vendor_L.RESET;
                        Vendor_L.SETRANGE("BBG Vendor Category", Vendor_L."BBG Vendor Category"::"IBA(Associates)");
                        IF Vendor_L.FINDSET THEN;
                        VendorList.SETTABLEVIEW(Vendor_L);
                        VendorList.LOOKUPMODE(TRUE);
                        IF VendorList.RUNMODAL = ACTION::LookupOK THEN
                            AssociateFilter := VendorList.GetSelectionFilter;
                    end;
                }
                field("Field Type Filter"; FiledTypeFilter)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        TargetFieldMasterList: Page "Target Field Master List";
                    begin
                        TargetFieldMasterList.LOOKUPMODE(TRUE);
                        IF TargetFieldMasterList.RUNMODAL = ACTION::LookupOK THEN
                            FiledTypeFilter := TargetFieldMasterList.GetSelectionFilter;
                    end;
                }
            }
            repeater(Group)
            {
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Team Code"; Rec."Team Code")
                {
                }
                field("Leader Code"; Rec."Leader Code")
                {
                }
                field("Associate Exclude"; Rec."Associate Exclude")
                {
                }
                field("Field Type"; Rec."Field Type")
                {
                }
                field("Field Type Value"; Rec."Field Type Value")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Entries")
            {
                Image = process;
                Promoted = true;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to create Entries.') THEN BEGIN
                        TargetViewEntryTable.DELETEALL;
                        IF RequestClosingTime = 0T THEN
                            ERROR('Please insert Request Closing Time');
                        SNo := 0;
                        Vendor.RESET;
                        IF AssociateFilter <> '' THEN
                            Vendor.SETFILTER("No.", AssociateFilter);
                        IF TeamName <> '' THEN
                            Vendor.SETFILTER("BBG Team Code", TeamName);
                        IF LeaderCodeFilter <> '' THEN
                            Vendor.SETFILTER("BBG Leader Code", LeaderCodeFilter);
                        Vendor.SETRANGE("BBG Black List", FALSE);
                        Vendor.SETRANGE("BBG Status", Vendor."BBG Status"::Active);
                        Vendor.SETRANGE("BBG Vendor Category", Vendor."BBG Vendor Category"::"IBA(Associates)");
                        IF Vendor.FINDSET THEN
                            REPEAT
                                IF AssociateDesignation <> '' THEN BEGIN
                                    RegionwiseVendor.RESET;
                                    RegionwiseVendor.SETRANGE("No.", Vendor."No.");
                                    RegionwiseVendor.SETFILTER("Rank Code", AssociateDesignation);
                                    IF RegionwiseVendor.FINDFIRST THEN BEGIN
                                        IF FiledTypeFilter <> '' THEN BEGIN
                                            Targetfieldmaster.RESET;
                                            Targetfieldmaster.SETFILTER(Code, FiledTypeFilter);
                                            IF Targetfieldmaster.FINDSET THEN
                                                REPEAT
                                                    SNo := SNo + 1;
                                                    TargetViewEntryTable.INIT;
                                                    TargetViewEntryTable."Entry No." := SNo;
                                                    TargetViewEntryTable."Associate Code" := Vendor."No.";
                                                    TargetViewEntryTable."Associate Name" := Vendor.Name;
                                                    TargetViewEntryTable."Team Code" := Vendor."BBG Team Code";
                                                    TargetViewEntryTable."Field Type" := Targetfieldmaster.Code;
                                                    TargetViewEntryTable."Field Type Value" := TRUE;
                                                    TargetViewEntryTable.Monthly := Rec.Monthly;
                                                    TargetViewEntryTable.Month := Rec.Month;
                                                    TargetViewEntryTable.Year := Rec.Year;
                                                    TargetViewEntryTable."From Date" := FromDate;
                                                    TargetViewEntryTable."To Date" := ToDate;
                                                    TargetViewEntryTable.Designation := RegionwiseVendor."Rank Code";
                                                    TargetViewEntryTable."No. of Days" := NoofDays;
                                                    TargetViewEntryTable."Request Closing Date" := RequestClosingDate;
                                                    TargetViewEntryTable."Creation Date" := TODAY;
                                                    TargetViewEntryTable."Request Creation Time" := TIME;
                                                    TargetViewEntryTable."Request Closing Time" := RequestClosingTime;
                                                    TargetViewEntryTable."Leader Code" := Vendor."BBG Leader Code";
                                                    TargetViewEntryTable.TargetSubmittedDateTime := CREATEDATETIME(RequestClosingDate, RequestClosingTime);
                                                    TargetViewEntryTable.INSERT;
                                                UNTIL Targetfieldmaster.NEXT = 0;
                                        END ELSE BEGIN
                                            Targetfieldmaster.RESET;
                                            IF Targetfieldmaster.FINDSET THEN
                                                REPEAT
                                                    SNo := SNo + 1;
                                                    TargetViewEntryTable.INIT;
                                                    TargetViewEntryTable."Entry No." := SNo;
                                                    TargetViewEntryTable."Associate Code" := Vendor."No.";
                                                    TargetViewEntryTable."Associate Name" := Vendor.Name;
                                                    TargetViewEntryTable."Team Code" := Vendor."BBG Team Code";
                                                    TargetViewEntryTable."Field Type" := Targetfieldmaster.Code;
                                                    TargetViewEntryTable."Field Type Value" := TRUE;
                                                    TargetViewEntryTable.Monthly := Rec.Monthly;
                                                    TargetViewEntryTable.Month := Rec.Month;
                                                    TargetViewEntryTable.Year := Rec.Year;
                                                    TargetViewEntryTable."From Date" := FromDate;
                                                    TargetViewEntryTable."To Date" := ToDate;
                                                    TargetViewEntryTable.Designation := RegionwiseVendor."Rank Code";
                                                    TargetViewEntryTable."No. of Days" := NoofDays;
                                                    TargetViewEntryTable."Request Closing Date" := RequestClosingDate;
                                                    TargetViewEntryTable."Creation Date" := TODAY;
                                                    TargetViewEntryTable."Request Creation Time" := TIME;
                                                    TargetViewEntryTable."Request Closing Time" := RequestClosingTime;
                                                    TargetViewEntryTable."Leader Code" := Vendor."BBG Leader Code";
                                                    TargetViewEntryTable.TargetSubmittedDateTime := CREATEDATETIME(RequestClosingDate, RequestClosingTime);
                                                    TargetViewEntryTable.INSERT;
                                                UNTIL Targetfieldmaster.NEXT = 0;
                                        END;
                                    END;
                                END ELSE BEGIN
                                    IF FiledTypeFilter <> '' THEN BEGIN
                                        Targetfieldmaster.RESET;
                                        Targetfieldmaster.SETFILTER(Code, FiledTypeFilter);
                                        IF Targetfieldmaster.FINDSET THEN
                                            REPEAT
                                                SNo := SNo + 1;
                                                TargetViewEntryTable.INIT;
                                                TargetViewEntryTable."Entry No." := SNo;
                                                TargetViewEntryTable."Associate Code" := Vendor."No.";
                                                TargetViewEntryTable."Associate Name" := Vendor.Name;
                                                TargetViewEntryTable."Team Code" := Vendor."BBG Team Code";
                                                TargetViewEntryTable."Field Type" := Targetfieldmaster.Code;
                                                TargetViewEntryTable."Field Type Value" := TRUE;
                                                TargetViewEntryTable.Monthly := Rec.Monthly;
                                                TargetViewEntryTable.Month := Rec.Month;
                                                TargetViewEntryTable.Year := Rec.Year;
                                                TargetViewEntryTable."From Date" := FromDate;
                                                TargetViewEntryTable."To Date" := ToDate;
                                                TargetViewEntryTable.Designation := RegionwiseVendor."Rank Code";
                                                TargetViewEntryTable."No. of Days" := NoofDays;
                                                TargetViewEntryTable."Request Closing Date" := RequestClosingDate;
                                                TargetViewEntryTable."Creation Date" := TODAY;
                                                TargetViewEntryTable."Request Creation Time" := TIME;
                                                TargetViewEntryTable."Request Closing Time" := RequestClosingTime;
                                                TargetViewEntryTable."Leader Code" := Vendor."BBG Leader Code";
                                                TargetViewEntryTable.TargetSubmittedDateTime := CREATEDATETIME(RequestClosingDate, RequestClosingTime);
                                                TargetViewEntryTable.INSERT;
                                            UNTIL Targetfieldmaster.NEXT = 0;
                                    END ELSE BEGIN
                                        Targetfieldmaster.RESET;
                                        IF Targetfieldmaster.FINDSET THEN
                                            REPEAT
                                                SNo := SNo + 1;
                                                TargetViewEntryTable.INIT;
                                                TargetViewEntryTable."Entry No." := SNo;
                                                TargetViewEntryTable."Associate Code" := Vendor."No.";
                                                TargetViewEntryTable."Associate Name" := Vendor.Name;
                                                TargetViewEntryTable."Team Code" := Vendor."BBG Team Code";
                                                TargetViewEntryTable."Field Type" := Targetfieldmaster.Code;
                                                TargetViewEntryTable."Field Type Value" := TRUE;
                                                TargetViewEntryTable.Monthly := Rec.Monthly;
                                                TargetViewEntryTable.Month := Rec.Month;
                                                TargetViewEntryTable.Year := Rec.Year;
                                                TargetViewEntryTable."From Date" := FromDate;
                                                TargetViewEntryTable."To Date" := ToDate;
                                                TargetViewEntryTable.Designation := RegionwiseVendor."Rank Code";
                                                TargetViewEntryTable."No. of Days" := NoofDays;
                                                TargetViewEntryTable."Request Closing Date" := RequestClosingDate;
                                                TargetViewEntryTable."Creation Date" := TODAY;
                                                TargetViewEntryTable."Request Creation Time" := TIME;
                                                TargetViewEntryTable."Request Closing Time" := RequestClosingTime;
                                                TargetViewEntryTable."Leader Code" := Vendor."BBG Leader Code";
                                                TargetViewEntryTable.TargetSubmittedDateTime := CREATEDATETIME(RequestClosingDate, RequestClosingTime);
                                                TargetViewEntryTable.INSERT;
                                            UNTIL Targetfieldmaster.NEXT = 0;
                                    END;
                                END;
                            UNTIL Vendor.NEXT = 0;
                        CurrPage.UPDATE(TRUE);
                        MESSAGE('Entries has been created');
                    END;
                end;
            }
            action("Submit Entries")
            {
                Image = process;
                Promoted = true;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Associate Target Request No.");
                    RequestNo := NoSeriesManagement.GetNextNo(BBGSetups."Associate Target Request No.", TODAY, TRUE);
                    IF CONFIRM('Do you want to Submit the Entries') THEN BEGIN
                        NewTargetViewEntryTable.RESET;
                        NewTargetViewEntryTable.SETRANGE("Associate Exclude", FALSE);
                        IF NewTargetViewEntryTable.FINDSET THEN
                            REPEAT
                                TargetSubmissionEntryDetals.INIT;
                                TargetSubmissionEntryDetals.TRANSFERFIELDS(NewTargetViewEntryTable);
                                TargetSubmissionEntryDetals."Request No." := RequestNo;
                                TargetSubmissionEntryDetals."Request Date" := TODAY;
                                TargetSubmissionEntryDetals.INSERT;

                                TargetSubmittedfromAssociat.INIT;
                                TargetSubmittedfromAssociat.TRANSFERFIELDS(TargetSubmissionEntryDetals);
                                TargetSubmittedfromAssociat.INSERT;
                            UNTIL NewTargetViewEntryTable.NEXT = 0;

                        MESSAGE('Entries has been Submitted');
                        COMMIT;
                        NewTargetViewEntryTable.DELETEALL;
                    END ELSE
                        MESSAGE('Nothing Done');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        TargetViewEntryTable.DELETEALL;
        LeaderCodeFilter := 'GOVERNING COUNCIL';

        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Target Functionality", FALSE);
        IF UserSetup.FINDFIRST THEN
            ERROR('Please contact admin');

        CompanywiseGLAccount.RESET;
        CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
        IF CompanywiseGLAccount.FINDFIRST THEN
            IF CompanywiseGLAccount."Company Code" <> COMPANYNAME THEN
                ERROR('This process will run in BBP company');
    end;

    var
        Monthly: Boolean;
        Month: Option " ",Jan,Feb,March,April,May,June,July,Aug,Sept,Oct,Nov,Dec;
        Year: Integer;
        FromDate: Date;
        ToDate: Date;
        NoofDays: DateFormula;
        RequestClosingDate: Date;
        AssociateDesignation: Text;
        AssociateFilter: Text;
        FiledTypeFilter: Text;
        DesignationName: Text;
        Vendor: Record Vendor;
        TeamName: Text;
        TargetViewEntryTable: Record "Target View Entry Table";
        Targetfieldmaster: Record "Target field master";
        TargetFieldCaption: array[50] of Text;
        SNo: Integer;
        TargetSubmissionEntryDetals: Record "Target Demand Entry Detals";
        NewTargetViewEntryTable: Record "Target View Entry Table";
        RequestNo: Code[20];
        RegionwiseVendor: Record "Region wise Vendor";
        RecVendor: Record Vendor;
        VendorList: Page "Vendor List";
        MonthNo: Integer;
        BBGSetups: Record "BBG Setups";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Year1: Integer;
        TeamMaster: Record "Team Master";
        TargetSubmittedfromAssociat: Record "Target Submitted from Associat";
        LeaderCodeFilter: Text;
        RequestClosingTime: Time;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        UserSetup: Record "User Setup";
}

