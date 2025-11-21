tableextension 50015 "BBG Purch. Comment line Ext" extends "Purch. Comment Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Terms Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Scope,Price Basis,Terms of Delivery,Packaging & forwarding,Excise Duty,Sales Tax,Freight,Insurance,Payment Terms,Mode of Transport,Inspection,Guarantee,CPBG,Delivery Schedule,Liquidated Damages,Standards,Patent Rights,Notice to Proceed,Documentation for invoicing,Quality Requirement,Test Certificate,Marine Insurance,Packing,Force Majeure,Dispatch Clearance & Inst.,Subletting,Change Order,Contact Amendment,Termination for default,Jurisdiction,Resolution & Desputes,Liability,Deviation,Other Terms,Special Terms & Condition,Order Acceptance,Quantity Variation,Note 1,Note 2,Note 3,Note 4';
            OptionMembers = " ",Scope,"Price Basis","Terms of Delivery","Packaging & forwarding","Excise Duty","Sales Tax",Freight,Insurance,"Payment Terms","Mode of Transport",Inspection,Guarantee,CPBG,"Delivery Schedule","Liquidated Damages",Standards,"Patent Rights","Notice to Proceed","Documentation for invoicing","Quality Requirement","Test Certificate","Marine Insurance",Packing,"Force Majeure","Dispatch Clearance & Inst.",Subletting,"Change Order","Contact Amendment","Termination for default",Jurisdiction,"Resolution & Desputes",Liability,Deviation,"Other Terms","Special Terms & Condition","Order Acceptance","Quantity Variation","Note 1","Note 2","Note 3","Note 4";
        }
        field(50001; "Terms Type for WO"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Scope,Price Basis,Service Tax,Income Tax,Work Contract Tax,Payment Terms,Boarding & Lodging,Travel Charges,Deputation Period,Defect Liability Period,Work Completion Schedule,Performance BG,Liquidated Damage,Subletting,Insurance,Labour Rules & Regulations,Change Order,Contract Amendment,Termination for default ,Force Majeure,Termination for convenience,Resulation of despute,Liability,Safety,Jurisdiction,Deviation,Order Acceptance,Secrecy,Care & Diligence,Indemnity,Arbitration,Other Terms,Special Terms,Note 1,Note 2,Note 3,Note 4,Excise Duty';
            OptionMembers = " ",Scope,"Price Basis","Service Tax","Income Tax","Work Contract Tax","Payment Terms","Boarding & Lodging","Travel Charges","Deputation Period","Defect Liability Period","Work Completion Schedule","Performance BG","Liquidated Damage",Subletting,Insurance,"Labour Rules & Regulations","Change Order","Contract Amendment","Termination for default ","Force Majeure","Termination for convenience","Resulation of despute",Liability,Safety,Jurisdiction,Deviation,"Order Acceptance",Secrecy,"Care & Diligence",Indemnity,Arbitration,"Other Terms","Special Terms","Note 1","Note 2","Note 3","Note 4","Excise Duty";
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