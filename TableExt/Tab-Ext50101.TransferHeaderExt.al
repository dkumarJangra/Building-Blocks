tableextension 50101 "BBG Transfer Header Ext" extends "Transfer Header"
{
    fields
    {
        // Add changes to table fields here
        modify("Transfer-to Code")
        {
            trigger OnAfterValidate()
            begin
                VALIDATE("Shortcut Dimension 1 Code");
                //alleab
                //RAHEE1.00
                IF "Transfer-to Code" <> '' THEN BEGIN
                    RespCenter.RESET;
                    IF RespCenter.GET("Shortcut Dimension 1 Code") THEN BEGIN
                        IF "Transfer-to Code" = RespCenter."Subcon/Site Location" THEN BEGIN
                            DocInitiator.GET(DocSetup."Document Type"::"Transfer Order", "Sub Document Type", Initiator, "Shortcut Dimension 1 Code");
                            DocApproval.RESET;
                            DocApproval.SETRANGE("Document Type", DocSetup."Document Type"::"Transfer Order");
                            DocApproval.SETRANGE("Sub Document Type", "Sub Document Type");
                            DocApproval.SETFILTER("Document No", '%1', '');
                            DocApproval.SETRANGE(Initiator, Initiator);
                            DocApproval.SETRANGE(DocApproval."Approvar ID", '<>%1', '');
                            DocApproval.SETRANGE(DocApproval."Key Responsibility Center", "Shortcut Dimension 1 Code");
                            IF DocApproval.FIND('-') THEN
                                REPEAT
                                    DocumentApproval.INIT;
                                    DocumentApproval.COPY(DocApproval);
                                    DocumentApproval."Document No" := "No.";
                                    DocumentApproval.INSERT;
                                UNTIL DocApproval.NEXT = 0;
                        END ELSE BEGIN
                            DocInitiator.GET(DocSetup."Document Type"::"Transfer Order", "Sub Document Type", Initiator, "Transfer-to Code");
                            DocApproval.RESET;
                            DocApproval.SETRANGE("Document Type", DocSetup."Document Type"::"Transfer Order");
                            DocApproval.SETRANGE("Sub Document Type", "Sub Document Type");
                            DocApproval.SETFILTER("Document No", '%1', '');
                            DocApproval.SETRANGE(Initiator, Initiator);
                            //DocApproval.SETRANGE(DocApproval."Approvar ID",'<>%1','');
                            DocApproval.SETRANGE(DocApproval."Key Responsibility Center", "Transfer-to Code");
                            IF DocApproval.FIND('-') THEN
                                REPEAT
                                    DocumentApproval.INIT;
                                    DocumentApproval.COPY(DocApproval);
                                    DocumentApproval."Document No" := "No.";
                                    DocumentApproval.INSERT;
                                UNTIL DocApproval.NEXT = 0;
                            //alleab

                        END;
                    END;
                END;
                //RAHEE1.00
            end;
        }







        field(50023; "Amendment Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50024; "Amendment Approved Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }

        field(50026; "Location code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE-PKS13';
            TableRelation = Location;
        }

        field(50028; "Cost Centre Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE-PKS13';
        }




        field(50131; "Transfer FG"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';
            Editable = false;
        }
        field(50132; "BBG Status"; Option)
        {
            Caption = 'Order Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval';
            OptionMembers = Open,Released,"Pending Approval";

            trigger OnValidate()
            begin
                UpdateTransLines(Rec, FieldNo(Status));
            end;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        RecUserSetup: Record "User Setup";
        RecRespCenter: Record "Responsibility Center 1";
        DocSetup: Record "Document Type Setup";
        DocInitiator: Record "Document Type Initiator";
        DocApproval: Record "Document Type Approval";
        DocumentApproval: Record "Document Type Approval";
        DimValue: Record "Dimension Value";
        TranslineRec: Record "Transfer Line";
        UserMgt: Codeunit "EPC User Setup Management";
        purchheader: Record "Purchase Header";
        PRLine: Record "Transfer Line";
        TransferRoute1: Record "Transfer Route";
        RespCenter: Record "Responsibility Center 1";
        PHdr: Record "Purchase Header";
        PHdrForm: Page "Purchase List";
        Resp: Record "Responsibility Center 1";


    trigger OnAfterInsert()
    begin
        //ALLEAB FOr Transfer order to link with Approval Mgmt
        Initiator := USERID;

        RecUserSetup.RESET;
        RecUserSetup.SETRANGE("User ID", Initiator);
        RecUserSetup.FIND('-');

        DocSetup.GET(DocSetup."Document Type"::"Transfer Order", "Sub Document Type");
        DocSetup.RESET;
        DocSetup.SETRANGE("Document Type", DocSetup."Document Type"::"Transfer Order");

        IF "Sub Document Type" = "Sub Document Type"::"Direct TO" THEN
            DocSetup.SETRANGE("Sub Document Type", "Sub Document Type"::"Direct TO");
        IF "Sub Document Type" = "Sub Document Type"::"Regular TO" THEN
            DocSetup.SETRANGE("Sub Document Type", "Sub Document Type"::"Regular TO");
        DocSetup.SETRANGE("Approval Required", TRUE);
        IF DocSetup.FIND('-') THEN BEGIN
            DocInitiator.GET(DocSetup."Document Type"::"Transfer Order", "Sub Document Type", Initiator, RecUserSetup."Purchase Resp. Ctr. Filter");
        END;
        DocSetup.SETRANGE("Approval Required");
        //AllE-PKS13
        RecUserSetup.RESET;
        RecUserSetup.SETRANGE("User ID", Initiator);
        IF RecUserSetup.FIND('-') THEN BEGIN
            "Responsibility Center" := RecUserSetup."Purchase Resp. Ctr. Filter";
            RecRespCenter.RESET;
            RecRespCenter.SETRANGE(Code, RecUserSetup."Purchase Resp. Ctr. Filter");
            IF RecRespCenter.FIND('-') THEN BEGIN
                "Shortcut Dimension 1 Code" := RecRespCenter."Global Dimension 1 Code";
                "Location code" := RecRespCenter."Location Code";
                "Transfer-from Code" := RecRespCenter."Location Code";
                "Transfer-from Name" := RecRespCenter."Location Name";
                // ALLEAA
                // IF LocLocation.GET(RecRespCenter."Location Code") THEN
                //     "Excise Bus. Posting Group" := LocLocation."Excise Bus. Posting Group";
                // ALLEAA
            END;
        END;
        //AllE-PKS13
    end;


}