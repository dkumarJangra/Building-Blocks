tableextension 50087 "BBG Wf. User Group Member Ext" extends "Workflow User Group Member"
{
    fields
    {
        // Add changes to table fields here

        field(50001; "Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,FA,Regular,Direct,WorkOrder,Inward,Outward,TypeD1,TypeD2,TypeD3,TypeD4,TypeD5,TypeD6,TypeD7,TypeD8,TypeD9,TypeD10,TypeD11,TypeD12,TypeD13,TypeD14,TypeD15,TypeFADS,TypeFADM,TypeD12M,TypeD12S,TypeD8S,TypeD8M,TypeD3S,TypeD3M,TypeC13,TypeC4,TypeC14';
            OptionMembers = " ",FA,Regular,Direct,WorkOrder,Inward,Outward,TypeD1,TypeD2,TypeD3,TypeD4,TypeD5,TypeD6,TypeD7,TypeD8,TypeD9,TypeD10,TypeD11,TypeD12,TypeD13,TypeD14,TypeD15,TypeFADS,TypeFADM,TypeD12M,TypeD12S,TypeD8S,TypeD8M,TypeD3S,TypeD3M,TypeC13,TypeC4,TypeC14;
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