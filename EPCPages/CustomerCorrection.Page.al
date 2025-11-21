page 97982 "Customer Correction"
{
    // The Correction to Customer must be prior to issue of a gold coin in an applicaton.
    // ALLECK 160313: Added Role for Customer Correction
    // AD:160313:BBG1.00 Sell to Customer No. update.

    PageType = List;
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Cust. Ledger Entry" = rimd,
                  TableData "Detailed Cust. Ledg. Entry" = rimd;
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Confirmed Order No."; BondNo)
                {
                    Caption = 'Confirmed Order No.';
                    TableRelation = "Confirmed Order" WHERE(Status = FILTER(Open));

                    trigger OnValidate()
                    begin
                        //CompanyWise.RESET;
                        //CompanyWise.SETRANGE(CompanyWise."MSC Company",TRUE);
                        //IF CompanyWise.FINDFIRST THEN
                        //  IF CompanyWise."Company Code" = COMPANYNAME THEN
                        //    ERROR('This task can not perform in this company.');

                        ExistsCustName := '';
                        ExistsCustNo := '';
                        IF BondNo <> '' THEN BEGIN
                            ConfOrder.SETRANGE("No.", BondNo);
                            IF ConfOrder.FINDFIRST THEN BEGIN
                                ExistsCustNo := ConfOrder."Customer No.";
                                ConfOrder.TESTFIELD(Status, ConfOrder.Status::Open);
                                IF Cust.GET(ConfOrder."Customer No.") THEN
                                    ExistsCustName := Cust.Name;
                            END;
                        END;
                        IF NOT ConfOrder.FINDSET THEN BEGIN
                            CLEAR(ConfOrder);
                            ERROR('Not found');
                        END;
                    end;
                }
                field("Existing Member No."; ExistsCustNo)
                {
                    Caption = 'Existing Member No.';
                    Editable = false;
                }
                field("Existing Member Name"; ExistsCustName)
                {
                    Caption = 'Existing Member Name';
                    Editable = false;
                }
                field("Member Correction"; AssociateNoCorrection)
                {
                    Caption = 'Member Correction';

                    trigger OnValidate()
                    begin
                        AssociateNoCorrectionOnPush;
                    end;
                }
                field("New Member No."; CorrectAssociateNo)
                {
                    Caption = 'New Member No.';
                    Enabled = CorrectChequeNoEnable;
                    TableRelation = Customer WHERE("Customer Posting Group" = FILTER('DEB-MEMBER'));

                    trigger OnValidate()
                    begin
                        CustName := '';
                        IF CorrectAssociateNo <> '' THEN
                            IF RecVend.GET(CorrectAssociateNo) THEN
                                CustName := RecVend.Name
                            ELSE
                                CustName := '';
                    end;
                }
                field("New Member Name"; CustName)
                {
                    Caption = 'New Member Name';
                    Editable = false;
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
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        ReleaseBondApplication: Codeunit "Release Unit Application";
                    begin
                        //ALLECK 160313 START
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'A_CUSTCORRECTION');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of role  :A_CUSTCORRECTION');
                        //ALLECK 160313 End

                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        IF CorrectAssociateNo <> '' THEN
                            Cust.GET(CorrectAssociateNo)
                        ELSE
                            ERROR('Please define the New Member No.');


                        IF CONFIRM('Update Member No.') THEN BEGIN
                            //ALLECK 310313 START
                            //-------------------To Archive the Confirmed Oredr -------------------Start

                            ConfOrder.CALCFIELDS("Amount Received");
                            ConfOrder.CALCFIELDS("Total Received Amount");
                            ConfOrder.CALCFIELDS("Amount Refunded");
                            ConfOrder.TESTFIELD("Application Closed", FALSE);
                            ConfOrder.TESTFIELD("Registration Status", ConfOrder."Registration Status"::" "); //090921

                            ArchConf.RESET;
                            ArchConf.SETRANGE("No.", BondNo);
                            IF ArchConf.FINDLAST THEN
                                Versn := ArchConf."Version No."
                            ELSE
                                Versn := 0;

                            ArchConf.INIT;
                            ArchConf.TRANSFERFIELDS(ConfOrder);
                            ArchConf."Version No." := Versn + 1;
                            ArchConf."Archive Date" := TODAY;
                            ArchConf."Archive Time" := TIME;
                            ArchConf."Total Received Amount" := ConfOrder."Total Received Amount";
                            ArchConf."Amount Received" := ConfOrder."Amount Received";
                            ArchConf."Amount Refunded" := ConfOrder."Amount Refunded";
                            ArchConf.INSERT;

                            //------------------To Archive the Confirmed Order----------------------End

                            PmntTrmsLineSale.RESET;
                            PmntTrmsLineSale.SETRANGE("Document No.", BondNo);
                            IF PmntTrmsLineSale.FINDSET THEN
                                REPEAT
                                    IF AssociateNoCorrection THEN BEGIN
                                        PmntTrmsLineSale."Customer No." := CorrectAssociateNo;
                                        PmntTrmsLineSale.MODIFY;
                                    END;
                                UNTIL PmntTrmsLineSale.NEXT = 0;

                            //ALLECK 310313 END

                            GLEntry.RESET;
                            GLEntry.SETCURRENTKEY("Document No.");
                            GLEntry.SETRANGE("BBG Order Ref No.", BondNo);
                            GLEntry.SETRANGE("Source Type", GLEntry."Source Type"::Customer);
                            GLEntry.SETRANGE("Source No.", ConfOrder."Customer No.");
                            IF GLEntry.FINDSET THEN BEGIN
                                REPEAT
                                    IF AssociateNoCorrection THEN BEGIN
                                        GLEntry."Source No." := CorrectAssociateNo;
                                        GLEntry.MODIFY;
                                        PostDocNo := GLEntry."Document No.";

                                        CustLedgerEntry.RESET;
                                        CustLedgerEntry.SETCURRENTKEY("Document No.");
                                        CustLedgerEntry.SETRANGE("Document No.", PostDocNo);
                                        IF CustLedgerEntry.FINDSET THEN
                                            REPEAT
                                                IF AssociateNoCorrection THEN BEGIN
                                                    CustLedgerEntry."Customer No." := CorrectAssociateNo;
                                                    CustLedgerEntry."Sell-to Customer No." := CorrectAssociateNo;
                                                    CustLedgerEntry.MODIFY;
                                                END;
                                            UNTIL CustLedgerEntry.NEXT = 0;

                                        DtlCustLedgerEntry.RESET;
                                        DtlCustLedgerEntry.SETCURRENTKEY("Document No.");
                                        DtlCustLedgerEntry.SETRANGE("Document No.", PostDocNo);
                                        IF DtlCustLedgerEntry.FINDSET THEN
                                            REPEAT
                                                IF AssociateNoCorrection THEN BEGIN
                                                    DtlCustLedgerEntry."Customer No." := CorrectAssociateNo;
                                                    DtlCustLedgerEntry.MODIFY;
                                                END;
                                            UNTIL DtlCustLedgerEntry.NEXT = 0;
                                    END;
                                UNTIL GLEntry.NEXT = 0;
                            END ELSE
                                ERROR('GL Entry not found');


                            ConfOrder."Customer No." := CorrectAssociateNo;
                            ConfOrder."Bill-to Customer Name" := CustName;
                            ConfOrder.MODIFY;
                            CLEAR(NewConforder);
                            IF NewConforder.GET(BondNo) THEN BEGIN
                                NewConforder."Customer No." := CorrectAssociateNo;
                                NewConforder."Bill-to Customer Name" := CustName;
                                NewConforder.MODIFY;
                                CompanyWise.RESET;
                                CompanyWise.SETRANGE(CompanyWise."MSC Company", TRUE);
                                IF CompanyWise.FINDFIRST THEN BEGIN
                                    CLEAR(RecUMaster);
                                    RecUMaster.CHANGECOMPANY(CompanyWise."Company Code");
                                    IF RecUMaster.GET(NewConforder."Unit Code") THEN BEGIN
                                        RespCenter.RESET;
                                        RespCenter.CHANGECOMPANY(CompanyWise."Company Code");
                                        IF RespCenter.GET(NewConforder."Shortcut Dimension 1 Code") THEN BEGIN
                                            IF RespCenter."Publish CustomerName" THEN BEGIN
                                                RecUMaster."Customer Name" := NewConforder."Bill-to Customer Name";
                                            END;
                                            RecUMaster.MODIFY;
                                        END;
                                    END;
                                END;
                            END;


                            MESSAGE('Customer successfully changed');
                            WebAppService.UpdateUnitStatus(RecUMaster);  //210624
                        END;
                        CLEARALL;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        CorrectChequeNoEnable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        CurrPAGEUpdateControl;
    end;

    var
        AssociateNoCorrection: Boolean;
        CorrectAssociateNo: Text[20];
        BondNo: Code[20];
        ApplicationPaymentEntry: Record "Application Payment Entry";
        PostDocNo: Code[20];
        ConfOrder: Record "Confirmed Order";
        AssociateCode: Code[20];
        RecVend: Record Customer;
        Cust: Record Customer;
        CommEntry: Record "Commission Entry";
        UnitPayEntry: Record "Unit Payment Entry";
        AppPayEntry: Record "Application Payment Entry";
        AppNo: Code[20];
        TPDetails: Record "Travel Payment Details";
        IDEntry: Record "Incentive Detail Entry";
        GLEntry: Record "G/L Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DtlCustLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        BondType: Option Application,"Confirmed Order";
        GoldCoinEligibility: Record "Gold Coin Eligibility";
        CustName: Text[80];
        ArchConf: Record "Archive Confirmed Order";
        Versn: Integer;
        PmntTrmsLineSale: Record "Payment Terms Line Sale";
        NewConforder: Record "New Confirmed Order";
        CompanyWise: Record "Company wise G/L Account";
        RecUMaster: Record "Unit Master";
        RespCenter: Record "Responsibility Center 1";

        CorrectChequeNoEnable: Boolean;
        Text19045372: Label 'Customer change in respective Co. / LLP.';
        ExistsCustName: Text;
        ExistsCustNo: Code[20];
        MemberOf: Record "Access Control";
        WebAppService: Codeunit "Web App Service";


    procedure CurrPAGEUpdateControl()
    begin

        CorrectChequeNoEnable := AssociateNoCorrection;
    end;

    local procedure AssociateNoCorrectionOnPush()
    begin
        CurrPAGEUpdateControl;
    end;
}

