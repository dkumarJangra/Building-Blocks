page 50076 "Region and Rank wise Associate"
{
    // 130720 update code

    Editable = true;
    PageType = Card;
    SourceTable = "Region wise Vendor";
    ApplicationArea = All;
    UsageCategory = Documents;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Invoice,Function';
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Region Code"; Rec."Region Code")
                {
                    Caption = 'Hierarchy Code';
                }
                field("Region Description"; Rec."Region Description")
                {
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                    Visible = true;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field("Rank Code"; Rec."Rank Code")
                {
                    Editable = true;
                }
                field("Rank Description"; Rec."Rank Description")
                {
                    Visible = false;
                }
                field("Parent Code"; Rec."Parent Code")
                {
                }
                field("Parent Rank"; Rec."Parent Rank")
                {
                }
                field("Parent Description"; Rec."Parent Description")
                {
                    Visible = false;
                }
                field("Vendor Check Status"; Rec."Vendor Check Status")
                {
                    Editable = false;
                }
                field("Associate DOJ"; Rec."Associate DOJ")
                {
                }
                field("Parent Associate DOJ"; Rec."Parent Associate DOJ")
                {
                }
                field("Print Team Head"; Rec."Print Team Head")
                {
                    Editable = false;
                }
                field("Team Code"; Rec."Team Code")
                {
                }
                field("Leader Code"; Rec."Leader Code")
                {
                }
                field("Sub Team Code"; Rec."Sub Team Code")
                {
                }
                field("CP Team Code"; Rec."CP Team Code")
                {
                }
                field("CP Leader Code"; Rec."CP Leader Code")
                {
                }
            }
            part(Subform; "Regin and Rank wise Subform")
            {
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unction")
            {
                Caption = 'F&unction';
                action("&Open")
                {
                    Caption = '&Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'Return';

                    trigger OnAction()
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Associate Re-Open", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');

                        Rec."Vendor Check Status" := Rec."Vendor Check Status"::Open;
                        Rec.MODIFY;

                        MESSAGE('Open the document');
                    end;
                }
                action("&Release")
                {
                    Caption = '&Release';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        RecVendor_1: Record Vendor;
                        OtherEventMgnt: Codeunit 70005;
                        TeamCode: Code[50];
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Associate Rank Change", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');

                        //130720
                        Rec.TESTFIELD("Region Code");
                        Rec.TESTFIELD("No.");
                        Rec.TESTFIELD("Rank Code");
                        If Rec."Rank Code" <> 13.00 THEN BEGIN
                            Rec.TESTFIELD("Parent Code");
                            Rec.TESTFIELD("Parent Rank");
                        END;
                        //130720
                        Comp.RESET;
                        IF Comp.FINDSET THEN BEGIN
                            REPEAT
                                IF OldVend.GET(Rec."No.") THEN;
                                Vend.INIT;
                                Vend := OldVend;
                                Vend.CHANGECOMPANY(Comp.Name);
                                Vend.SETRANGE("No.", Rec."No.");
                                IF NOT Vend.FINDFIRST THEN
                                    Vend.INSERT;
                            UNTIL Comp.NEXT = 0;
                        END;

                        IF NOT Rec."Introducer Update on Vendor" THEN BEGIN
                            RecVendor_1.RESET;
                            RecVendor_1.SETRANGE("No.", Rec."No.");
                            RecVendor_1.SETRANGE("BBG Introducer", '');
                            IF RecVendor_1.FINDFIRST THEN BEGIN
                                RecVendor_1."BBG Introducer" := Rec."Parent Code";
                                RecVendor_1.MODIFY;
                            END;
                        END;

                        Rec."Vendor Check Status" := Rec."Vendor Check Status"::Release;
                        Rec."Introducer Update on Vendor" := TRUE;

                        TeamCode := OtherEventMgnt.ReturnTeamCode(Rec."Parent Code", Rec."Region Code", Rec."No.", true);  //05122025 Code added
                        IF TeamCode <> '' then
                            Rec."Team Code" := TeamCode;
                        Rec.MODIFY;


                        MESSAGE('Release the document');
                    end;
                }
                action("Copy Vendor on All Region")
                {
                    Caption = 'Copy Vendor on All Region';
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to create this associate ' + Rec."No." + ' ' + 'in all Region') THEN BEGIN
                            RankCodeMaster.RESET;
                            RankCodeMaster.SETFILTER(RankCodeMaster.Code, '<>%1', Rec."Region Code");
                            IF RankCodeMaster.FINDSET THEN
                                REPEAT
                                    RegionwiseVendor.INIT;
                                    RegionwiseVendor := Rec;
                                    RegionwiseVendor."Region Code" := RankCodeMaster.Code;
                                    RegionwiseVendor.INSERT;
                                UNTIL RankCodeMaster.NEXT = 0;
                            MESSAGE('Associate Created');
                        END ELSE
                            MESSAGE('Associate not created');
                    end;
                }
                action("Change Rank")
                {
                    Caption = 'Change Rank';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Associate Re-Open", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');

                        UserSetup.GET(USERID);
                        IF NOT UserSetup."MM Chain Management" THEN
                            ERROR(Text004);

                        IF CONFIRM(Text005, FALSE, Rec."No.") THEN BEGIN
                            CLEAR(ChangeRank);
                            CurrPage.SETSELECTIONFILTER(Rec);
                            ChangeRank.SETTABLEVIEW(Rec);
                            ChangeRank.FindMMandParent(Rec."No.", Rec."Region Code");
                            ChangeRank.RUNMODAL;
                        END;
                    end;
                }
                action("Change Chain (Parent)")
                {
                    Caption = 'Change Chain (Parent)';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Associate Rank Change", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');

                        IF CONFIRM(Text014, FALSE, Rec."No.") THEN BEGIN
                            CLEAR(ChangeChain);
                            CurrPage.SETSELECTIONFILTER(Rec);
                            ChangeChain.SETTABLEVIEW(Rec);
                            ChangeChain.FindMMandParent(Rec."No.", Rec."Region Code");
                            ChangeChain.RUNMODAL;
                        END;
                    end;
                }
                action("Rank History")
                {
                    Caption = 'Rank History';
                    Image = "1099Form";
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Rank History";
                    RunPageLink = MMCode = FIELD("No."),
                                  "Rank Code" = FIELD("Region Code");
                }
            }
        }
    }

    trigger OnOpenPage()
    begin

        CLEAR(MemberOf);

        // MemberOf.RESET;
        // MemberOf.SETRANGE("User Name", USERID);
        // MemberOf.SETRANGE("Role ID", 'A_IBACREATION');
        // IF MemberOf.FINDFIRST THEN
        //     CurrPage.EDITABLE(True)
        // ELSE
        //     CurrPage.EDITABLE(false);  //Code commented
    end;



    var
        UserSetup: Record "User Setup";
        Text004: Label 'Invalid Permission.';
        Text005: Label 'Do you want to change the rank for the Marketing Member No. %1?';
        ChangeRank: Report "New Change Rank";
        ChangeChain: Report "New Change Chain";
        Text014: Label 'Do you want to change the Parent for the Marketing Member No. %1?';
        RegionwiseVendor: Record "Region wise Vendor";
        RankCodeMaster: Record "Rank Code Master";
        Comp: Record Company;
        Vend: Record Vendor;
        OldVend: Record Vendor;
        MemberOf: Record "Access Control";
}

