table 97786 "Fixed Deposit Details"
{
    // 
    // +------------------------------------------+
    // | Voith Turbo Private Limited , Hyderabad  |
    // +------------------------------------------+
    // 
    // -------------------------------------------------------------------------------------------------------------
    // Local Specifications
    // -------------------------------------------------------------------------------------------------------------
    // Nr. Update    Date       SS         No.      Description
    // -------------------------------------------------------------------------------------------------------------
    // L01           26.06.09   Hyd_Msr             New fields, Attachment No.,Attachment No. 2, Attachment No.3,TDS Rate,
    //                                              TDS Amount,Int Rate on Liquidation,Selected created.
    // L02           26.06.09   Hyd_Msr             New functions, Import Attachment,Import Attachment2,Import Attachment3,
    //                                              RemoveAttachment,RemoveAttachment2,RemoveAttachment3,OpenAttachment,
    //                                              OpenAttachment2,OpenAttachment3,GetInterestAmount,GetTDSAmount created.
    // L03           26.06.09   Hyd_Msr             New Text constants,Text001,Text002,Text003 added.
    // ALLEPG RIL1.09 121011 : Added fields

    LookupPageID = "FD List";

    fields
    {
        field(1; "FD No."; Code[20])
        {
        }
        field(2; "FD Start date"; Date)
        {
            Description = 'Alle SP VSID 0016';
        }
        field(3; "FD maturity date"; Date)
        {
            Description = 'Alle SP VSID 0016';

            trigger OnValidate()
            begin
                IF "FD maturity date" < "FD Start date" THEN
                    ERROR('Maturity date cannot be less than the Start Date')
            end;
        }
        field(4; "Interest rate"; Decimal)
        {
            Description = 'Alle SP VSID 0016';
            MaxValue = 100;
            MinValue = 0;
        }
        field(5; "FD Amount"; Decimal)
        {
            Description = 'Alle SP VSID 0016';
        }
        field(6; Type; Option)
        {
            Description = 'Alle SP VSID 0016';
            OptionCaption = ' ,Pledged,Non pledged';
            OptionMembers = " ",Pledged,"Non pledged";
        }
        field(7; "Intrest Amount"; Decimal)
        {
            Description = 'ALLEPP   : Added field for  Voith Siemens';

            trigger OnValidate()
            begin
                "Total Maturity Amount" := "Intrest Amount" + "FD Amount";
            end;
        }
        field(8; "Bank Account No."; Code[20])
        {
            Description = 'Alle SP 11-08-05';
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                IF BankAcccount.GET("Bank Account No.") THEN
                    "Bank Name" := BankAcccount.Name
                ELSE
                    "Bank Name" := ''
            end;
        }
        field(9; "Bank Name"; Text[60])
        {
            Description = 'Alle SP 11-08-05';
            Editable = false;
        }
        field(10; Status; Option)
        {
            Description = 'Alle SP 25-Jan-06';
            OptionCaption = 'Open,Matured,Liquidated';
            OptionMembers = Open,Matured,Liquidated;
        }
        field(11; "Total Maturity Amount"; Decimal)
        {
            Description = 'Alle SP 25-Jan-06';

            trigger OnValidate()
            begin
                "Intrest Amount" := "Total Maturity Amount" - "FD Amount";
            end;
        }
        field(12; "Bank FD Account No."; Code[50])
        {
            Description = 'Alle SP 25-Jan-06';
        }
        field(13; "Actual Closed Date"; Date)
        {
            Description = 'Alle SP 25-May-06';
        }
        field(14; "Attachment No."; Integer)
        {
            Description = 'L01';
        }
        field(15; "Attachment No. 2"; Integer)
        {
            Description = 'L01';
        }
        field(16; "Attachment No. 3"; Integer)
        {
            Description = 'L01';
        }
        field(30; "TDS Rate"; Decimal)
        {
            Description = 'L01';
        }
        field(31; "TDS Amount"; Decimal)
        {
            Description = 'L01';
        }
        field(32; "Int Rate on Liquidation"; Decimal)
        {
            Description = 'L01';
        }
        field(33; Selected; Boolean)
        {
            Description = 'L01';
        }
        field(50000; "FD Placement Entries Created"; Boolean)
        {
            Editable = false;
        }
        field(50001; "FD Liquidation Entries Created"; Boolean)
        {
            Editable = false;
        }
        field(50002; "BG / LC No."; Code[20])
        {
            //TableRelation = "LC Detail"."No.";
        }
        field(50003; "Bank FD Receipt No."; Code[20])
        {
        }
        field(50004; "FD Type"; Option)
        {
            OptionCaption = ' ,EMD,BG,Security,Other,LC';
            OptionMembers = " ",EMD,BG,Security,Other,LC;
        }
        field(50005; "Interest Amt on Liquidation"; Decimal)
        {
        }
        field(50006; "Benificiary Name"; Text[50])
        {
            Description = 'ALLEPG 121011';
        }
        field(50007; Period; Text[30])
        {
            Description = 'ALLEPG 121011';
        }
        field(50008; "Tender Notice No."; Text[50])
        {
            Description = 'ALLEDK 171011';
        }
    }

    keys
    {
        key(Key1; "FD No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        StrError := '';
        IF "FD Start date" = 0D THEN
            StrError := '\' + txtStart;
        IF "FD maturity date" = 0D THEN
            StrError := StrError + '\' + 'Fixed Deposit Maturity Date ';
        IF "Interest rate" = 0 THEN
            StrError := StrError + '\' + 'Fixed Deposit Interest Date ';
        IF "FD Amount" = 0 THEN
            StrError := StrError + '\' + 'Fixed Deposit Amount ';
        IF Type = 0 THEN
            StrError := StrError + '\' + 'Fixed Deposit Type ';
        IF "Bank Account No." = '' THEN
            StrError := StrError + '\' + 'Bank Account No.';
        IF "Bank FD Account No." = '' THEN
            StrError := StrError + '\' + 'Bank FD No.';

        IF StrError <> '' THEN BEGIN
            StrError := 'The Following Details are required to create a Fixed Deposit Card \' + StrError;
            ERROR(StrError);
        END;



        IF "FD No." = '' THEN BEGIN
            GLSetup.GET;
            GLSetup.TESTFIELD(GLSetup."FD No. Series");
            "FD No." := NoSeriesMgt.GetNextNo(GLSetup."FD No. Series", TODAY, TRUE)
        END;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        BankAcccount: Record "Bank Account";
        StrError: Text[250];
        txtStart: Label 'Fixed Deposit Start Date';
        Text001: Label 'Do you want to replace the attachment ?';
        Text002: Label 'The attachment does not exist.';
        Text003: Label 'The attachment does not exist.';


    procedure ImportAttachment()
    var
        Attachment: Record Attachment;
        AttachmentManagement: Codeunit AttachmentManagement;
    begin
        IF "Attachment No." <> 0 THEN BEGIN
            IF Attachment.GET("Attachment No.") THEN
                Attachment.TESTFIELD("Read Only", FALSE);
            IF NOT CONFIRM(Text001, FALSE) THEN
                EXIT
            ELSE
                "Attachment No." := 0;
        END;
        //IF Attachment.ImportAttachment('',FALSE,FALSE) THEN BEGIN // ALLE MM Code Commented
        /*
        IF Attachment.ImportAttachmentFromClientFile('', FALSE, FALSE) THEN BEGIN // ALLE MM Code Added
            "Attachment No." := Attachment."No.";
            MODIFY;
        END ELSE
            ERROR(Text002);
            *///Code is not supported in BC Cloud
    end;


    procedure ImportAttachment2()
    var
        Attachment: Record Attachment;
        AttachmentManagement: Codeunit AttachmentManagement;
    begin
        IF "Attachment No. 2" <> 0 THEN BEGIN
            IF Attachment.GET("Attachment No. 2") THEN
                Attachment.TESTFIELD("Read Only", FALSE);

            IF NOT CONFIRM(Text001, FALSE) THEN
                EXIT
            ELSE
                "Attachment No. 2" := 0;
        END;

        //IF Attachment.ImportAttachment('',FALSE,FALSE) THEN BEGIN  // ALLE MM Code Commented
        /*
        IF Attachment.ImportAttachmentFromClientFile('', FALSE, FALSE) THEN BEGIN // ALLE MM Code Added
            "Attachment No. 2" := Attachment."No.";
            MODIFY;
        END ELSE
            ERROR(Text002);
            *///Code is not supported in BC Cloud
    end;


    procedure ImportAttachment3()
    var
        Attachment: Record Attachment;
        AttachmentManagement: Codeunit AttachmentManagement;
    begin
        IF "Attachment No. 3" <> 0 THEN BEGIN
            IF Attachment.GET("Attachment No. 3") THEN
                Attachment.TESTFIELD("Read Only", FALSE);

            IF NOT CONFIRM(Text001, FALSE) THEN
                EXIT
            ELSE
                "Attachment No. 3" := 0;
        END;

        //IF Attachment.ImportAttachment('',FALSE,FALSE) THEN BEGIN // ALLE MM Code Commneted
        /*
        IF Attachment.ImportAttachmentFromClientFile('', FALSE, FALSE) THEN BEGIN // ALLE MM Code Added
            "Attachment No. 3" := Attachment."No.";
            MODIFY;
        END ELSE
            ERROR(Text002);
            *///Code is not supported in BC Cloud
    end;


    procedure RemoveAttachment(Prompt: Boolean)
    var
        Attachment: Record Attachment;
    begin
        IF Attachment.GET("Attachment No.") THEN BEGIN
            // IF Attachment.RemoveAttachment(Prompt) THEN BEGIN
            //     "Attachment No." := 0;
            //     MODIFY;
            // END;//Code is not supported in BC Cloud
        END ELSE
            ERROR(Text003);
    end;


    procedure RemoveAttachment2(Prompt: Boolean)
    var
        Attachment: Record Attachment;
    begin
        IF Attachment.GET("Attachment No. 2") THEN BEGIN
            // IF Attachment.RemoveAttachment(Prompt) THEN BEGIN
            //     "Attachment No. 2" := 0;
            //     MODIFY;
            // END;//Code is not supported in BC Cloud
        END ELSE
            ERROR(Text003);
    end;


    procedure RemoveAttachment3(Prompt: Boolean)
    var
        Attachment: Record Attachment;
    begin
        IF Attachment.GET("Attachment No. 3") THEN BEGIN
            // IF Attachment.RemoveAttachment(Prompt) THEN BEGIN
            //     "Attachment No. 3" := 0;
            //     MODIFY;
            // END;//Code is not supported in BC Cloud
        END ELSE
            ERROR(Text003);
    end;


    procedure OpenAttachment()
    var
        Attachment: Record Attachment;
    begin
        IF "Attachment No." = 0 THEN
            ERROR(Text003);
        Attachment.GET("Attachment No.");
        Attachment.OpenAttachment('VSID' + ' ' + FORMAT(Attachment."No."), FALSE, '');
    end;


    procedure OpenAttachment2()
    var
        Attachment: Record Attachment;
    begin
        IF "Attachment No. 2" = 0 THEN
            ERROR(Text003);
        Attachment.GET("Attachment No. 2");
        Attachment.OpenAttachment('VSID' + ' ' + FORMAT(Attachment."No."), FALSE, '');
    end;


    procedure OpenAttachment3()
    var
        Attachment: Record Attachment;
    begin
        IF "Attachment No. 3" = 0 THEN
            ERROR(Text003);
        Attachment.GET("Attachment No. 3");
        Attachment.OpenAttachment('VSID' + ' ' + FORMAT(Attachment."No."), FALSE, '');
    end;


    procedure GetInterestAmount()
    var
        "No. of days": Integer;
    begin
        TESTFIELD("Interest rate");
        IF Status = Status::Liquidated THEN
            TESTFIELD("Int Rate on Liquidation");
        IF "Int Rate on Liquidation" <> 0 THEN BEGIN
            IF "Actual Closed Date" <> 0D THEN
                "No. of days" := "Actual Closed Date" - "FD Start date"
            ELSE
                "No. of days" := "FD maturity date" - "FD Start date";

            "Intrest Amount" := (("FD Amount" * "Int Rate on Liquidation" / 100) / 365) * "No. of days";
            "Total Maturity Amount" := "FD Amount" + "Intrest Amount";
            MODIFY;
        END ELSE BEGIN
            IF "Actual Closed Date" <> 0D THEN
                "No. of days" := "Actual Closed Date" - "FD Start date"
            ELSE
                "No. of days" := "FD maturity date" - "FD Start date";

            "Intrest Amount" := (("FD Amount" * "Interest rate" / 100) / 365) * "No. of days";
            "Total Maturity Amount" := "FD Amount" + "Intrest Amount";
            MODIFY;
        END;
    end;


    procedure GetTDSAmount()
    begin
        TESTFIELD("Intrest Amount");
        TESTFIELD("TDS Rate");
        "TDS Amount" := ("TDS Rate" * "Intrest Amount") / 100;
        "Total Maturity Amount" := "FD Amount" + "Intrest Amount" - "TDS Amount";
        MODIFY;
    end;
}

