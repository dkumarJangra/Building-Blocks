page 50078 "Regin and Rank wise vendor"
{
    Editable = false;
    PageType = List;
    SourceTable = "Region wise Vendor";
    SourceTableView = WHERE("No." = FILTER('IBA*|CP*'));  //251124 added CP
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Region Code"; Rec."Region Code")
                {
                }
                field("Team Head"; Rec."Team Head")
                {
                }
                field("Region Description"; Rec."Region Description")
                {
                }
                field("Associate DOJ"; Rec."Associate DOJ")
                {
                }
                field("Parent Code"; Rec."Parent Code")
                {
                }
                field("Parent Associate DOJ"; Rec."Parent Associate DOJ")
                {
                }
                field("Rank Code"; Rec."Rank Code")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Parent Rank"; Rec."Parent Rank")
                {
                }
                field("Associate Level"; Rec."Associate Level")
                {
                }
                field("Old No."; Rec."Old No.")
                {
                }
                field("Print Team Head"; Rec."Print Team Head")
                {
                }
                field("Old Parent Code"; Rec."Old Parent Code")
                {
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        RegionwiseVendor.RESET;
                        RegionwiseVendor.SETRANGE(RegionwiseVendor."Region Code", Rec."Region Code");
                        RegionwiseVendor.SETRANGE("No.", Rec."No.");
                        PAGE.RUN(PAGE::"Region and Rank wise Associate", RegionwiseVendor);
                    end;
                }
            }
        }
        area(processing)
        {
            action("Update Team Head")
            {
                Caption = 'Update Team Head';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to update Team Head?') THEN BEGIN
                        VendRegion_1.RESET;
                        VendRegion_1.SETFILTER("Region Code", '<>%1', '');
                        VendRegion_1.SETFILTER("No.", '<>%1', '');
                        VendRegion_1.SETFILTER("Parent Code", '<>%1', '');
                        IF VendRegion_1.FINDSET THEN
                            REPEAT
                                TeamHead := '';
                                BuildHierarchy(VendRegion_1."No.", VendRegion_1."Region Code");
                                VendRegion_1."Team Head" := TeamHead;
                                VendRegion_1.MODIFY;
                            UNTIL VendRegion_1.NEXT = 0;
                        MESSAGE('%1', 'Process done');
                    END;
                end;
            }
        }
    }

    var
        RegionwiseVendor: Record "Region wise Vendor";
        VendRegion: Record "Region wise Vendor";
        TeamHead: Code[20];
        VendRegion_1: Record "Region wise Vendor";


    procedure BuildHierarchy(MMCode: Code[20]; RankCode: Code[20])
    begin
        VendRegion.RESET;
        VendRegion.SETCURRENTKEY("Region Code", "No.");
        VendRegion.SETRANGE("Region Code", RankCode);
        VendRegion.SETRANGE("No.", MMCode);
        VendRegion.SETFILTER("Parent Code", '<>%1', '');
        IF VendRegion.FINDSET THEN
            REPEAT
                IF VendRegion."Parent Code" <> 'IBA9999999' THEN BEGIN
                    MMCode := VendRegion."Parent Code";
                    BuildHierarchy(MMCode, RankCode);
                    TeamHead := VendRegion."No.";
                END ELSE BEGIN
                    TeamHead := VendRegion."Parent Code";
                END;
            UNTIL VendRegion.NEXT = 0;
    end;
}

