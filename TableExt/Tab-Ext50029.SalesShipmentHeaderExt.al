tableextension 50029 "BBG Sales Shipment Header Ext" extends "Sales Shipment Header"
{
    fields
    {
        // Add changes to table fields here
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
        }
        field(98509; "Date Sent"; Date)
        {
            Caption = 'Date Sent';
            DataClassification = ToBeClassified;
        }
        field(98510; "Time Sent"; Time)
        {
            Caption = 'Time Sent';
            DataClassification = ToBeClassified;
        }
        field(98515; "BizTalk Shipment Notification"; Boolean)
        {
            Caption = 'BizTalk Shipment Notification';
            DataClassification = ToBeClassified;
        }
        field(98519; "Customer Order No."; Code[20])
        {
            Caption = 'Customer Order No.';
            DataClassification = ToBeClassified;
        }
        field(98521; "BizTalk Document Sent"; Boolean)
        {
            Caption = 'BizTalk Document Sent';
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