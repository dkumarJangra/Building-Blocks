report 50052 "New Change Chain"
{
    // version Done

    // BBG1.7 030114 Added code for check Parent code change entries exists or not.

    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Region wise Vendor"; "Region wise Vendor")
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            var
                OtherEvents: codeunit "Other Event Mgnt";
                TeamCode: code[50];
            begin
                //BBG1.7 030114
                CLEAR(RankChangeHistory);
                RankChangeHistory.RESET;
                RankChangeHistory.SETRANGE("Rank Code", RegionCode1);
                RankChangeHistory.SETRANGE(MMCode, "No.");
                RankChangeHistory.SETRANGE("Authorisation Date", Date);
                IF RankChangeHistory.FINDSET THEN
                    REPEAT
                        IF RankChangeHistory."Old Parent Code" <> RankChangeHistory."New Parent Code" THEN
                            ERROR(Text006);
                    UNTIL RankChangeHistory.NEXT = 0;
                //BBG1.7 030114
                /*
                CLEAR(Change);
                VendTree.RESET;
                VendTree.SETRANGE("Introducer Code","No.");
                VendTree.SETRANGE("Effective Date",Date);
                IF VendTree.FINDSET THEN BEGIN
                  IF NOT CONFIRM(Text005,TRUE,Date) THEN
                     CurrReport.SKIP
                  ELSE BEGIN
                    VendTree.DELETEALL;
                    Change:= TRUE;
                  END;
                END ELSE
                  Change:= TRUE;
                 */

                LastNo += 1;
                RankChangeHistory.INIT;
                RankChangeHistory."Entry No" := LastNo;
                RankChangeHistory.MMCode := "No.";
                RankChangeHistory.VALIDATE(RankChangeHistory.MMCode);
                RankChangeHistory."Authorised Person" := Authority;
                RankChangeHistory."Authorisation Date" := Date;
                RankChangeHistory.Remarks := Remarks;
                RankChangeHistory."Previous Rank" := "Rank Code";
                RankChangeHistory."New Rank" := "Rank Code";
                RankChangeHistory."Old Parent Code" := "Parent Code";
                RankChangeHistory."Parent Rank Old" := "Parent Rank";
                RankChangeHistory."New Parent Code" := NewParent;
                RankChangeHistory."Parent Rank New" := NewParentRank;
                RankChangeHistory."Rank Code" := RegionCode1;
                RankChangeHistory."USER ID" := USERID;
                RankChangeHistory."Modification Date" := TODAY;
                RankChangeHistory."Modification Time" := TIME;
                RankChangeHistory.INSERT;

                VALIDATE("Parent Code", NewParent);
                MODIFY;
                //Ankur 09122025
                TeamCode := OtherEvents.ReturnTeamCode(NewParent, "Region Code", "Region wise Vendor"."No.", true);  //Code added

            end;

            trigger OnPostDataItem()
            var
                VRankCode: Record "Rank Code";
                PVendor: Record Vendor;
            begin
                COMMIT;
                IF "Parent Code" <> '' THEN
                    PVendor.GET("Parent Code");
                CompanyInfo.RESET;
                CompanyInfo.SETRANGE("Send SMS", TRUE);
                IF CompanyInfo.FINDFIRST THEN BEGIN
                    VRankCode.RESET;
                    VRankCode.SETRANGE(VRankCode."Rank Batch Code", RegionCode1);
                    VRankCode.SETRANGE(VRankCode.Code, NewParentRank);
                    IF VRankCode.FINDFIRST THEN;

                    CLEAR(NewAssociateBottom);
                    //  NewAssociateBottom.SetfValues("No.",RegionCode1,FALSE,FALSE,FALSE,TRUE,VRankCode.Description,Date);
                    NewAssociateBottom.SetfValues("No.", RegionCode1, FALSE, FALSE, FALSE, TRUE, PVendor.Name, Date);
                    NewAssociateBottom.RUNMODAL;
                END;



                MESSAGE(Text004, "No.");
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Region Code", RegionCode1);
                SETRANGE("No.", MMCode);
                RankChangeHistory.RESET;
                IF RankChangeHistory.FINDLAST THEN
                    LastNo := RankChangeHistory."Entry No";
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("MM Code"; MMCode)
                {
                    Editable = false;
                    TableRelation = Vendor;
                    ApplicationArea = All;
                }
                field(Name; MMName)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Old Parent"; ParentCode)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Parent Name"; ParentName)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("New Parent"; NewParent)
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        IF MMCode = '' THEN
                            ERROR('');
                        Vendor2.RESET;
                        Vendor2.SETFILTER("No.", '<>%1', ParentCode);
                        Vendor2.SETFILTER(Status, '<>%1', Vendor2.Status::Inactive);
                        //Vendor2.SETFILTER("Rank Code",'>=%1',ParentRank);   //BBG1.00 100913
                        Vendor2.SETFILTER("Rank Code", '>%1', MMRank);  //BBG1.00 100913
                        IF Vendor2.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(0, Vendor2) = ACTION::LookupOK THEN BEGIN
                                NewParent := Vendor2."No.";//New Parent Code
                                NewParentRank := Vendor2."Rank Code";//New Parent Rank
                                NewParentName := Vendor2.Name;//New Parent Name
                            END;
                        END;
                    end;

                    trigger OnValidate()
                    begin

                        IF MMCode = '' THEN
                            ERROR('');
                        Vendor2.GET(RegionCode1, NewParent);
                        IF Vendor2.Status = Vendor2.Status::Inactive THEN
                            ERROR(Text001, Vendor2."No.");
                        NewParentRank := Vendor2."Rank Code";//New Parent Rank
                        NewParentName := Vendor2.Name;//New Parent Name
                        IF NewParentRank <= MMRank THEN
                            ERROR(Text002, MMRank);
                    end;
                }
                field("New Parent Name"; NewParentName)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Authorised Person"; Authority)
                {
                    ApplicationArea = All;
                }
                field(Remark; Remarks)
                {
                    ApplicationArea = All;
                }
                field("Authorisation Date"; Date)
                {
                    ApplicationArea = All;
                }
            }
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
        UserSetup.GET(USERID);
        IF NOT UserSetup."MM Chain Management" THEN
            ERROR(Text000);
        Date := TODAY;
    end;

    trigger OnPostReport()
    begin
        IF Change THEN BEGIN
            UnitPost.NewInsertVendorTree("Region wise Vendor", Date);//ALLETDk
            VendTree.RESET;
            VendTree.SETRANGE("Parent Code", "Region wise Vendor"."No.");
            VendTree.SETRANGE(Status, VendTree.Status::Active);
            VendTree.SETRANGE("Region/Rank Code", RegionCode1);
            IF VendTree.FINDSET THEN
                REPEAT
                    CLEAR(UnitPost);
                    Vend.GET(RegionCode1, VendTree."Introducer Code");
                    UnitPost.NewInsertVendorTree(Vend, Date);//ALLETDk
                UNTIL VendTree.NEXT = 0;
        END;
    end;

    trigger OnPreReport()
    begin
        IF (MMCode = '') OR (NewParent = '') OR (Authority = '') OR (Date = 0D) THEN
            ERROR(Text003);

        IF NewParent = ParentCode THEN
            ERROR('New parent code must not be same as old parent code.');
    end;

    var
        ParentCode: Code[10];
        ParentRank: Decimal;
        Vendor2: Record "Region wise Vendor";
        NewParent: Code[20];
        NewParentRank: Decimal;
        RankChangeHistory: Record "Rank Change History";
        LastNo: Integer;
        Authority: Text[50];
        Date: Date;
        Remarks: Text[250];
        OldRank: Decimal;
        OldParent: Code[10];
        OldParentRank: Decimal;
        MMCode: Code[20];
        MMRank: Decimal;
        MMName: Text[30];
        ParentName: Text[30];
        NewParentName: Text[30];
        UserSetup: Record "User Setup";
        UnitPost: Codeunit "Unit Post";
        VendTree: Record "Vendor Tree";
        Change: Boolean;
        Application: Record Application;
        ConOrder: Record "Confirmed Order";
        Vend: Record "Region wise Vendor";
        RegionCode1: Code[10];
        Text000: Label 'You are not allowed to Change Marketing Member Chain.';
        Text001: Label 'Marketing Member Code %1 is inactive.';
        Text002: Label 'New Parent Rank must be greater than %1.';
        Text003: Label 'Invalid Parameters.';
        Text004: Label 'Parent Code for Marketing Member Code %1 changed successfully.';
        Text005: Label 'Associate Tree already exist on Date %1. Do you want to replace the Tree?';
        Text006: Label 'You have already changed Parent code on this Date.';
        CompanyInfo: Record "Company Information";
        NewAssociateBottom: Report "New Associate Bottom To Top_1";

    procedure InitVar()
    begin
        MMRank := 0;
        MMName := '';
        ParentCode := '';
        ParentRank := 0;
        ParentName := '';

        ParentCode := '';
        ParentRank := 0;
        ParentName := '';
    end;

    procedure FindMMandParent(MMC: Code[20]; RegionCode: Code[10])
    begin
        Vendor2.GET(RegionCode, MMC);
        MMCode := MMC;
        MMName := Vendor2.Name;
        RegionCode1 := RegionCode;
        MMRank := Vendor2."Rank Code";//Rank of MM
        ParentCode := Vendor2."Parent Code";//old parent code
        ParentRank := Vendor2."Parent Rank";//old parent rank
        Vendor2.GET(RegionCode1, Vendor2."Parent Code");
        ParentName := Vendor2.Name;//old parent name
    end;
}

