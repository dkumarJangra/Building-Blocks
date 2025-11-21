report 50051 "New Change Rank"
{
    // version Done

    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Region wise Vendor"; "Region wise Vendor")
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin

                //BBG1.7 030114
                CLEAR(RankChangeHistory);
                RankChangeHistory.RESET;
                RankChangeHistory.SETRANGE("Rank Code", RegionCode1);
                RankChangeHistory.SETRANGE(MMCode, "No.");
                RankChangeHistory.SETRANGE("Authorisation Date", Date);
                IF RankChangeHistory.FINDSET THEN
                    REPEAT
                        IF RankChangeHistory."Previous Rank" <> RankChangeHistory."New Rank" THEN
                            ERROR(Text002);
                    UNTIL RankChangeHistory.NEXT = 0;
                //BBG1.7 030114

                CLEAR(Change);
                VendTree.RESET;
                VendTree.SETRANGE("Introducer Code", "No.");
                VendTree.SETRANGE("Effective Date", Date);
                VendTree.SETRANGE("Region/Rank Code", RegionCode1);
                IF VendTree.FINDSET THEN BEGIN
                    IF NOT CONFIRM(Text001, TRUE, Date) THEN
                        CurrReport.SKIP
                    ELSE BEGIN
                        VendTree.DELETEALL;
                        Change := TRUE;
                    END;
                END ELSE
                    Change := TRUE;

                OldRank := "Rank Code";
                "Rank Code" := NewRank;

                MODIFY;

                LastNo += 1;
                RankChangeHistory.INIT;
                RankChangeHistory."Entry No" := LastNo;
                RankChangeHistory.MMCode := "No.";
                RankChangeHistory.VALIDATE(RankChangeHistory.MMCode);
                RankChangeHistory."Authorised Person" := Authority;
                RankChangeHistory."Authorisation Date" := Date;
                RankChangeHistory."Previous Rank" := OldRank;
                RankChangeHistory."New Rank" := NewRank;
                RankChangeHistory.Remarks := Remarks;
                RankChangeHistory."Old Parent Code" := "Parent Code";
                RankChangeHistory."Parent Rank Old" := "Parent Rank";
                IF NewParent <> '' THEN BEGIN
                    RankChangeHistory."New Parent Code" := NewParent;
                    RankChangeHistory."Parent Rank New" := NewParentRank;
                END ELSE BEGIN
                    RankChangeHistory."New Parent Code" := "Parent Code";
                    RankChangeHistory."Parent Rank New" := "Parent Rank";
                END;
                RankChangeHistory."Rank Code" := RegionCode1; //261114
                RankChangeHistory."USER ID" := USERID;
                RankChangeHistory."Modification Date" := TODAY;
                RankChangeHistory."Modification Time" := TIME;
                RankChangeHistory.INSERT;

                IF NewParent = '' THEN
                    VALIDATE("Parent Code")
                ELSE BEGIN
                    IF NewParentRank < OldParentRank THEN
                        ERROR('New Parent Rank must be greater than Old Parent Rank.');
                    VALIDATE("Parent Code", NewParent);
                END;

                VALIDATE("Rank Code");
                MODIFY;

                IF NOT (NewParent = '') THEN BEGIN
                    Vendor2.RESET;
                    Vendor2.SETRANGE("Region Code", RegionCode1);
                    Vendor2.SETRANGE(Vendor2."Parent Code", "No.");
                    IF Vendor2.FINDSET THEN
                        REPEAT
                            Vendor2.VALIDATE(Vendor2."Parent Code");
                            Vendor2.MODIFY;
                        UNTIL Vendor2.NEXT = 0;
                END;

                //MESSAGE('Rank Changed.');
            end;

            trigger OnPostDataItem()
            var
                VRankCode: Record "Rank Code";
                Vendorv_: Record Vendor;
            begin
                COMMIT;
                CompanyInfo.RESET;
                CompanyInfo.SETRANGE("Send SMS", TRUE);
                IF CompanyInfo.FINDFIRST THEN BEGIN
                    VRankCode.RESET;
                    VRankCode.SETRANGE(VRankCode."Rank Batch Code", RegionCode1);
                    VRankCode.SETRANGE(VRankCode.Code, NewRank);
                    IF VRankCode.FINDFIRST THEN;
                    IF NewRank > OldRank THEN BEGIN
                        CLEAR(NewAssociateBottom);
                        NewAssociateBottom.SetfValues("No.", RegionCode1, FALSE, TRUE, FALSE, FALSE, VRankCode.Description, Date);
                        NewAssociateBottom.RUNMODAL;
                    END;
                    IF OldRank > NewRank THEN BEGIN
                        CLEAR(NewAssociateBottom);
                        NewAssociateBottom.SetfValues("No.", RegionCode1, FALSE, FALSE, TRUE, FALSE, VRankCode.Description, Date);
                        NewAssociateBottom.RUNMODAL;
                    END;
                END;




                CLEAR(WebAppService);
                RegionwiseVendor.RESET;
                RegionwiseVendor.SETCURRENTKEY(RegionwiseVendor."No.");
                RegionwiseVendor.SETRANGE("No.", "No.");
                IF RegionwiseVendor.FINDFIRST THEN;
                RankCodeMaster.RESET;
                RankCodeMaster.SETRANGE("Rank Batch Code", RegionwiseVendor."Region Code");
                RankCodeMaster.SETRANGE(Code, RegionwiseVendor."Rank Code");
                IF RankCodeMaster.FINDFIRST THEN;
                Vendorv_.RESET;
                IF Vendorv_.GET("No.") THEN BEGIN
                    IF Vendorv_."BBG Black List" THEN
                        AssStatus := 'Deactivate'
                    ELSE
                        AssStatus := 'Active';
                END;

                WebAppService.Post_data('', "No.", Vendorv_.Name, Vendorv_."BBG Mob. No.", Vendorv_."E-Mail", Vendorv_."BBG Team Code", Vendorv_."BBG Leader Code", RegionwiseVendor."Parent Code",
                FORMAT(AssStatus), FORMAT(RegionwiseVendor."Rank Code"), RankCodeMaster.Description);
                //ALLEDK 221123


                MESSAGE('Rank Changed.');
            end;

            trigger OnPreDataItem()
            begin
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
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("New Rank"; NewRank)
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecRankCode: Record "Rank Code";
                    begin

                        RecRankCode.RESET;
                        RecRankCode.SETRANGE("Rank Batch Code", RegionCode1);
                        IF PAGE.RUNMODAL(PAGE::"Rank Code", RecRankCode) = ACTION::LookupOK THEN BEGIN
                            NewRank := RecRankCode.Code;
                        END;
                    end;
                }
                field("Old Parent"; OldParent)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Parent Name"; OldParentName)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("New Parent"; NewParent)
                {
                    ApplicationArea = All;
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
        IF NewRank = 0 THEN
            ERROR('Rank cannot be zero.');
        IF Authority = '' THEN
            ERROR('Please enter the name of the authorised person.');
        IF Date = 0D THEN
            ERROR('Date cannot be blank.');
    end;

    var
        OldRank: Decimal;
        NewRank: Decimal;
        Authority: Text[50];
        Date: Date;
        RankChangeHistory: Record "Rank Change History";
        LastNo: Integer;
        Remarks: Text[250];
        OldParent: Code[20];
        OldParentName: Text[50];
        OldParentRank: Decimal;
        Vendor2: Record "Region wise Vendor";
        NewParent: Code[20];
        NewParentName: Text[50];
        NewParentRank: Decimal;
        MMCode: Code[20];
        Name: Text[50];
        SelfRank: Decimal;
        UnitPost: Codeunit "Unit Post";
        VendTree: Record "Vendor Tree";
        Change: Boolean;
        Application: Record Application;
        ConOrder: Record "Confirmed Order";
        Vend: Record "Region wise Vendor";
        RegionCode1: Code[20];
        Text001: Label 'Associate Tree already exist on Date %1. Do you want to replace the Tree?';
        Text002: Label 'You have already done promotion or demotion on this Date.';
        CompanyInfo: Record "Company Information";
        NewAssociateBottom: Report "New Associate Bottom To Top_1";
        WebAppService: Codeunit "Web App Service";
        RegionwiseVendor: Record "Region wise Vendor";
        RankCodeMaster: Record "Rank Code";
        AssStatus: Text;

    procedure FindMMandParent(MMC: Code[20]; RegionCode: Code[10])
    begin
        Vendor2.GET(RegionCode, MMC);
        MMCode := MMC;
        RegionCode1 := RegionCode;
        Name := Vendor2.Name;
        SelfRank := Vendor2."Rank Code";
        OldParent := Vendor2."Parent Code";
        OldParentRank := Vendor2."Parent Rank";
        NewParent := OldParent;  //BBG1.7 30114
        NewParentRank := OldParentRank; //BBG1.7 30114
        IF Vendor2.GET(RegionCode, OldParent) THEN
            OldParentName := Vendor2.Name;
        NewParentName := OldParentName;  //BBG1.7 30114
    end;
}

