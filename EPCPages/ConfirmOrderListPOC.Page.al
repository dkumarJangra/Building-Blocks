page 50083 "Confirm Order List (POC)"
{
    Caption = 'Confirm Order List (POC)';
    CardPageID = "New Unit Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "New Confirmed Order";
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
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("User Id"; Rec."User Id")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Loan File"; Rec."Loan File")  //251124 Added
                {

                }
                field("60 feet road"; Rec."60 feet road")
                {
                }
                field("100 feet road"; Rec."100 feet road")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Direct Incentive Amount"; Rec."Direct Incentive Amount")
                {
                }
                field("Customer Mobile No."; Rec."Customer Mobile No.")
                {
                    Visible = false;
                }
                field("Last Receipt Date"; Rec."Last Receipt Date")
                {
                }
                field("Sales Invoice booked"; Rec."Sales Invoice booked")
                {
                }
                field("Gold Coin Issued"; Rec."Gold Coin Issued")
                {
                }
                field("Total Comm & Direct Assc. Amt."; Rec."Total Comm & Direct Assc. Amt.")
                {
                }
                field("Registration No."; Rec."Registration No.")
                {
                }
                field("Registration Date"; Rec."Registration Date")
                {
                }
                field("Restrict Issue for Gold/Silver"; Rec."Restrict Issue for Gold/Silver")
                {
                }
                field("Restriction Remark"; Rec."Restriction Remark")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                }
                field("Unit Plan Name"; Rec."Unit Plan Name")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Unit")
            {
                Caption = '&Unit';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Confirmed Order";
                    RunPageLink = "No." = FIELD("No.");
                    RunPageView = SORTING("No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Update Team Head ID")
                {
                    Caption = 'Update Team Head ID';

                    trigger OnAction()
                    begin
                        NewConforder.RESET;
                        IF NewConforder.FINDSET THEN
                            REPEAT
                                AssHierarcyWithApp.RESET;
                                AssHierarcyWithApp.SETRANGE("Application Code", NewConforder."No.");
                                AssHierarcyWithApp.SETFILTER("Rank Code", '<>%1', 13.0);
                                AssHierarcyWithApp.SETRANGE(Status, AssHierarcyWithApp.Status::Active);
                                IF AssHierarcyWithApp.FINDLAST THEN BEGIN
                                    NewConforder."Filters on Team Head" := AssHierarcyWithApp."Associate Code";
                                    NewConforder.MODIFY;
                                END;
                            UNTIL NewConforder.NEXT = 0;
                        MESSAGE('%1', 'Done');
                    end;
                }
                action("Update Direct Incentive Amount")
                {
                    Caption = 'Update Direct Incentive Amount';
                    Visible = false;

                    trigger OnAction()
                    begin
                        NewConforder.RESET;
                        NewConforder.SETFILTER(Status, '%1|%2', NewConforder.Status::Open, NewConforder.Status::Registered);
                        IF NewConforder.FINDSET THEN
                            REPEAT
                                ConfirmedOrder.RESET;
                                ConfirmedOrder.CHANGECOMPANY(NewConforder."Company Name");
                                IF ConfirmedOrder.GET(NewConforder."No.") THEN BEGIN
                                    ConfirmedOrder.CALCFIELDS("Direct Incentive Amount");
                                    NewConforder."Direct Incentive Amount" := ConfirmedOrder."Direct Incentive Amount";
                                    NewConforder.MODIFY;
                                END;
                            UNTIL NewConforder.NEXT = 0;

                        MESSAGE('Process Done');
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AssHierarcyWithApp.RESET;
        AssHierarcyWithApp.SETRANGE("Application Code", Rec."No.");
        AssHierarcyWithApp.SETFILTER("Rank Code", '<>%1', 13.0);
        AssHierarcyWithApp.SETRANGE(Status, AssHierarcyWithApp.Status::Active);
        IF AssHierarcyWithApp.FINDLAST THEN BEGIN
            Rec."Team Head Id" := AssHierarcyWithApp."Associate Code";
        END;
    end;

    var
        GetDescription: Codeunit GetDescription;
        AssHierarcyWithApp: Record "Associate Hierarcy with App.";
        NewConforder: Record "New Confirmed Order";
        ConfirmedOrder: Record "Confirmed Order";
        Company: Record Company;
}

