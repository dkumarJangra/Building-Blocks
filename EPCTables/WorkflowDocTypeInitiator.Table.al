table 97878 "Workflow Doc. Type Initiator"
{
    Caption = 'Workflow Document Type Initiator';
    DataCaptionFields = "Transaction Type", "Document Type", "Sub Document Type", "Template Name", "Batch Name", "Initiator User ID", "Responsibility Center";
    DrillDownPageID = "Job Planning Lines1";
    LookupPageID = "Job Planning Lines1";

    fields
    {
        field(1; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            Description = 'PK';
            Editable = true;
            OptionCaption = ' ,Job,Indent,Enquiry,Purchase,Gate Entry,Purchase Receipt,Gate Pass,Sales,Service,Transfer,QC,General Journal,Item Journal,Award Note,Note Sheet';
            OptionMembers = " ",Job,Indent,Enquiry,Purchase,"Gate Entry","Purchase Receipt","Gate Pass",Sales,Service,Transfer,QC,"General Journal","Item Journal","Award Note","Note Sheet";
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Description = 'PK';
            Editable = true;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "Sub Document Type"; Option)
        {
            Caption = 'Sub Document Type';
            Description = 'PK';
            Editable = false;
            OptionCaption = ' ,FA,Regular,Direct,WorkOrder,Inward,Outward,TypeD1,TypeD2,TypeD3,TypeD4,TypeD5,TypeD6,TypeD7,TypeD8,TypeD9,TypeD10,TypeD11,TypeD12,TypeD13,TypeD14,TypeD15,TypeFADS,TypeFADM,TypeD12M,TypeD12S,TypeD8S,TypeD8M,TypeD3S,TypeD3M,TypeC13,TypeC4,TypeC14';
            OptionMembers = " ",FA,Regular,Direct,WorkOrder,Inward,Outward,TypeD1,TypeD2,TypeD3,TypeD4,TypeD5,TypeD6,TypeD7,TypeD8,TypeD9,TypeD10,TypeD11,TypeD12,TypeD13,TypeD14,TypeD15,TypeFADS,TypeFADM,TypeD12M,TypeD12S,TypeD8S,TypeD8M,TypeD3S,TypeD3M,TypeC13,TypeC4,TypeC14;
        }
        field(4; "Template Name"; Code[10])
        {
            Caption = 'Template Name';
            Description = 'PK';
            TableRelation = IF ("Transaction Type" = CONST("General Journal")) "Gen. Journal Template".Name
            ELSE IF ("Transaction Type" = CONST("Item Journal")) "Item Journal Template".Name;

            trigger OnValidate()
            begin
                TESTFIELD("Transaction Type", "Transaction Type"::"General Journal");
                TESTFIELD("Document Type", "Document Type"::Order);
            end;
        }
        field(5; "Batch Name"; Code[10])
        {
            Caption = 'Batch Name';
            Description = 'PK';
            TableRelation = IF ("Transaction Type" = CONST("General Journal")) "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Template Name"))
            ELSE IF ("Transaction Type" = CONST("Item Journal")) "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Template Name"));

            trigger OnValidate()
            begin
                TESTFIELD("Transaction Type", "Transaction Type"::"General Journal");
                TESTFIELD("Document Type", "Document Type"::Order);
            end;
        }
        field(6; "Initiator User ID"; Code[50])
        {
            Caption = 'Initiator User ID';
            Description = 'PK';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                UserMgt.DisplayUserInformation("Initiator User ID");//LookupUserID("Initiator User ID");
                "Responsibility Center" := '';
                IF "Initiator User ID" = '' THEN
                    EXIT;

                UserSetup.GET("Initiator User ID");
                "Responsibility Center" := UserSetup."Responsibility Center";
            end;

            trigger OnValidate()
            begin
                //UserMgt.ValidateUserID("Initiator User ID");
                "Responsibility Center" := '';
                IF "Initiator User ID" = '' THEN
                    EXIT;

                UserSetup.GET("Initiator User ID");
                "Responsibility Center" := UserSetup."Responsibility Center";
            end;
        }
        field(7; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Description = 'PK';
            Editable = true;
            TableRelation = "Responsibility Center 1".Code;

            trigger OnValidate()
            var
                DocTypeApproval: Record "Workflow Doc. Type Approvers";
                DocTypeApproval1: Record "Workflow Doc. Type Approvers";
            begin
            end;
        }
        field(8; Amendment; Boolean)
        {
            Caption = 'Amendment';
            Description = 'PK';

            trigger OnValidate()
            begin
                //IF NOT ("Transaction Type" IN ["Transaction Type"::Job,"Transaction Type"::Purchase,"Transaction Type"::Sales]) THEN //ALLE ANSH
                IF NOT ("Transaction Type" IN ["Transaction Type"::Job, "Transaction Type"::Purchase, "Transaction Type"::Sales, "Transaction Type"::Indent]) THEN //ALLE ANSH
                    FIELDERROR(Amendment);
            end;
        }
        field(9; "Posting User ID"; Code[50])
        {
            Caption = 'Posting User ID';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                UserMgt.DisplayUserInformation("Posting User ID");//LookupUserID("Posting User ID");
                IF "Posting User ID" = '' THEN
                    EXIT;

                UserSetup.GET("Posting User ID");
            end;

            trigger OnValidate()
            begin
                //UserMgt.ValidateUserID("Posting User ID");
                IF "Posting User ID" = '' THEN
                    EXIT;

                UserSetup.GET("Posting User ID");
            end;
        }
        field(10; "Approval Limit Exists"; Decimal)
        {
            CalcFormula = Max("Workflow Doc. Type Approvers"."Approval Amount Limit" WHERE("Transaction Type" = FIELD("Transaction Type"),
                                                                                            "Document Type" = FIELD("Document Type"),
                                                                                            "Sub Document Type" = FIELD("Sub Document Type"),
                                                                                            "Template Name" = FIELD("Template Name"),
                                                                                            "Batch Name" = FIELD("Batch Name"),
                                                                                            "Initiator User ID" = FIELD("Initiator User ID"),
                                                                                            "Responsibility Center" = FIELD("Responsibility Center"),
                                                                                            Amendment = FIELD(Amendment)));
            Caption = 'Approval Limit Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Workflow Code"; Code[20])
        {
            Caption = 'Workflow Code';
            TableRelation = Workflow;
        }
    }

    keys
    {
        key(Key1; "Transaction Type", "Document Type", "Sub Document Type", "Template Name", "Batch Name", "Initiator User ID", "Responsibility Center", Amendment)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        DocApproval: Record "Workflow Doc. Type Approvers";
    begin
        TestEnabled;
        DocApproval.RESET;
        DocApproval.SETRANGE("Transaction Type", "Transaction Type");
        DocApproval.SETRANGE("Document Type", "Document Type");
        DocApproval.SETRANGE("Sub Document Type", "Sub Document Type");
        DocApproval.SETRANGE("Template Name", "Template Name");
        DocApproval.SETRANGE("Batch Name", "Batch Name");
        DocApproval.SETRANGE("Initiator User ID", "Initiator User ID");
        DocApproval.SETRANGE("Responsibility Center", "Responsibility Center");
        DocApproval.SETRANGE(Amendment, Amendment);
        DocApproval.DELETEALL;
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
        User: Record User;
        UserMgt: Codeunit "User Management";
        RespCenter: Record "Responsibility Center";
        Text001: Label 'You cannot rename a %1.';


    procedure GetUserName(UserCode: Code[50]): Text[80]
    begin
        IF UserCode = '' THEN
            EXIT;

        // IF UserMgt.GetUser(UserCode, User) THEN   //200120 open Code
        //     EXIT(User."User Name");                            //200120 open Code
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


    procedure DocApproverExists(): Boolean
    var
        DocApprover: Record "Workflow Doc. Type Approvers";
    begin
        DocApprover.RESET;
        DocApprover.SETRANGE("Transaction Type", "Transaction Type");
        DocApprover.SETRANGE("Document Type", "Document Type");
        DocApprover.SETRANGE("Sub Document Type", "Sub Document Type");
        DocApprover.SETRANGE("Template Name", "Template Name");
        DocApprover.SETRANGE("Batch Name", "Batch Name");
        DocApprover.SETRANGE("Initiator User ID", "Initiator User ID");
        DocApprover.SETRANGE("Responsibility Center", "Responsibility Center");
        DocApprover.SETRANGE(Amendment, Amendment);
        EXIT(NOT DocApprover.ISEMPTY);
    end;
}

