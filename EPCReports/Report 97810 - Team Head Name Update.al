report 97810 "Team Head Name Update"
{
    // version use in batch report

    // ALLECK 230513: Restricted Report to Run by only Userid 100237

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
            column(CompInfoName_; CompInfo.Name)
            {
            }
            column(Address_; CompInfo.Address + ' ' + CompInfo."Address 2" + ' ' + CompInfo.City + ' ' + CompInfo."Post Code")
            {
            }
            column(Code_AssociateCode_; 'Code : ' + AssociateCode)
            {
            }
            column(SlNo_; SlNo)
            {
            }
            column(ChainNo_; Chain."No.")
            {
            }
            column(VendName_; Vend.Name)
            {
            }
            column(ChainOldNo_; Chain."Old No.")
            {
            }
            column(Designation_; Designation)
            {
            }
            column(ChainParentCode_; Chain."Parent Code")
            {
            }
            column(VName_; VName)
            {
            }
            column(SrChainOldParentCode_; Chain."Old Parent Code")
            {
            }
            column(VendPANNo_; Vend."P.A.N. No.")
            {
            }
            column(SrVendName_; Vend.Name)
            {
            }
            column(VendMobNo_; "VendMobNo.")
            {
            }
            column(VendStatus_; VendStatus)
            {
            }

            trigger OnAfterGetRecord()
            var
                v_Vendor: Record Vendor;
                v_Vendor_1: Record Vendor;
                v_Vendor2: Record Vendor;
                v_Vendor3: Record Vendor;
            begin

                IF Number = 1 THEN
                    Chain.FIND('-')
                ELSE
                    Chain.NEXT;
                CLEAR(Vend);
                Designation := '';

                IF Vend.GET(Chain."No.") THEN BEGIN
                END ELSE
                    CurrReport.SKIP;

                IF Vend3.GET(Chain."Parent Code") THEN;
                //VName :=Vend3.Name;
                /*
                TopHeadDetailsA1.RESET;
                TopHeadDetailsA1.SETRANGE("Associate Code",AssociateCode);
                TopHeadDetailsA1.SETRANGE("Rank Code",RankCode);
                IF NOT TopHeadDetailsA1.FINDFIRST THEN BEGIN
                  IF Chain."Parent Code" = 'IBA9999999' THEN BEGIN
                    TopHeadDetailsA1.INIT;
                    TopHeadDetailsA1."Associate Code" := AssociateCode;
                    TopHeadDetailsA1."Rank Code" := RankCode;
                    TopHeadDetailsA1."Team Head" := Chain."No.";
                    TopHeadDetailsA1.INSERT;
                  END;
                END;
                */
                IF Chain."Parent Code" = 'IBA9999999' THEN BEGIN
                    v_Vendor2.RESET;
                    v_Vendor3.RESET;
                    IF v_Vendor2.GET(AssociateCode) THEN BEGIN
                        IF v_Vendor3.GET(Chain."No.") THEN BEGIN
                            IF v_Vendor2."BBG Team Code" = '' THEN
                                v_Vendor2."BBG Team Code" := v_Vendor3."BBG Team Code";
                            IF v_Vendor2."BBG Leader Code" = '' THEN
                                v_Vendor2."BBG Leader Code" := 'EMERGING LEADER';
                            v_Vendor2.MODIFY;
                        END;
                    END;
                END;

                //IF Chain."Parent Code" = 'IBA9999999' THEN BEGIN  210922
                TempVendor.INIT;
                TempVendor."No." := Chain."No.";
                TempVendor.INSERT;
                //v_Vendor.GET(AssociateCode);   210922
                //v_Vendor_1.GET(Chain."No.");   210922
                //v_Vendor."Team Code" := v_Vendor_1."Team Code";  210922
                //v_Vendor.MODIFY;  210922
                //END;

            end;

            trigger OnPostDataItem()
            var
                Team_Vendor: Record Vendor;
                v_Vendor4: Record Vendor;
            begin
                COMMIT;
                AssociateLevelList.RESET;
                IF AssociateLevelList.FINDSET THEN
                    REPEAT
                        FirstLevel := FALSE;
                        SecondLevel := FALSE;
                        ThirdLevel := FALSE;
                        FirstHead := '';
                        SecondHead := '';
                        ThirdHead := '';
                        IF TempVendor.FINDSET THEN
                            REPEAT
                                IF AssociateLevelList."Associate Id" = TempVendor."No." THEN BEGIN
                                    FirstLevel := TRUE;
                                    FirstHead := AssociateLevelList."Associate Id";
                                END;
                                IF AssociateLevelList."Second Level Associate ID" = TempVendor."No." THEN BEGIN
                                    SecondLevel := TRUE;
                                    SecondHead := AssociateLevelList."Second Level Associate ID";
                                END;
                                IF AssociateLevelList."Third Level Associate ID" = TempVendor."No." THEN BEGIN
                                    ThirdLevel := TRUE;
                                    ThirdHead := AssociateLevelList."Third Level Associate ID";
                                END;
                            UNTIL TempVendor.NEXT = 0;

                        Team_Vendor.RESET;
                        IF Team_Vendor.GET(AssociateCode) THEN BEGIN
                            IF FirstLevel AND SecondLevel AND ThirdLevel THEN BEGIN
                                v_Vendor4.RESET;
                                IF v_Vendor4.GET(ThirdHead) THEN
                                    Team_Vendor."BBG Team Code" := v_Vendor4."BBG Team Code";
                            END ELSE IF FirstLevel AND SecondLevel THEN BEGIN
                                v_Vendor4.RESET;
                                IF v_Vendor4.GET(SecondHead) THEN
                                    Team_Vendor."BBG Team Code" := v_Vendor4."BBG Team Code";
                            END ELSE IF FirstLevel THEN BEGIN
                                v_Vendor4.RESET;
                                IF v_Vendor4.GET(FirstHead) THEN
                                    Team_Vendor."BBG Team Code" := v_Vendor4."BBG Team Code";
                            END;
                            Team_Vendor.MODIFY;
                        END;
                    /*
                    TopHeadDetailsA2.RESET;
                     TopHeadDetailsA2.SETRANGE("Associate Code",AssociateCode);
                     TopHeadDetailsA2.SETRANGE("Rank Code",RankCode);
                     IF TopHeadDetailsA2.FINDFIRST THEN
                       BEGIN
                         IF FirstLevel AND SecondLevel AND ThirdLevel THEN BEGIN
                           TopHeadDetailsA2."Team Head" := ThirdHead;
                         END ELSE IF FirstLevel  AND SecondLevel THEN BEGIN
                           TopHeadDetailsA2."Team Head" := SecondHead;
                         END ELSE IF FirstLevel THEN
                          TopHeadDetailsA2."Team Head" := FirstHead;
                         TopHeadDetailsA2.MODIFY;
                       END;
                       */

                    UNTIL AssociateLevelList.NEXT = 0;

            end;

            trigger OnPreDataItem()
            begin
                //AssociateCode := 'IBA0356259';
                //RankCode := 'R0001';
                WEDate := TODAY;
                CLEAR(TempVendor);
                IF RankCode = '' THEN
                    ERROR('Please fill the Rank Code');
                ChainMgt.NewInitChain;
                ChainMgt.NewChainFromToUp(AssociateCode, WEDate, FALSE, RankCode);
                ChainMgt.NewUpdateChainRank(WEDate, RankCode);
                ChainMgt.NewReturnChain(Chain);
                Chain.SETCURRENTKEY("Rank Code");
                Chain.ASCENDING(FALSE);
                SETRANGE(Number, 1, Chain.COUNT);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Rank Code"; RankCode)
                {
                    TableRelation = "Rank Code Master";
                    ApplicationArea = All;
                }
                field("Associate Code"; AssociateCode)
                {
                    TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)"));
                    ApplicationArea = All;
                }
                field(Name; GetDesc.GetVendorName(AssociateCode))
                {
                    ApplicationArea = All;
                }
                field(Date; WEDate)
                {
                    ApplicationArea = All;
                }
                field("Export to Excel"; ExportToExcel)
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


        //CompInfo.GET;
        //CompInfo.CALCFIELDS(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        Filters: Text[50];
        AssociateCode: Code[20];
        ChainMgt: Codeunit "Unit Post";
        Chain: Record "Region wise Vendor" temporary;
        LastRank: Integer;
        Vend: Record Vendor;
        GetDesc: Codeunit GetDescription;
        SlNo: Integer;
        Rank: Record Rank;
        Designation: Text[50];
        Vend2: Record Vendor;
        VendStatus: Option " ",Provisional,Active,Inactive;
        ExportToExcel: Boolean;
        RowNo: Integer;
        Vend3: Record Vendor;
        VName: Text[50];
        WEDate: Date;
        "VendMobNo.": Text[50];
        Memberof: Record "Access Control";
        RankCode: Code[10];
        Text000: Label 'Invalid Parameters.';
        // XlApp: Automation;
        // XlWrkBk: Automation;
        // XlWrkSht: Automation;
        // XlWrkshts: Automation;
        // XlRange: Automation;
        j: Integer;
        k: Integer;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        UserSetup: Record "User Setup";
        ReportFilters: Text;
        EntryNo: Integer;
        ReportDetailsUpdate: Codeunit "Report Details Update";
        //TopHeadDetailsA1: Record 60690;
        TempVendor: Record Vendor temporary;
        AssociateLevelList: Record "Associate Level List";
        FirstLevel: Boolean;
        SecondLevel: Boolean;
        ThirdLevel: Boolean;
        FirstHead: Code[20];
        SecondHead: Code[20];
        ThirdHead: Code[20];
    //TopHeadDetailsA2: Record 60690;

    procedure ReportValues(MMCode_1: Code[20]; RankCode_1: Code[10])
    begin

        AssociateCode := MMCode_1;
        RankCode := RankCode_1;
    end;
}

