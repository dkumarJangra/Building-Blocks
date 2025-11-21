page 50033 "Gold Coin Date Correction"
{
    // ALLECK 160313: Added Role for Cheque Correction
    // ALLEAD-170313: Length of Cheque No/Transaction No. increased from 7 to 20
    // //ALLECK 240313 :Developed the functionality of Posting Date Correction

    PageType = List;
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Cust. Ledger Entry" = rimd,
                  TableData "Item Ledger Entry" = rimd,
                  TableData "Bank Account Ledger Entry" = rimd,
                  TableData "Detailed Cust. Ledg. Entry" = rimd,
                  TableData "Value Entry" = rimd,
                  TableData "Gate Pass Header" = rimd;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Customer No."; CustNo)
                {
                    Caption = 'Customer No.';
                    TableRelation = Customer;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        GPHdr.RESET;
                        GPHdr.SETRANGE("Document Type", GPHdr."Document Type"::MIN);
                        IF GPHdr.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Regular Gold/Silver Issue List", GPHdr) = ACTION::LookupOK THEN BEGIN
                                CustNo := GPHdr."Customer No.";
                                PostDate := GPHdr."Posting Date";
                            END;
                        END;
                    end;
                }
                field("MIN Document No."; DocumentNo)
                {
                    Caption = 'MIN Document No.';
                    TableRelation = "Gate Pass Header"."Document No." WHERE("Document Type" = CONST(MIN));

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        GPHdr.RESET;
                        GPHdr.SETRANGE("Document Type", GPHdr."Document Type"::MIN);
                        GPHdr.SETRANGE("Customer No.", CustNo);
                        IF GPHdr.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Regular Gold/Silver Issue List", GPHdr) = ACTION::LookupOK THEN BEGIN
                                PostDate := GPHdr."Posting Date";
                                DocumentNo := GPHdr."Document No.";
                            END;
                        END;
                    end;
                }
                field("Existing Posting Date"; PostDate)
                {
                    Caption = 'Existing Posting Date';
                    Editable = false;
                }
                field("New Posting Date"; NewPDate)
                {
                    Caption = 'New Posting Date';
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
                        //ALLECK 160313 START
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'A_PDATECORRECTION');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of role  :A_PDATECORRECTION');
                        //ALLECK 160313 End
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        IF DocumentNo = '' THEN
                            ERROR('Please define the MIN Document No');
                        IF NewPDate = 0D THEN
                            ERROR('Please define the New Posting Date');

                        IF CONFIRM('Do you want to change Posting Date') THEN BEGIN
                            ILEntry.RESET;
                            ILEntry.SETCURRENTKEY("Document No.");
                            ILEntry.SETRANGE("Document No.", DocumentNo);
                            IF ILEntry.FINDSET THEN
                                REPEAT
                                    ILEntry."Posting Date" := NewPDate;
                                    ILEntry.MODIFY;
                                UNTIL ILEntry.NEXT = 0;

                            ValueEntry.RESET;
                            ValueEntry.SETCURRENTKEY("Document No.");
                            ValueEntry.SETRANGE("Document No.", DocumentNo);
                            IF ValueEntry.FINDSET THEN
                                REPEAT
                                    ValueEntry."Posting Date" := NewPDate;
                                    ValueEntry.MODIFY;
                                UNTIL ValueEntry.NEXT = 0;

                            GLEntry.RESET;
                            GLEntry.SETCURRENTKEY("Document No.");
                            GLEntry.SETRANGE("Document No.", DocumentNo);
                            IF GLEntry.FINDSET THEN
                                REPEAT
                                    GLEntry."Posting Date" := NewPDate;
                                    GLEntry.MODIFY;
                                UNTIL GLEntry.NEXT = 0;

                            RecGPHdr.RESET;
                            RecGPHdr.SETCURRENTKEY("Document No.");
                            RecGPHdr.SETRANGE("Document No.", DocumentNo);
                            IF RecGPHdr.FINDSET THEN
                                REPEAT
                                    RecGPHdr."Posting Date" := NewPDate;
                                    RecGPHdr.MODIFY;
                                UNTIL RecGPHdr.NEXT = 0;


                            MESSAGE('Posting Date successfully update');
                            CLEARALL;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPAGEUpdateControl;
    end;

    var
        DocumentNo: Code[20];
        GPHdr: Record "Gate Pass Header";
        PDateCorrection: Boolean;
        NewPDate: Date;
        ILEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        PostDate: Date;
        CustNo: Code[10];
        GLEntry: Record "G/L Entry";
        RecGPHdr: Record "Gate Pass Header";
        MemberOf: Record "Access Control";


    procedure CurrPAGEUpdateControl()
    begin
    end;
}

