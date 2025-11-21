tableextension 50035 "BBG Purch. Recpt. header Ext" extends "Purch. Rcpt. Header"
{
    fields
    {
        // Add changes to table fields here
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
        }
        field(50002; "Order Status"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Field Added to show Order Status as Cancelled, short closed or Completed--JPL';
            Editable = false;
            OptionMembers = " ",Cancelled,"Short Closed",Completed;
        }
        field(50003; Approved; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';

            trigger OnValidate()
            var
                PurchLineRec: Record "Purchase Line";
                DocSetup: Record "Document Type Setup";
            begin
            end;
        }
        field(50004; "Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50005; "Approved Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50006; "Starting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50007; "Ending Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50009; "Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            OptionCaption = ' ,WO-ICB,WO-NICB,Regular PO,Repeat PO,Confirmatory PO,Direct PO';
            OptionMembers = " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice";
        }
        field(50010; Initiator; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = User;
        }
        field(50013; "Vendor Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Alle VK VSID are added for Report Booking Voucher (ID 50025)--JPL';
        }
        field(50016; "Sent for Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50017; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50018; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50019; "Sent for Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50020; "Sent for Approval Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50021; Amended; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50022; "Amendment Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
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
        field(50025; "Amendment Initiator"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50039; Material; Option)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            OptionCaption = ' ,BLK-Free,BLK-Chargeable,Contractor';
            OptionMembers = " ","BLK-Free","BLK-Chargeable",Contractor;
        }
        field(50040; Consumables; Option)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            OptionCaption = ' ,BLK-Free,BLK-Chargeable,Contractor';
            OptionMembers = " ","JPL-Free","JPL-Chargeable",Contractor;
        }
        field(50041; "Tools and Tackles"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            OptionCaption = ' ,BLK-Free,BLK-Chargeable,Contractor';
            OptionMembers = " ","BLK-Free","BLK-Chargeable",Contractor;
        }
        field(50100; "Manufacturer Certificate Req."; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00 140311';
        }
        field(50101; "Third Party Certificate Req."; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00 140311';
        }
        field(50102; "Manufacturer Certificate Recd"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00 140311';
        }
        field(50103; "Third Party Certificate Recd"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00 140311';
        }
        field(50104; "Internal Certificate Req."; Boolean)
        {
            Caption = 'Third Party Certificate Req.';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00 140311';
        }
        field(50105; "Internal Certificate Recd"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00 140311';
        }
        field(50106; "Weight Bill No"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50107; "Cheque No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 081212';
        }
        field(50108; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 081212';
        }
        field(50114; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70023; "Form 59A No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(70024; "Challan Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            Editable = false;
        }
        field(70025; "Mode of Transport"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            OptionMembers = Road,Rail;
        }
        field(70026; "Vehicle No1."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }

        field(70028; "Challan No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--BLK';
            Editable = false;
        }
        field(80000; "Quality Certificate No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB';
        }
        field(90050; "Active Stage"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 to link PO with Payment Stages--JPL';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(90051; "Last Stage Completed"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 to link PO with Payment Stages--JPL';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(90052; "Completed All Stages"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 to link PO with Payment Stages--JPL';
            Editable = false;
        }
        field(90053; "Blanket Order Ref No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 to link PO with Payment Stages--JPL';
        }
        field(90054; "Order Ref. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Order),
                                                         Approved = FILTER(true),
                                                         "Order Status" = FILTER(' '),
                                                         "Buy-from Vendor No." = FIELD("Buy-from Vendor No."));

            trigger OnLookup()
            var
                PurchHdrL: Record "Purchase Header";
            begin
            end;

            trigger OnValidate()
            var
                PaymentTermsLine1: Record "Payment Terms Line";
                PaymentTermsLine: Record "Payment Terms Line";
            begin
            end;
        }
        field(90055; "Received Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(90056; "Vendor Quotation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(90057; "Default GL Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "G/L Account";
        }
        field(90058; "Work Tax Applicable"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(90059; "Adjust Freight SrvTax Agst Adv"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(90060; "Adjust Install SrvTax Agst Adv"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(90062; "Advance Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Posting Type" = FILTER(Advance),
                                                                                  "Order Ref No." = FIELD("No.")));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90063; "Running Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Posting Type" = FILTER(Running),
                                                                                  "Order Ref No." = FIELD("No.")));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90064; "Retention Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Posting Type" = FILTER(Retention),
                                                                                  "Order Ref No." = FIELD("No.")));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90065; "O/S Order Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(90066; "SubCont Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90067; "SubCont End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90068; "Block Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90069; "R.A. Bill No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90070; "Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90071; "Vendor Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90072; "Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90073; "Invoice Posting date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90087; "Billing Location"; Code[10])
        {
            Caption = 'Billing Location';
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(98500; "Date Received"; Date)
        {
            Caption = 'Date Received';
            DataClassification = ToBeClassified;
        }
        field(98501; "Time Received"; Time)
        {
            Caption = 'Time Received';
            DataClassification = ToBeClassified;
        }
        field(98507; "BizTalk Purchase Receipt"; Boolean)
        {
            Caption = 'BizTalk Purchase Receipt';
            DataClassification = ToBeClassified;
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
}