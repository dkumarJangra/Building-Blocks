page 50068 "Unit Approval Form"
{
    PageType = List;
    SourceTable = "Unit Master";
    SourceTableView = WHERE(Archived = FILTER('No'));
    UsageCategory = Lists;
    ApplicationArea = All;
    PromotedActionCategories = 'New,Approve,Report,Navigate,Release,Posting,Prepare,Invoice,Request Approval';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Company Name"; Rec."Company Name")
                {
                    Editable = "Company NameEditable";
                    Visible = false;
                }
                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Payment Plan"; Rec."Payment Plan")
                {
                    Editable = "Payment PlanEditable";
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                    Editable = "Saleable AreaEditable";
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                    Editable = "Min. Allotment AmountEditable";
                }
                field("Total Value"; Rec."Total Value")
                {
                    Editable = "Total ValueEditable";
                }
                field("No. of Plots"; Rec."No. of Plots")
                {
                    Editable = "No. of PlotsEditable";
                }
                field("No. of Plots for Incentive Cal"; Rec."No. of Plots for Incentive Cal")
                {
                    Editable = NoofPlotsforIncentiveCalEditab;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field(Approve; Rec.Approve)
                {
                }
                field("Comment for Unit Block"; Rec."Comment for Unit Block")
                {
                    Caption = 'Remarks';
                }
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
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Project Unit Card";
                    RunPageLink = "No." = FIELD("No.");
                    RunPageView = WHERE("No." = FILTER(<> ''));
                    ShortCutKey = 'Shift+Ctrl+L';
                }
                action("Select All")
                {
                    Caption = 'Select All';
                    Image = SelectField;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Usersetup.RESET;
                        Usersetup.SETRANGE("User ID", USERID);
                        Usersetup.SETRANGE("Unit Approval", TRUE);
                        IF NOT Usersetup.FINDFIRST THEN
                            ERROR('Please contact to Admin');

                        UMaster.RESET;
                        UMaster.SETRANGE("Project Code", Rec."Project Code");
                        UMaster.SETRANGE(Approve, FALSE);
                        IF UMaster.FINDSET THEN
                            REPEAT
                                UMaster.Approve := TRUE;
                                UMaster.MODIFY;
                                CreateUnitLifeCycle(UMaster);
                            UNTIL UMaster.NEXT = 0;

                    end;
                }
                action("Un Select All")
                {
                    Caption = 'Un Select All';
                    Image = "1099Form";
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Usersetup.RESET;
                        Usersetup.SETRANGE("User ID", USERID);
                        Usersetup.SETRANGE("Unit Approval", TRUE);
                        IF NOT Usersetup.FINDFIRST THEN
                            ERROR('Please contact to Admin');

                        UMaster.RESET;
                        UMaster.SETRANGE("Project Code", Rec."Project Code");
                        UMaster.SETRANGE(Approve, TRUE);
                        IF UMaster.FINDSET THEN
                            REPEAT
                                UMaster.Approve := FALSE;
                                UMaster.MODIFY;
                                CreateUnitLifeCycle1(UMaster);
                            UNTIL UMaster.NEXT = 0;
                    end;
                }
                action(Release)
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        RecUMaster: Record "Unit Master";
                    begin
                        Usersetup.RESET;
                        Usersetup.SETRANGE("User ID", USERID);
                        Usersetup.SETRANGE("Unit Approval", TRUE);
                        IF NOT Usersetup.FINDFIRST THEN
                            ERROR('Please contact to Admin');


                        UMaster.RESET;
                        UMaster.SETRANGE(Approve, TRUE);
                        UMaster.SETRANGE(Archived, UMaster.Archived::No);
                        IF UMaster.FINDSET THEN
                            REPEAT
                                UMaster.Archived := UMaster.Archived::Yes;
                                UMaster.MODIFY;
                            UNTIL UMaster.NEXT = 0;
                        /*
                        RecUMaster.RESET;
                        RecUMaster.SETRANGE(Archived,RecUMaster.Archived::No);
                        IF RecUMaster.FINDSET THEN
                          REPEAT
                            RecUMaster.Status := RecUMaster.Status::Blocked;
                            RecUMaster.Archived := RecUMaster.Archived::Yes;
                            RecUMaster.MODIFY;
                          UNTIL RecUMaster.NEXT =0;
                         */

                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        "Base Unit of MeasureEditable" := TRUE;
        NoofPlotsforIncentiveCalEditab := TRUE;
        "No. of PlotsEditable" := TRUE;
        "Total ValueEditable" := TRUE;
        "Min. Allotment AmountEditable" := TRUE;
        "Saleable AreaEditable" := TRUE;
        "Payment PlanEditable" := TRUE;
        DescriptionEditable := TRUE;
        "No.Editable" := TRUE;
        "Project CodeEditable" := TRUE;
        "Company NameEditable" := TRUE;
    end;

    trigger OnOpenPage()
    begin
        "Company NameEditable" := FALSE;
        "Project CodeEditable" := FALSE;
        "No.Editable" := FALSE;
        DescriptionEditable := FALSE;
        "Payment PlanEditable" := FALSE;
        "Saleable AreaEditable" := FALSE;
        "Min. Allotment AmountEditable" := FALSE;
        "Total ValueEditable" := FALSE;
        "No. of PlotsEditable" := FALSE;
        NoofPlotsforIncentiveCalEditab := FALSE;
        "Base Unit of MeasureEditable" := FALSE;
    end;

    var
        UMaster: Record "Unit Master";
        Usersetup: Record "User Setup";

        "Company NameEditable": Boolean;

        "Project CodeEditable": Boolean;

        "No.Editable": Boolean;

        DescriptionEditable: Boolean;

        "Payment PlanEditable": Boolean;

        "Saleable AreaEditable": Boolean;

        "Min. Allotment AmountEditable": Boolean;

        "Total ValueEditable": Boolean;

        "No. of PlotsEditable": Boolean;

        NoofPlotsforIncentiveCalEditab: Boolean;

        "Base Unit of MeasureEditable": Boolean;
        UnitLifeCycle: Record "Unit Life Cycle";

    local procedure CreateUnitLifeCycle(UMaster_1: Record "Unit Master")
    var
        UnitLifeCycle: Record "Unit Life Cycle";
        OldUnitLifeCycle: Record "Unit Life Cycle";
        LineNo: Integer;
        ExistUnitLifeCycle: Record "Unit Life Cycle";
        UnitMaster_1: Record "Unit Master";
        NewconfirmedOrders: Record "New Confirmed Order";
    begin
        LineNo := 0;
        OldUnitLifeCycle.RESET;
        OldUnitLifeCycle.SETRANGE("Unit Code", UMaster_1."No.");
        IF OldUnitLifeCycle.FINDLAST THEN
            LineNo := OldUnitLifeCycle."Line No.";


        UnitLifeCycle.INIT;
        UnitLifeCycle.TRANSFERFIELDS(OldUnitLifeCycle);
        UnitLifeCycle."Unit Code" := UMaster_1."No.";
        UnitLifeCycle."Line No." := LineNo + 1;
        IF UnitMaster_1.GET(UMaster_1."No.") THEN
            UnitLifeCycle."Unit Cost" := UnitMaster_1."Total Value";
        UnitLifeCycle."Unit Approved Date" := TODAY;
        UnitLifeCycle."Unit Approved" := TRUE;
        UnitLifeCycle."Type of Transaction" := UnitLifeCycle."Type of Transaction"::"Unit Approved";
        UnitLifeCycle.INSERT;
    end;

    local procedure CreateUnitLifeCycle1(UMaster_1: Record "Unit Master")
    var
        UnitLifeCycle: Record "Unit Life Cycle";
        OldUnitLifeCycle: Record "Unit Life Cycle";
        LineNo: Integer;
        ExistUnitLifeCycle: Record "Unit Life Cycle";
        UnitMaster_1: Record "Unit Master";
        NewconfirmedOrders: Record "New Confirmed Order";
    begin
        LineNo := 0;
        OldUnitLifeCycle.RESET;
        OldUnitLifeCycle.SETRANGE("Unit Code", UMaster_1."No.");
        IF OldUnitLifeCycle.FINDLAST THEN
            LineNo := OldUnitLifeCycle."Line No.";


        UnitLifeCycle.INIT;
        UnitLifeCycle.TRANSFERFIELDS(OldUnitLifeCycle);
        UnitLifeCycle."Unit Code" := UMaster_1."No.";
        UnitLifeCycle."Line No." := LineNo + 1;
        IF UnitMaster_1.GET(UMaster_1."No.") THEN
            UnitLifeCycle."Unit Cost" := UnitMaster_1."Total Value";
        UnitLifeCycle."Unit Un-Approved Date" := TODAY;
        UnitLifeCycle."Unit Approved" := FALSE;
        UnitLifeCycle."Type of Transaction" := UnitLifeCycle."Type of Transaction"::"Unit Un-approve";
        UnitLifeCycle.INSERT;
    end;
}

