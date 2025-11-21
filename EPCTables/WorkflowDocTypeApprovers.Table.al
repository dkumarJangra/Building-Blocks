table 97879 "Workflow Doc. Type Approvers"
{
    Caption = 'Workflow Document Type Approvers';
    DrillDownPageID = "New Voucher Accounts";
    LookupPageID = "New Voucher Accounts";

    fields
    {
        field(1; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            Description = 'PK';
            OptionCaption = ' ,Job,Indent,Enquiry,Purchase,Gate Entry,Purchase Receipt,Gate Pass,Sales,Service,Transfer,QC,General Journal,Item Journal,Award Note,Note Sheet';
            OptionMembers = " ",Job,Indent,Enquiry,Purchase,"Gate Entry","Purchase Receipt","Gate Pass",Sales,Service,Transfer,QC,"General Journal","Item Journal","Award Note","Note Sheet";
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Description = 'PK';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "Sub Document Type"; Option)
        {
            Caption = 'Sub Document Type';
            Description = 'PK';
            OptionCaption = ' ,FA,Regular,Direct,WorkOrder,Inward,Outward,TypeD1,TypeD2,TypeD3,TypeD4,TypeD5,TypeD6,TypeD7,TypeD8,TypeD9,TypeD10,TypeD11,TypeD12,TypeD13,TypeD14,TypeD15,TypeFADS,TypeFADM,TypeD12M,TypeD12S,TypeD8S,TypeD8M,TypeD3S,TypeD3M,TypeC13,TypeC4,,TypeC14';
            OptionMembers = " ",FA,Regular,Direct,WorkOrder,Inward,Outward,TypeD1,TypeD2,TypeD3,TypeD4,TypeD5,TypeD6,TypeD7,TypeD8,TypeD9,TypeD10,TypeD11,TypeD12,TypeD13,TypeD14,TypeD15,TypeFADS,TypeFADM,TypeD12M,TypeD12S,TypeD8S,TypeD8M,TypeD3S,TypeD3M,TypeC13,TypeC4,TypeC14;
        }
        field(4; "Template Name"; Code[10])
        {
            Caption = 'Template Name';
            Description = 'PK';
            TableRelation = IF ("Transaction Type" = CONST("General Journal")) "Gen. Journal Template".Name
            ELSE IF ("Transaction Type" = CONST("Item Journal")) "Item Journal Template".Name;
        }
        field(5; "Batch Name"; Code[10])
        {
            Caption = 'Batch Name';
            Description = 'PK';
            TableRelation = IF ("Transaction Type" = CONST("General Journal")) "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Template Name"))
            ELSE IF ("Transaction Type" = CONST("Item Journal")) "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Template Name"));
        }
        field(6; "Initiator User ID"; Code[50])
        {
            Caption = 'Initiator User ID';
            Description = 'PK';

            trigger OnLookup()
            begin
                UserMgt.DisplayUserInformation("Initiator User ID");//LookupUserID("Initiator User ID");
                IF "Initiator User ID" = '' THEN
                    EXIT;

                UserSetup.GET("Initiator User ID");
            end;

            trigger OnValidate()
            begin
                //UserMgt.ValidateUserID("Initiator User ID");
                IF "Initiator User ID" = '' THEN
                    EXIT;

                UserSetup.GET("Initiator User ID");
            end;
        }
        field(7; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Description = 'PK';
            TableRelation = "Responsibility Center 1";
        }
        field(8; Amendment; Boolean)
        {
            Caption = 'Amendment';
            Description = 'PK';
        }
        field(9; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Description = 'PK';
        }
        field(10; "Approver ID"; Code[50])
        {
            Caption = 'Approver ID';

            trigger OnLookup()
            begin
                UserMgt.DisplayUserInformation("Approver ID");//LookupUserID("Approver ID");
                IF "Approver ID" = '' THEN
                    EXIT;

                UserSetup.GET("Approver ID");
            end;

            trigger OnValidate()
            begin
                //UserMgt.ValidateUserID("Approver ID");
                IF "Approver ID" = '' THEN
                    EXIT;

                UserSetup.GET("Approver ID");
            end;
        }
        field(11; "Alternate Approver ID"; Code[50])
        {
            Caption = 'Alternate Approver ID';

            trigger OnLookup()
            begin
                UserMgt.DisplayUserInformation("Alternate Approver ID");//LookupUserID("Alternate Approver ID");
                IF "Alternate Approver ID" = '' THEN
                    EXIT;

                UserSetup.GET("Alternate Approver ID");
            end;

            trigger OnValidate()
            begin
                //UserMgt.ValidateUserID("Alternate Approver ID");
                IF "Alternate Approver ID" = '' THEN
                    EXIT;

                UserSetup.GET("Alternate Approver ID");
            end;
        }
        field(12; "Approval Amount Limit"; Decimal)
        {
            Caption = 'Max. Amount Limit';
        }
    }

    keys
    {
        key(Key1; "Transaction Type", "Document Type", "Sub Document Type", "Template Name", "Batch Name", "Initiator User ID", "Responsibility Center", Amendment, "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestEnabled;
    end;

    trigger OnInsert()
    begin
        TestEnabled;
    end;

    trigger OnModify()
    begin
        TestEnabled;
    end;

    trigger OnRename()
    begin
        //ERROR(Text001,TABLECAPTION);
    end;

    var
        UserSetup: Record "User Setup";
        UserMgt: Codeunit "User Management";
        User: Record User;
        RespCenter: Record "Responsibility Center";
        Text001: Label 'You cannot rename a %1.';


    procedure GetUserName(UserCode: Code[50]): Text[80]
    begin
        IF UserCode = '' THEN
            EXIT;

        // IF UserMgt.GetUser(UserCode, User) THEN    //200120 open Code
        //     EXIT(User."User Name");                  //200120 open Code
    end;


    procedure GetRespCenterName(RespCenterCode: Code[20]): Text[50]
    begin
        IF RespCenterCode = '' THEN
            EXIT;

        IF RespCenter.GET(RespCenterCode) THEN
            EXIT(RespCenter.Name);
    end;


    procedure TestEnabled()
    var
        DocTypeSetup: Record "Workflow Doc. Type Setup";
    begin
        DocTypeSetup.GET("Transaction Type", "Document Type", "Sub Document Type");
        DocTypeSetup.TESTFIELD(Enabled, FALSE);
    end;
}

