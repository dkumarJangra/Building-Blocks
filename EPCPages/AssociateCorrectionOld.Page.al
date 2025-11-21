page 50020 "Associate Correction Old"
{
    // Nature: This Page must be run prior Commission Generation. I.e. Associate Correction must be happen before generating commission.
    //         To be ran for a confirmed order.
    // //Added Role for Associate Correction
    // ALLECK 160313: Added role for Associate Correction

    PageType = List;
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Vendor Ledger Entry" = rimd,
                  TableData "Detailed Vendor Ledg. Entry" = rimd;
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Confirmed Order No."; BondNo)
                {
                    Caption = 'Confirmed Order No.';
                    TableRelation = "Confirmed Order";

                    trigger OnValidate()
                    begin
                        IF BondNo <> '' THEN BEGIN
                            ConfOrder.SETRANGE("No.", BondNo);
                            IF ConfOrder.FINDFIRST THEN BEGIN
                                IF Vend.GET(ConfOrder."Introducer Code") THEN;
                                ConfOrder.TESTFIELD(Status, ConfOrder.Status::Open);
                            END;
                        END;
                        IF NOT ConfOrder.FINDSET THEN BEGIN
                            CLEAR(ConfOrder);
                            ERROR('Not found');
                        END;
                    end;
                }
                field("Existing Associate No."; ConfOrder."Introducer Code")
                {
                    Caption = 'Existing Associate No.';
                    Editable = false;
                }
                field("Existing Associate Name"; Vend.Name)
                {
                    Caption = 'Existing Associate Name';
                    Editable = false;
                }
                field("Associate Correction"; AssociateNoCorrection)
                {
                    Caption = 'Associate Correction';

                    trigger OnValidate()
                    begin
                        AssociateNoCorrectionOnPush;
                    end;
                }
                field("New Associate No."; CorrectAssociateNo)
                {
                    Caption = 'New Associate No.';
                    Enabled = CorrectChequeNoEnable;
                    TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)" | "CP(Channel Partner)"));

                    trigger OnValidate()
                    begin
                        VendName := '';
                        IF CorrectAssociateNo <> '' THEN
                            IF RecVend.GET(CorrectAssociateNo) THEN
                                VendName := RecVend.Name
                            ELSE
                                VendName := '';
                    end;
                }
                field("New Associate Name"; VendName)
                {
                    Caption = 'New Associate Name';
                    Editable = false;
                    Enabled = VendNameEnable;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Function)
            {
                Caption = 'Function';
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
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        //ALLECK 160313 START
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'A_ASSCORRECTION');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of role  :A_ASSCORRECTION');
                        //ALLECK 160313 End
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        IF CorrectAssociateNo <> '' THEN
                            Vend.GET(CorrectAssociateNo)
                        ELSE
                            ERROR('Please define the New Associate No.');


                        IF CONFIRM('Update Associate Code') THEN BEGIN
                            IF ConfOrder.FINDFIRST THEN BEGIN
                                ConfOrder.TESTFIELD("Application Closed", FALSE);
                                CommEntry.RESET;
                                CommEntry.SETRANGE("Application No.", BondNo);
                                CommEntry.SETRANGE("Opening Entries", FALSE);
                                IF CommEntry.FINDFIRST THEN BEGIN
                                    ERROR('Commission already Created');
                                END;

                                TPDetails.RESET;
                                TPDetails.SETRANGE("Application No.", BondNo);
                                IF TPDetails.FINDFIRST THEN BEGIN
                                    ERROR('Travel already Created');
                                END;
                                IDEntry.RESET;
                                IDEntry.SETRANGE("Application No.", BondNo);
                                IF IDEntry.FINDFIRST THEN BEGIN
                                    ERROR('Incentive already created');
                                END;

                                CommEntry.RESET;
                                CommEntry.SETRANGE("Application No.", BondNo);
                                CommEntry.SETRANGE("Opening Entries", TRUE);
                                IF CommEntry.FINDFIRST THEN BEGIN
                                    CommEntry."Associate Code" := CorrectAssociateNo;
                                    CommEntry.MODIFY;
                                END;


                                UnitCommCreationBuffer.RESET;
                                UnitCommCreationBuffer.SETRANGE("Application No.", BondNo);
                                IF UnitCommCreationBuffer.FINDFIRST THEN
                                    REPEAT
                                        UnitCommCreationBuffer."Introducer Code" := CorrectAssociateNo;
                                        UnitCommCreationBuffer.MODIFY;
                                    UNTIL UnitCommCreationBuffer.NEXT = 0;

                                AppPayEntry.RESET;
                                AppPayEntry.SETRANGE("Application No.", BondNo);
                                IF AppPayEntry.FINDFIRST THEN
                                    REPEAT
                                        AppPayEntry."Introducer Code" := CorrectAssociateNo;
                                        AppPayEntry.MODIFY;
                                    UNTIL AppPayEntry.NEXT = 0;


                                ConfOrder."Introducer Code" := CorrectAssociateNo;
                                ConfOrder."Received From Code" := CorrectAssociateNo;//ALLECK 310313
                                ConfOrder.MODIFY;
                                MESSAGE('Associate successfully changed');
                            END;
                            CLEARALL;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        VendNameEnable := TRUE;
        CorrectChequeNoEnable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        CurrPageUpdateControl;
    end;

    var
        AssociateNoCorrection: Boolean;
        CorrectAssociateNo: Text[20];
        BondNo: Code[20];
        ApplicationPaymentEntry: Record "Application Payment Entry";
        UnitPaymentEntry: Record "Unit Payment Entry";
        PostDocNo: Code[20];
        ConfOrder: Record "Confirmed Order";
        AssociateCode: Code[20];
        RecVend: Record Vendor;
        Vend: Record Vendor;
        CommEntry: Record "Commission Entry";
        UnitCommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        UnitPayEntry: Record "Unit Payment Entry";
        AppPayEntry: Record "Application Payment Entry";
        AppNo: Code[20];
        TPDetails: Record "Travel Payment Details";
        IDEntry: Record "Incentive Detail Entry";
        VendName: Text[80];

        CorrectChequeNoEnable: Boolean;

        VendNameEnable: Boolean;
        MemberOf: Record "Access Control";


    procedure CurrPageUpdateControl()
    begin

        CorrectChequeNoEnable := AssociateNoCorrection;
        VendNameEnable := AssociateNoCorrection;
    end;

    local procedure AssociateNoCorrectionOnPush()
    begin
        CurrPageUpdateControl;
    end;
}

