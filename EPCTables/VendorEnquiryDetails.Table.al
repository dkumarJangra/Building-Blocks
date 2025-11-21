table 97741 "Vendor Enquiry Details"
{
    // ALLERP VSID 09-02-07:Added property Table Relation for indent No. and added function fillRFQlines
    // ALLERP KRN0014 18-08-2010: Option sent added in status field
    // ALLERP BugFix  22-11-2010: Remove the option caption 'others' of Pr type

    DrillDownPageID = "Enquiry List";
    LookupPageID = "Enquiry List";

    fields
    {
        field(1; "Package No."; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('PACKAGES'));
        }
        field(2; "Package Name"; Text[100])
        {
        }
        field(3; "Project Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                /*IF DimensionValue.GET('PROJECT',"Project Code") THEN
                  IF (DimensionValue."Dimension Value Type" <> DimensionValue."Dimension Value Type"::Standard) THEN
                       ERROR('Dimension Value Types as STANDARD can only be selected');
                IF DimensionValue.GET('PROJECT/COST CENTRE',"Project Code")THEN
                     "Project Name" := DimensionValue.Name
                   ELSE
                     "Project Name" := ''
                 */
                ValidateShortcutDimCode(1, "Project Code");
                MODIFY;

            end;
        }
        field(4; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF Vendor.GET("Vendor No.") THEN BEGIN
                    "Vendor Name" := Vendor.Name;
                    "Vendor Name 2" := Vendor."Name 2";
                    "Vendor Address" := Vendor.Address;  //Alle Ven 29/09/08
                    "Vendor City" := Vendor.City + '/' + Vendor."Post Code";  //Alle Ven 29/09/08
                END ELSE BEGIN
                    "Vendor Name" := '';
                    "Vendor Name 2" := '';
                END
            end;
        }
        field(5; "Vendor Name"; Text[60])
        {
            Editable = false;
        }
        field(6; "Project Name"; Code[50])
        {
        }
        field(7; "Enquiry no."; Code[20])
        {
            Editable = true;
        }
        field(8; "Date of Floating enquiry"; Date)
        {
        }
        field(9; "Technical doc recd from"; Text[100])
        {
        }
        field(10; "Response Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('RESPONSE'));
        }
        field(11; "Offer No."; Code[30])
        {
        }
        field(12; "Offer Date"; Date)
        {
        }
        field(13; "Offer Document Avail."; Integer)
        {
        }
        field(14; Remarks; Text[250])
        {
        }
        field(15; "Actual Order Placed"; Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(16; "OTO / OTC"; Option)
        {
            OptionCaption = ' ,Opportunity to Order,Order to Cash';
            OptionMembers = " ",OTO,OTC;
        }
        field(17; "Date Of Recpt of Tech Spec"; Date)
        {
        }
        field(18; "Indent No."; Code[20])
        {
            TableRelation = "Purchase Request Header"."Document No.";
        }
        field(19; "Requested Date of Offer"; Date)
        {
        }
        field(20; "Status As On"; Date)
        {
        }
        field(21; "Expected Date of Offer"; Date)
        {
        }
        field(22; "Last Contact Date"; Date)
        {
        }
        field(23; "Vendor Order Address"; Code[20])
        {
            TableRelation = "Order Address".Code WHERE("Vendor No." = FIELD("Vendor No."));

            trigger OnValidate()
            begin
                IF OrderAddress.GET("Vendor No.", "Vendor Order Address") THEN BEGIN
                    "Vendor Name" := OrderAddress.Name;
                    "Vendor Name 2" := OrderAddress."Name 2"
                END
                ELSE BEGIN
                    "Vendor Name" := '';
                    "Vendor Name 2" := '';
                END
            end;
        }
        field(24; "Package Description"; Text[250])
        {
        }
        field(25; Price; Decimal)
        {
        }
        field(26; "Price Description"; Text[250])
        {
        }
        field(27; "Enquiry Date"; Date)
        {
        }
        field(50001; Status; Option)
        {
            Caption = 'Status';
            Description = 'AlleDK NTPC';
            OptionCaption = 'Open,Close,Cancel,Sent';
            OptionMembers = Open,Close,Cancel,Sent;
        }
        field(50002; Category; Code[20])
        {
            Description = 'AlleDK NTPC';
            TableRelation = "Sub Sub Category".Code;

            trigger OnValidate()
            begin
                /*IF Category1.GET(Category) THEN
                  "Category Name" := Category1."Document Type";
                 */

            end;
        }
        field(50003; "Category Name"; Text[30])
        {
            Description = 'AlleDK NTPC';
        }
        field(50004; Required; Boolean)
        {
            Description = 'AlleDK NTPC';
        }
        field(50005; ABC; Code[20])
        {
            Description = 'AlleDK NTPC';
            TableRelation = "Purchase Request Header"."Document No.";
        }
        field(50006; "Vendor Address"; Text[50])
        {
            Description = 'AlleDK NTPC';
        }
        field(50007; "Vendor City"; Text[30])
        {
            Description = 'AlleDK NTPC';
        }
        field(50008; "Job Code"; Code[20])
        {
            Description = 'Alle Ven';
            TableRelation = Job."No.";

            trigger OnValidate()
            begin
                IF Job.GET("Job Code") THEN
                    "Package Name" := Job.Description;
            end;
        }
        field(50009; "Job Task"; Code[20])
        {
            Description = 'Alle Ven';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job Code"));

            trigger OnValidate()
            begin
                IF JobTask.GET("Job Code", "Job Task") THEN
                    "Job Task Name" := JobTask.Description
                ELSE
                    "Job Task Name" := '';
            end;
        }
        field(50010; "Job Task Name"; Text[50])
        {
        }
        field(50011; "Pr Type"; Option)
        {
            OptionCaption = 'Supply,Services';
            OptionMembers = Supply,Services,"Others ";
        }
        field(50012; Location; Code[20])
        {
            TableRelation = Location;

            trigger OnValidate()
            begin
                IF Loc.GET(Location) THEN
                    "Location Name" := Loc.Name;
            end;
        }
        field(50013; "Document Date"; Date)
        {
        }
        field(50014; "Location Name"; Text[30])
        {
            Editable = false;
        }
        field(50015; Initiator; Code[20])
        {
            Description = 'ALLEAA';
            Editable = false;
        }
        field(50016; "Vendor Name 2"; Text[60])
        {
        }
        field(50017; "Tax Rate"; Decimal)
        {
            Description = 'RAHEE1.00';
        }
    }

    keys
    {
        key(Key1; "Enquiry no.")
        {
            Clustered = true;
        }
        key(Key2; "Project Code", "Package No.", "Vendor No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //IF ("Package No." = '') OR ("Vendor No." = '') THEN
        // ERROR('It is Mandatory to fill Package No. and Vendor No. before generating an ENQUIRY No.');

        //IF CONFIRM('Are you sure you want to generate an ENQUIRY number') THEN BEGIN
        //  PurchSetup.GET();
        //  "Enquiry no.":=NoSeriesMgt.GetNextNo(PurchSetup."Enquiry No. Series",0D,TRUE);
        //END ELSE ERROR('Operation cancelled by the user');
        "Enquiry Date" := WORKDATE;
        Initiator := USERID;  //ALLEAA
    end;

    var
        Vendor: Record Vendor;
        DimensionValue: Record "Dimension Value";
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TextAttachment: Label 'Do You want to Replace the Attachment ?';
        Text0002: Label 'The attachment is empty.';
        OrderAddress: Record "Order Address";
        EntryNo: Integer;
        PRHeader: Record "Purchase Request Header";
        Job: Record Job;
        JobTask: Record "Job Task";
        Loc: Record Location;
        DimMgt: Codeunit DimensionManagement;


    procedure "---Alle---"()
    begin
    end;


    procedure OpenAttachment()
    var
        Attachment: Record Attachment;
    begin
        //JOB No. VSID 0008

        IF "Offer Document Avail." = 0 THEN
            EXIT;
        Attachment.GET("Offer Document Avail.");
        Attachment.OpenAttachment('VSID' + ' ' + FORMAT(Attachment."No."), FALSE, '');
    end;


    procedure ImportAttachment()
    var
        Attachment: Record Attachment;
        AttachmentManagement: Codeunit AttachmentManagement;
    begin
        //JOB No. VSID 0008

        IF "Offer Document Avail." <> 0 THEN BEGIN
            IF Attachment.GET("Offer Document Avail.") THEN
                Attachment.TESTFIELD("Read Only", FALSE);
            IF NOT CONFIRM(TextAttachment, FALSE) THEN
                EXIT;
        END;

        //IF Attachment.ImportAttachment('',FALSE,FALSE) THEN BEGIN
        // IF Attachment.ImportAttachmentFromClientFile('', FALSE, FALSE) THEN BEGIN
        //     "Offer Document Avail." := Attachment."No.";
        //     MODIFY;
        // END ELSE
        //     ERROR(Text0002);
    end;


    procedure ExportAttachment()
    var
        Attachment: Record Attachment;
        Filename: Text[80];
    begin
        //JOB No. VSID 0008

        // IF Attachment.GET("Offer Document Avail.") THEN
        //     //Attachment.ExportAttachment(Filename);
        //     Attachment.ExportAttachmentToClientFile(Filename)
    end;


    procedure RemoveAttachment(Prompt: Boolean)
    var
        Attachment: Record Attachment;
    begin
        //JOB No. VSID 0008

        // IF Attachment.GET("Offer Document Avail.") THEN
        //     IF Attachment.RemoveAttachment(Prompt) THEN BEGIN
        //         "Offer Document Avail." := 0;
        //         MODIFY;
        //     END;
    end;


    procedure FillRFQLines(var RecDocumentLine11: Record "Purchase Request Line"; var RecVendorEnquiryDetails: Record "Vendor Enquiry Details")
    begin
        /*EntryNo := 0;
        IF RecDocumentLine11.FIND('-') THEN BEGIN
          REPEAT
            IF NOT RecRFQLines1.GET(RecVendorEnquiryDetails."Vendor No.",RecVendorEnquiryDetails."Indent No.",
              RecDocumentLine11."Shortcut Dimension 1 Code",RecDocumentLine11."No.",RecDocumentLine11."Line No.") THEN BEGIN
              EntryNo := EntryNo + 10000;
              RecRFQLines1.INIT;
              RecRFQLines1.Code := EntryNo;
              RecRFQLines1."Vendor Code" := RecVendorEnquiryDetails."Vendor No.";
              RecRFQLines1."Indent No." :=  RecVendorEnquiryDetails."Indent No.";
              RecRFQLines1."Project Code" := RecDocumentLine11."Shortcut Dimension 1 Code";
              RecRFQLines1."Rate/Sq. Ft" := RecDocumentLine11."No.";
              RecRFQLines1."Line No." := RecDocumentLine11."Line No.";
              RecRFQLines1."Document Type" := RecVendorEnquiryDetails."Enquiry no.";
              RecRFQLines1.Description := TODAY;
              RecRFQLines1."Fixed Price" := RecDocumentLine11."Indented Quantity";
              RecRFQLines1."BP Dependency" := RecDocumentLine11."Required By Date";
              RecRFQLines1."Rate Not Allowed" := RecDocumentLine11.Description;
              RecRFQLines1."Project Price Dependency Code" := RecDocumentLine11."Avg Consumption";
              RecRFQLines1."Sale/Lease" := RecDocumentLine11."Unit Of Measure";
              RecRFQLines1."Unit Price" := RecDocumentLine11."Item Category Code";
              RecRFQLines1."Line Amount" := RecDocumentLine11."Product Group Code";
              RecRFQLines1."Vedor Name" := RecDocumentLine11."Description 2";
              RecRFQLines1."Vendor Adress" := RecDocumentLine11."Location code";
              RecRFQLines1."Package No." :=  RecVendorEnquiryDetails."Package No.";
              RecRFQLines1."Package Name" := RecVendorEnquiryDetails."Package Name";
              RecRFQLines1.INSERT;
            END
          UNTIL RecDocumentLine11.NEXT = 0;
        END;
         */

    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        ChangeLogMgt: Codeunit "Change Log Management";
        RecRef: RecordRef;
        xRecRef: RecordRef;
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        // ALLE MM Code Commented
        /*
        IF "Enquiry no." <> '' THEN BEGIN
          DimMgt.SaveDocDim(
            DATABASE::"Vendor Enquiry Details",0,"Enquiry no.",0,FieldNumber,ShortcutDimCode);
          xRecRef.GETTABLE(xRec);
          MODIFY;
          RecRef.GETTABLE(Rec);
          ChangeLogMgt.LogModification(RecRef,xRecRef);
        END ELSE
          DimMgt.SaveTempDim(FieldNumber,ShortcutDimCode);
        */
        // ALLE MM Code Commented

    end;
}

