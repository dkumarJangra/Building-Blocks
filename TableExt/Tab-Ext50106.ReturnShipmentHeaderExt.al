tableextension 50106 "BBG Return Shipment Header Ext" extends "Return Shipment Header"
{
    fields
    {
        // Add changes to table fields here
        field(50009; "Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
            OptionCaption = ' ,WO-ICB,WO-NICB,Regular PO,Repeat PO,Confirmatory PO,Direct PO';
            OptionMembers = " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice";
        }
        field(50013; "Vendor Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Alle VK VSID are added for Report Booking Voucher (ID 50025)';
        }
        field(50015; "Delivery Remarks"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Alle PS Added Field to store the Delivery Remarks';
        }
        field(50056; "Discount %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(50057; "Discount Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50058; "Discount Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50202; "Budget Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL03';
            TableRelation = "G/L Budget Name".Name;

            trigger OnLookup()
            var
                GLBudgetName: Record "G/L Budget Name";
            begin
            end;

            trigger OnValidate()
            var
                PurchLineRec: Record "Purchase Line";
            begin
            end;
        }
        field(70021; "Gate Entry No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
            TableRelation = "Gate Entry Header"."No." WHERE("Entry Type" = FILTER(Inward),
                                                           Status = FILTER(Close));
        }
        field(70022; "Gate Entry Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
            Editable = false;
        }
        field(70023; "Form 59A No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(70024; "Challan Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(70025; "Mode of Transport"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
            OptionMembers = Road,Rail;
        }
        field(70026; "Vehicle No1."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(70027; "UnPosted GRN No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
            TableRelation = "GRN Header"."GRN No." WHERE("Document Type" = FILTER(GRN));
        }
        field(70029; "Excise Extra"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(70030; "Provisional Bill"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(70031; "Service Tax- Freight Extra"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(70032; "Service Tax- Intall Comm Extra"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(70034; "Octroi /Entry Tax Extra"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(70035; "Freight Extra"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(70036; "Installation Extra"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(70048; "Sales Tax Extra"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(90051; "Last Stage Completed"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 to link PO with Payment Stages';
            TableRelation = "Payment Terms Line"."Milestone Code";
            ValidateTableRelation = false;
        }
        field(90054; "Order Ref. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Order));
        }
        field(90055; "Received Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(90056; "Vendor Quotation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(90057; "Default GL Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
            TableRelation = "G/L Account";
        }
        field(90059; "Adjust Freight SrvTax Agst Adv"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(90060; "Adjust Install SrvTax Agst Adv"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(90087; "Billing Location"; Code[10])
        {
            Caption = 'Billing Location';
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
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