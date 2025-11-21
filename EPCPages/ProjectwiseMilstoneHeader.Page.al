page 50059 "Project wise Milstone Header"
{
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Project Milestone Header";
    SourceTableView = WHERE("Document No." = FILTER(<> 0));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Effective From Date"; Rec."Effective From Date")
                {
                }
                field("Effective To Date"; Rec."Effective To Date")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Creator Name"; Rec."Creator Name")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
            part("Project wise Milestone Lines"; "Project wise Milestone Lines")
            {
                SubPageLink = "Document No." = FIELD("Document No.");
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
                action("Copy Charge Type")
                {
                    Caption = 'Copy Charge Type';
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ToDoctMaster: Record "Project Milestone Line";
                        FromDocMaster: Record "Document Master";
                        ToDoctMaster1: Record "Project Milestone Line";
                        LineNo: Integer;
                    begin
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User ID",USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID",'MilestoneSetup');
                        IF NOT MemberOf.FINDFIRST THEN
                          ERROR('Please contact to Admin');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

                        ProjectMilestoneLine.RESET;
                        ProjectMilestoneLine.SETRANGE(ProjectMilestoneLine."Document No.", Rec."Document No.");
                        IF ProjectMilestoneLine.FINDFIRST THEN
                            ERROR('You have already define the setup. If you want to change first delete it');


                        FromDocMaster.RESET;
                        FromDocMaster.SETRANGE("Project Code", Rec."Project Code");
                        FromDocMaster.SETRANGE(FromDocMaster."Document Type", FromDocMaster."Document Type"::Charge);
                        FromDocMaster.SETRANGE("Unit Code", '');
                        IF FromDocMaster.FINDSET THEN BEGIN
                            REPEAT
                                ToDoctMaster1.RESET;
                                ToDoctMaster1.SETRANGE("Project Code", Rec."Project Code");
                                IF ToDoctMaster1.FINDLAST THEN
                                    LineNo := ToDoctMaster1."Line No."
                                ELSE
                                    LineNo := 0;
                                ToDoctMaster.INIT;
                                ToDoctMaster."Document No." := Rec."Document No.";
                                ToDoctMaster."Line No." := LineNo + 10000;
                                ToDoctMaster."Document Type" := FromDocMaster."Document Type";
                                ToDoctMaster."Project Code" := FromDocMaster."Project Code";
                                ToDoctMaster.Code := FromDocMaster.Code;
                                ToDoctMaster."Sale/Lease" := FromDocMaster."Sale/Lease";
                                ToDoctMaster.Description := FromDocMaster.Description;
                                ToDoctMaster."Rate/Sq. Yd" := FromDocMaster."Rate/Sq. Yd";
                                ToDoctMaster."Fixed Price" := FromDocMaster."Fixed Price";
                                ToDoctMaster."BP Dependency" := FromDocMaster."BP Dependency";
                                ToDoctMaster."Rate Not Allowed" := FromDocMaster."Rate Not Allowed";
                                ToDoctMaster."Project Price Dependency Code" := FromDocMaster."Project Price Dependency Code";
                                ToDoctMaster."Payment Plan Type" := FromDocMaster."Payment Plan Type";
                                ToDoctMaster."Commision Applicable" := FromDocMaster."Commision Applicable";
                                ToDoctMaster."Direct Associate" := FromDocMaster."Direct Associate";
                                ToDoctMaster.Sequence := FromDocMaster.Sequence;
                                ToDoctMaster."App. Charge Code" := FromDocMaster."App. Charge Code";
                                ToDoctMaster."App. Charge Name" := FromDocMaster."App. Charge Name";
                                ToDoctMaster."Effective From Date" := Rec."Effective From Date";
                                ToDoctMaster."Effective To Date" := Rec."Effective To Date";
                                ToDoctMaster.INSERT;
                            UNTIL FromDocMaster.NEXT = 0;
                            MESSAGE('%1', 'Charges upload successfully');
                        END;

                    end;
                }
                action(Open)
                {
                    Caption = 'Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Return';

                    trigger OnAction()
                    begin
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User ID",USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID",'MilestoneSetup');
                        IF NOT MemberOf.FINDFIRST THEN
                          ERROR('Please contact to Admin');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016


                        Rec.VALIDATE(Status, Rec.Status::Open);
                        Rec.MODIFY;
                        MESSAGE('%1', 'Document has successfully Open');

                    end;
                }
                action(Release)
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User ID",USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID",'MilestoneSetup');
                        IF NOT MemberOf.FINDFIRST THEN
                          ERROR('Please contact to Admin');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        Rec.VALIDATE(Status, Rec.Status::Release);
                        Rec.MODIFY;

                        MESSAGE('%1', 'Document has successfully Release');

                    end;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        ProjectMilestoneLine.RESET;
        ProjectMilestoneLine.SETRANGE(ProjectMilestoneLine."Document No.", Rec."Document No.");
        IF ProjectMilestoneLine.FINDFIRST THEN
            Rec.TESTFIELD(Status, Rec.Status::Release);
    end;

    var
        DocumentMaster: Record "Document Master";
        ProjectMilestoneLine: Record "Project Milestone Line";
}

