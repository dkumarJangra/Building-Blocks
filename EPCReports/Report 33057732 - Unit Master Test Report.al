report 97732 "Unit Master Test Report"
{
    // version ALLESSS

    DefaultLayout = RDLC;
    RDLCLayout = './EPCReports/Unit Master Test Report.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.";
            dataitem("Unit Master"; "Unit Master")
            {
                DataItemLink = "Project Code" = FIELD("No.");
                DataItemTableView = SORTING("No.");
                column(CompInfo_Name; CompanyInformation.Name)
                {
                }
                column(Project_Code; "Unit Master"."Project Code")
                {
                }
                column(Unit_No; "Unit Master"."No.")
                {
                }
                column(Description; "Unit Master".Description)
                {
                }
                column(Saleable_Area; "Unit Master"."Saleable Area")
                {
                }
                column(Ref_LLP_Name; "Unit Master"."Ref. LLP Name")
                {
                }
                column(Ref_LLP_ItemNo; "Unit Master"."Ref. LLP Item No.")
                {
                }
                column(ErrorText; ErrorText)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(ErrorText);
                    IF "Unit Master"."Ref. LLP Item No." <> '' THEN BEGIN
                        IF Job."Joint Venture" THEN BEGIN
                            ItemLedgerEntry.RESET;
                            ItemLedgerEntry.CHANGECOMPANY("Unit Master"."Ref. LLP Name");
                            ItemLedgerEntry.SETRANGE("Item No.", "Unit Master"."Ref. LLP Item No.");
                            ItemLedgerEntry.SETRANGE("Lot No.", "Unit Master"."No.");
                            ItemLedgerEntry.SETRANGE(Open, TRUE);
                            IF ItemLedgerEntry.FINDFIRST THEN BEGIN
                                IF "Unit Master"."Saleable Area" > ItemLedgerEntry."Remaining Quantity" THEN BEGIN
                                    ErrorText := 'Saleable Area: ' + FORMAT("Unit Master"."Saleable Area") + ' of Unit Code: ' + "Unit Master"."No." +
                                                 ' is exceeding limit than available quantity ' + FORMAT(ItemLedgerEntry."Remaining Quantity") +
                                                 ' in Ref. LLP Item: ' + "Unit Master"."Ref. LLP Item No.";
                                    ErrorTextCnt += 1;
                                END;
                            END;
                        END
                        ELSE BEGIN
                            RefLLPItemDetails.RESET;
                            RefLLPItemDetails.SETRANGE("Project Code", "Unit Master"."Project Code");
                            IF RefLLPItemDetails.FINDFIRST THEN BEGIN
                                IF RefLLPItemDetails."Ref. LLP Name" = "Unit Master"."Ref. LLP Name" THEN BEGIN
                                    IF RefLLPItemDetails."Ref. LLP Item No." <> "Unit Master"."Ref. LLP Item No." THEN BEGIN
                                        ErrorText := 'Ref. LLP Details Item No.: ' + "Unit Master"."Ref. LLP Item No." + ' does not exist for Project Code: ' + "Unit Master"."Project Code" + ', Ref. LLP Name: ' +
                                              "Unit Master"."Ref. LLP Name" + ' in Ref. LLP Details.';
                                        ErrorTextCnt += 1;
                                    END
                                END
                                ELSE BEGIN
                                    ErrorText := 'Ref. LLP Name ' + "Unit Master"."Ref. LLP Name" + ' does not exist for Project Code ' + "Unit Master"."Project Code";
                                    ErrorTextCnt += 1;
                                END;
                            END;
                        END;
                    END;

                    // IF ErrorText = '' THEN
                    //     CurrReport.SKIP;


                    //ALLE SSS 19/12/23---End
                end;
            }

            trigger OnPostDataItem()
            begin
                IF ErrorTextCnt = 0 THEN BEGIN
                    Job."Test Report Run" := TRUE;
                    Job.MODIFY;
                END;
            end;

            trigger OnPreDataItem()
            begin
                CLEAR(ErrorTextCnt);
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

    trigger OnPreReport()
    begin
        CompanyInformation.GET;
    end;

    var
        RefLLPItemDetails: Record "Ref. LLP Item Details";
        ErrorText: Text;
        CompanyInformation: Record "Company Information";
        ErrorTextCnt: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
}

