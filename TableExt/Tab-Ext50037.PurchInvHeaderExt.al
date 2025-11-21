tableextension 50037 "BBG Purch. Inv. Header Ext" extends "Purch. Inv. Header"
{
    fields
    {
        // Add changes to table fields here
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
        }
        field(50010; Initiator; Code[20])
        {
            TableRelation = User;
            DataClassification = ToBeClassified;
            Description = 'JPL';
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
            Description = 'JPL';

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
            Description = 'JPL';
        }
        field(50005; "Approved Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50006; "Starting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50007; "Ending Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50009; "Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            OptionCaption = ' ,WO-ICB,WO-NICB,Regular PO,Repeat PO,Confirmatory PO,Direct PO';
            OptionMembers = " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice";
        }

        field(50013; "Vendor Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Alle VK VSID are added for Report Booking Voucher (ID 50025)--JPL';
        }
        field(50016; "Sent for Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50017; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50018; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50019; "Sent for Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50020; "Sent for Approval Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50021; Amended; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50022; "Amendment Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }


        field(50039; Material; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            OptionCaption = ' ,BLK-Free,BLK-Chargeable,Contractor';
            OptionMembers = " ","BLK-Free","BLK-Chargeable",Contractor;
        }
        field(50040; Consumables; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            OptionCaption = ' ,BLK-Free,BLK-Chargeable,Contractor';
            OptionMembers = " ","JPL-Free","JPL-Chargeable",Contractor;
        }
        field(50041; "Tools and Tackles"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            OptionCaption = ' ,BLK-Free,BLK-Chargeable,Contractor';
            OptionMembers = " ","BLK-Free","BLK-Chargeable",Contractor;
        }
        field(50042; "Order Ref. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Order),
                                                         Approved = FILTER(true),
                                                         "Order Status" = FILTER(' '),
                                                         "Buy-from Vendor No." = FIELD("Buy-from Vendor No."),
                                                         "Responsibility Center" = FIELD("Responsibility Center"));

            trigger OnValidate()
            var
                RecPH: Record "Purchase Header";
                PaymentTermsLine1: Record "Payment Terms Line";
                PaymentTermsLine: Record "Payment Terms Line";
            begin
            end;
        }
        field(50043; "Invoice Received Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'added by dds - 03Dec07';
            Editable = false;
        }


        field(50116; "Land Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG2.0';
            Editable = false;
        }
        field(70023; "Form 59A No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(70024; "Challan Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(90055; "Received Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
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
        field(90083; "Last RA Bill No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLAA';
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
        field(98506; "BizTalk Purchase Invoice"; Boolean)
        {
            Caption = 'BizTalk Purchase Invoice';
            DataClassification = ToBeClassified;
        }
        field(50023; "Amendment Approved Date"; Date)
        {

        }
        field(50024; "Amendment Approved Time"; Time)
        {

        }
        field(50025; "Amendment Initiator"; Code[20])
        {

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