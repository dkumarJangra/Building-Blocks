page 50062 "Ass. Pmt posting Date correct"
{
    // ALLECK 160313: Added Role for Cheque Correction
    // ALLEAD-170313: Length of Cheque No/Transaction No. increased from 7 to 20
    // //ALLECK 240313 :Developed the functionality of Posting Date Correction

    PageType = List;
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Cust. Ledger Entry" = rimd,
                  TableData "Vendor Ledger Entry" = rimd,
                  TableData "Purch. Inv. Header" = rimd,
                  TableData "Bank Account Ledger Entry" = rimd,
                  TableData "Detailed Cust. Ledg. Entry" = rimd,
                  TableData "Detailed Vendor Ledg. Entry" = rimd,
                  TableData "Associate Payment Hdr" = rim;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field(PostDocNo; PostDocNo)
                {
                    Caption = 'Posted Document No.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PostDate := 0D;
                        RecGLEntry.RESET;
                        RecGLEntry.SETRANGE("Document Type", RecGLEntry."Document Type"::Payment);
                        IF RecGLEntry.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"General Ledger Entries", RecGLEntry) = ACTION::LookupOK THEN BEGIN
                                PostDocNo := RecGLEntry."Document No.";
                                PostDate := RecGLEntry."Posting Date";
                            END;
                        END;
                    end;

                    trigger OnValidate()
                    begin
                        AssocPmtVoucherHeader1.RESET;
                        AssocPmtVoucherHeader1.SETRANGE("Posted Document No.", PostDocNo);
                        IF AssocPmtVoucherHeader1.FINDFIRST THEN BEGIN
                            IF AssocPmtVoucherHeader1."Pmt from MS Company Ref. No." <> '' THEN
                                ERROR('Posting date will not change from LLP Company for this document No.');
                        END;
                        PostDocNoOnAfterValidate;
                    end;
                }
                field(CorrectChequeNo; RecGLEntry."Posting Date")
                {
                    Caption = 'Existing Posting Date';
                    Editable = false;
                }
                field("Posting Date Correction"; PDateCorrection)
                {
                    Caption = 'Posting Date Correction';

                    trigger OnValidate()
                    begin
                        PDateCorrectionOnPush;
                    end;
                }
                field(NewPDate; NewPDate)
                {
                    Caption = 'New Posting Date';
                    Enabled = NewPDateEnable;
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

                        Memberof.SETRANGE(Memberof."User Name", USERID);
                        Memberof.SETRANGE(Memberof."Role ID", 'A_PDATECORRECTION');
                        IF NOT Memberof.FINDFIRST THEN
                            ERROR('You do not have permission of role  :A_PDATECORRECTION');

                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        IF PostDocNo = '' THEN
                            ERROR('Please define the Posted Document No');
                        IF NewPDate = 0D THEN
                            ERROR('Please define the New Posting Date');



                        Companywise.RESET;
                        Companywise.SETRANGE(Companywise."MSC Company", TRUE);
                        IF Companywise.FINDFIRST THEN
                            IF CONFIRM('Change Posting Date Details') THEN BEGIN
                                IF Companywise."Company Code" = COMPANYNAME THEN BEGIN
                                    RecGLEntry1.RESET;
                                    RecGLEntry1.SETCURRENTKEY("Document No.", "Entry No.");
                                    RecGLEntry1.SETRANGE("Document No.", PostDocNo);
                                    IF RecGLEntry1.FINDSET THEN
                                        REPEAT
                                            RecGLEntry1."Posting Date" := NewPDate;
                                            RecGLEntry1."Document Date" := NewPDate;
                                            RecGLEntry1.MODIFY;
                                        UNTIL RecGLEntry1.NEXT = 0;
                                    RecBALEntry.RESET;
                                    RecBALEntry.SETCURRENTKEY("Document No.");
                                    RecBALEntry.SETRANGE("Document No.", PostDocNo);
                                    IF RecBALEntry.FINDSET THEN
                                        REPEAT
                                            RecBALEntry."Posting Date" := NewPDate;
                                            RecBALEntry.MODIFY;
                                        UNTIL RecBALEntry.NEXT = 0;

                                    AssoPmtHdr.RESET;
                                    AssoPmtHdr.SETCURRENTKEY("Posted Document No.");
                                    AssoPmtHdr.SETRANGE("Posted Document No.", PostDocNo);
                                    IF AssoPmtHdr.FINDSET THEN
                                        REPEAT
                                            //020316
                                            //  AssocPmtVoucherHeader.RESET;
                                            // AssocPmtVoucherHeader.CHANGECOMPANY(AssoPmtHdr."Company Name");
                                            // AssocPmtVoucherHeader.SETRANGE("Pmt from MS Company Ref. No.",AssoPmtHdr."Document No.");
                                            // IF AssocPmtVoucherHeader.FINDSET THEN
                                            //  REPEAT
                                            //  AssocPmtVoucherHeader.CALCFIELDS("Posted Document No.");
                                            //020316
                                            GLEntry.RESET;
                                            GLEntry.CHANGECOMPANY(AssoPmtHdr."Company Name");
                                            GLEntry.SETCURRENTKEY("External Document No.", "Document Type");
                                            //       GLEntry.SETRANGE("External Document No.",AssocPmtVoucherHeader."Document No."); //020316
                                            GLEntry.SETRANGE("External Document No.", AssoPmtHdr."Document No."); //020316
                                            IF GLEntry.FINDSET THEN
                                                REPEAT
                                                    GLEntry."Posting Date" := NewPDate;
                                                    GLEntry."Document Date" := NewPDate;
                                                    GLEntry.MODIFY;
                                                UNTIL GLEntry.NEXT = 0;
                                            VLEntry.RESET;
                                            VLEntry.CHANGECOMPANY(AssoPmtHdr."Company Name");
                                            VLEntry.SETCURRENTKEY("External Document No.");
                                            VLEntry.SETRANGE("External Document No.", AssoPmtHdr."Document No."); //AssocPmtVoucherHeader."Document No.");
                                            IF VLEntry.FINDSET THEN
                                                REPEAT
                                                    VLEntry."Posting Date" := NewPDate;
                                                    VLEntry."Document Date" := NewPDate;
                                                    VLEntry.MODIFY;

                                                    DetVLEntry.RESET;
                                                    DetVLEntry.CHANGECOMPANY(AssoPmtHdr."Company Name");
                                                    DetVLEntry.SETCURRENTKEY("Document No.", "Entry No.");
                                                    DetVLEntry.SETRANGE("Document No.", VLEntry."Document No.");
                                                    IF DetVLEntry.FINDSET THEN
                                                        REPEAT
                                                            DetVLEntry."Posting Date" := NewPDate;
                                                            DetVLEntry.MODIFY;
                                                        UNTIL DetVLEntry.NEXT = 0;
                                                    TDSEntry.RESET;
                                                    TDSEntry.CHANGECOMPANY(AssoPmtHdr."Company Name");
                                                    TDSEntry.SETCURRENTKEY("Document No.");
                                                    TDSEntry.SETRANGE("Document No.", VLEntry."Document No.");
                                                    IF TDSEntry.FINDSET THEN
                                                        REPEAT
                                                            TDSEntry."Posting Date" := NewPDate;
                                                            TDSEntry.MODIFY;
                                                        UNTIL TDSEntry.NEXT = 0;
                                                UNTIL VLEntry.NEXT = 0;

                                            PIHeader.RESET;
                                            PIHeader.SETCURRENTKEY("Vendor Invoice No.");
                                            PIHeader.CHANGECOMPANY(AssoPmtHdr."Company Name");
                                            PIHeader.SETRANGE("Vendor Invoice No.", AssocPmtVoucherHeader."Document No.");
                                            IF PIHeader.FINDFIRST THEN BEGIN
                                                PIHeader."Posting Date" := NewPDate;
                                                PIHeader."Document Date" := NewPDate;
                                                PIHeader.MODIFY;
                                            END;
                                            //020316
                                            //  AssocPmtVoucherHeader."Posting Date" := NewPDate;
                                            //  AssocPmtVoucherHeader."Document Date" := NewPDate;
                                            //  AssocPmtVoucherHeader.MODIFY;
                                            // UNTIL  AssocPmtVoucherHeader.NEXT=0;
                                            //020316
                                            AssoPmtHdr."Posting Date" := NewPDate;
                                            AssoPmtHdr."Document Date" := NewPDate;
                                            AssoPmtHdr.MODIFY;
                                        UNTIL AssoPmtHdr.NEXT = 0;
                                END ELSE BEGIN
                                    AssocPmtVoucherHeader1.RESET;
                                    AssocPmtVoucherHeader1.SETCURRENTKEY("Posting Date");
                                    AssocPmtVoucherHeader1.SETRANGE("Posting Date", PostDate);
                                    AssocPmtVoucherHeader1.CALCFIELDS("Posted Document No.");
                                    AssocPmtVoucherHeader1.SETRANGE("Posted Document No.", PostDocNo);
                                    IF AssocPmtVoucherHeader1.FINDFIRST THEN BEGIN
                                        IF AssocPmtVoucherHeader1."Pmt from MS Company Ref. No." <> '' THEN
                                            ERROR('Posting date will not change from LLP Company');
                                        GLEntry.RESET;
                                        GLEntry.SETCURRENTKEY("External Document No.", "Document Type");
                                        GLEntry.SETRANGE("External Document No.", AssocPmtVoucherHeader1."Document No.");
                                        IF GLEntry.FINDFIRST THEN BEGIN
                                            GLEntry_2.RESET;
                                            GLEntry_2.SETCURRENTKEY("Document No.");
                                            GLEntry_2.SETRANGE("Document No.", GLEntry."Document No.");
                                            IF GLEntry_2.FINDSET THEN
                                                REPEAT
                                                    GLEntry_2."Posting Date" := NewPDate;
                                                    GLEntry_2."Document Date" := NewPDate;
                                                    GLEntry_2.MODIFY;
                                                UNTIL GLEntry_2.NEXT = 0;
                                        END;
                                        VLEntry1.RESET;
                                        VLEntry1.SETCURRENTKEY("External Document No.");
                                        VLEntry1.SETRANGE("External Document No.", AssocPmtVoucherHeader1."Document No.");
                                        IF VLEntry1.FINDSET THEN
                                            REPEAT
                                                VLEntry2.RESET;
                                                VLEntry2.SETCURRENTKEY("Document No.");
                                                VLEntry2.SETRANGE("Document No.", VLEntry1."Document No.");
                                                IF VLEntry2.FINDSET THEN
                                                    REPEAT
                                                        VLEntry2."Posting Date" := NewPDate;
                                                        VLEntry2."Document Date" := NewPDate;
                                                        VLEntry2.MODIFY;
                                                    UNTIL VLEntry2.NEXT = 0;

                                                DetVLEntry.RESET;
                                                DetVLEntry.SETCURRENTKEY("Document No.", "Entry No.");
                                                DetVLEntry.SETRANGE("Document No.", VLEntry1."Document No.");
                                                IF DetVLEntry.FINDSET THEN
                                                    REPEAT
                                                        DetVLEntry."Posting Date" := NewPDate;
                                                        DetVLEntry.MODIFY;
                                                    UNTIL DetVLEntry.NEXT = 0;
                                                TDSEntry.RESET;
                                                TDSEntry.SETCURRENTKEY("Document No.");
                                                TDSEntry.SETRANGE("Document No.", VLEntry1."Document No.");
                                                IF TDSEntry.FINDSET THEN
                                                    REPEAT
                                                        TDSEntry."Posting Date" := NewPDate;
                                                        TDSEntry.MODIFY;
                                                    UNTIL TDSEntry.NEXT = 0;
                                            UNTIL VLEntry1.NEXT = 0;

                                        PIHeader1.RESET;
                                        PIHeader1.SETCURRENTKEY("Vendor Invoice No.");
                                        PIHeader1.SETRANGE("Vendor Invoice No.", AssocPmtVoucherHeader1."Document No.");
                                        IF PIHeader1.FINDFIRST THEN BEGIN
                                            PIHeader1."Posting Date" := NewPDate;
                                            PIHeader1."Document Date" := NewPDate;
                                            PIHeader1.MODIFY;
                                        END;

                                        RecBALEntry1.RESET;
                                        RecBALEntry1.SETCURRENTKEY("Document No.");
                                        RecBALEntry1.SETRANGE("Document No.", PostDocNo);
                                        IF RecBALEntry1.FINDSET THEN
                                            REPEAT
                                                RecBALEntry1."Posting Date" := NewPDate;
                                                RecBALEntry1.MODIFY;
                                            UNTIL RecBALEntry1.NEXT = 0;

                                        Companywise1.RESET;
                                        Companywise1.SETRANGE("MSC Company", TRUE);
                                        IF Companywise1.FINDFIRST THEN BEGIN
                                            AssociatePmtHdr1.RESET;
                                            AssociatePmtHdr1.CHANGECOMPANY(Companywise1."Company Code");
                                            AssociatePmtHdr1.SETRANGE("Document No.", AssocPmtVoucherHeader1."Pmt from MS Company Ref. No.");
                                            IF AssociatePmtHdr1.FINDFIRST THEN BEGIN
                                                RecBALEntry1.RESET;
                                                RecBALEntry1.CHANGECOMPANY(Companywise1."Company Code");
                                                RecBALEntry1.SETRANGE("Document No.", AssociatePmtHdr1."Posted Document No.");
                                                IF RecBALEntry1.FINDSET THEN
                                                    REPEAT
                                                        RecBALEntry1."Posting Date" := NewPDate;
                                                        RecBALEntry1.MODIFY;
                                                    UNTIL RecBALEntry1.NEXT = 0;

                                                RecGLEntry1.RESET;
                                                RecGLEntry1.CHANGECOMPANY(Companywise1."Company Code");
                                                RecGLEntry1.SETCURRENTKEY("Document No.", "Entry No.");
                                                RecGLEntry1.SETRANGE("Document No.", AssociatePmtHdr1."Posted Document No.");
                                                IF RecGLEntry1.FINDSET THEN
                                                    REPEAT
                                                        RecGLEntry1."Posting Date" := NewPDate;
                                                        RecGLEntry1."Document Date" := NewPDate;
                                                        RecGLEntry1.MODIFY;
                                                    UNTIL RecGLEntry1.NEXT = 0;
                                            END;

                                            AssocPmtVoucherHeader1."Posting Date" := NewPDate;
                                            AssocPmtVoucherHeader1."Document Date" := NewPDate;
                                            AssocPmtVoucherHeader1.MODIFY;
                                        END;
                                    END;
                                END;
                                MESSAGE('Posting Date successfully update');
                                CLEARALL;
                            END;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        NewPDateEnable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        CurrPAGEUpdateControl;
    end;

    var
        PostDocNo: Code[20];
        GLEntry: Record "G/L Entry";
        RecBALEntry: Record "Bank Account Ledger Entry";
        PDateCorrection: Boolean;
        NewPDate: Date;
        LastVersion: Integer;
        Companywise: Record "Company wise G/L Account";
        RecGLEntry: Record "G/L Entry";
        AssoPmtHdr: Record "Associate Payment Hdr";
        VLEntry: Record "Vendor Ledger Entry";
        AssocPmtVoucherHeader: Record "Assoc Pmt Voucher Header";
        DetVLEntry: Record "Detailed Vendor Ledg. Entry";
        PIHeader: Record "Purch. Inv. Header";
        TDSEntry: Record "TDS Entry";
        GLEntry1: Record "G/L Entry";
        AssocPmtVoucherHeader1: Record "Assoc Pmt Voucher Header";
        AssociatePmtHdr1: Record "Associate Payment Hdr";
        VLEntry1: Record "Vendor Ledger Entry";
        PIHeader1: Record "Purch. Inv. Header";
        RecBALEntry1: Record "Bank Account Ledger Entry";
        Companywise1: Record "Company wise G/L Account";
        RecGLEntry1: Record "G/L Entry";
        VLEntry2: Record "Vendor Ledger Entry";

        NewPDateEnable: Boolean;
        Memberof: Record "Access Control";
        PostDate: Date;
        GLEntry_2: Record "G/L Entry";


    procedure CurrPAGEUpdateControl()
    begin
        NewPDateEnable := PDateCorrection;
    end;

    local procedure PostDocNoOnAfterValidate()
    begin
        AssocPmtVoucherHeader1.RESET;
        AssocPmtVoucherHeader1.SETRANGE("Posted Document No.", PostDocNo);
        IF AssocPmtVoucherHeader1.FINDFIRST THEN BEGIN
            IF AssocPmtVoucherHeader1."Pmt from MS Company Ref. No." <> '' THEN
                ERROR('Posting date will not change from LLP Company for this document No.');
        END;
    end;

    local procedure PDateCorrectionOnPush()
    begin
        CurrPAGEUpdateControl;
    end;
}

