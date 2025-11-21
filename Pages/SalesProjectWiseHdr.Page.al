page 50003 "Sales Project Wise Hdr"
{
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Sales Project Wise Setup Hdr";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Project Code"; Rec."Project Code")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
            part(""; "Sales Project wise Setup Line")
            {
                SubPageLink = "Project Code" = FIELD("Project Code");
                SubPageView = SORTING("Project Code", "Line No.");
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
                action("Re-Open")
                {
                    Caption = 'Re-Open';

                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Open;
                        Rec.MODIFY;
                    end;
                }
                action(Release)
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;

                    trigger OnAction()
                    begin


                        SalesProjectWiseSetupLine_1.RESET;
                        SalesProjectWiseSetupLine_1.SETRANGE("Project Code", Rec."Project Code");
                        SalesProjectWiseSetupLine_1.SETRANGE(Status, Rec.Status::Open);
                        IF SalesProjectWiseSetupLine_1.FINDSET THEN BEGIN
                            REPEAT
                                SalesProjectWiseSetupLine_1.TESTFIELD("Sales %");
                                SalesProjectWiseSetupLine.RESET;
                                SalesProjectWiseSetupLine.SETRANGE("Project Code", Rec."Project Code");
                                SalesProjectWiseSetupLine.SETRANGE(Status, Rec.Status::Release);
                                SalesProjectWiseSetupLine.SETRANGE("Effective From Date", SalesProjectWiseSetupLine_1."Effective From Date");
                                SalesProjectWiseSetupLine.SETRANGE("Effective To Date", SalesProjectWiseSetupLine_1."Effective To Date");
                                IF SalesProjectWiseSetupLine.FINDSET THEN BEGIN
                                    REPEAT
                                        SalesProjectWiseSetupLine.Status := SalesProjectWiseSetupLine.Status::Closed;
                                        IF (SalesProjectWiseSetupLine."Effective To Date" = 0D) AND (SalesProjectWiseSetupLine_1."Effective To Date" <> 0D)
                                        THEN
                                            SalesProjectWiseSetupLine."Effective To Date" := SalesProjectWiseSetupLine_1."Effective From Date" - 1;

                                        SalesProjectWiseSetupLine.MODIFY;
                                    UNTIL SalesProjectWiseSetupLine.NEXT = 0;
                                END ELSE BEGIN
                                    SPWSLine.RESET;
                                    SPWSLine.SETRANGE("Project Code", Rec."Project Code");
                                    SPWSLine.SETRANGE(Status, Rec.Status::Release);
                                    IF SPWSLine.FINDSET THEN
                                        REPEAT
                                            IF (SPWSLine."Effective To Date" >= SalesProjectWiseSetupLine_1."Effective From Date") THEN
                                                ERROR('Effective From Date should be greater than -' + FORMAT(SPWSLine."Effective To Date"));
                                            SPWSLine."Effective To Date" := SalesProjectWiseSetupLine_1."Effective From Date" - 1;
                                            SPWSLine.MODIFY;
                                        UNTIL SPWSLine.NEXT = 0;
                                END;
                                SalesProjectWiseSetupLine_1.TESTFIELD("Effective From Date");
                                //    SalesProjectWiseSetupLine_1.TESTFIELD("Effective To Date");
                                SalesProjectWiseSetupLine_1.Status := SalesProjectWiseSetupLine_1.Status::Released;
                                SalesProjectWiseSetupLine_1.MODIFY;
                            UNTIL SalesProjectWiseSetupLine_1.NEXT = 0;

                        END;
                        Rec.Status := Rec.Status::Release;
                        Rec.MODIFY;
                    end;
                }
            }
        }
    }

    var
        SalesProjectWiseSetupLine: Record "Sales Project Wise Setup Line";
        SalesProjectWiseSetupLine_1: Record "Sales Project Wise Setup Line";
        Conforder_1: Record "Confirmed Order";
        SalesProjectWiseSetupLine_2: Record "Sales Project Wise Setup Line";
        SPWSLine: Record "Sales Project Wise Setup Line";
}

