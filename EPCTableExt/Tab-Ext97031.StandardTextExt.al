tableextension 97031 "EPC Standard Text Ext" extends "Standard Text"
{
    fields
    {
        // Add changes to table fields here
        field(50002; "BBG Term Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE-PKS';
            Caption = 'Term Type';
            Editable = true;
            OptionCaption = ',Sales Tax,Excise Duty,Payment,Service Tax,Insurance,Inspection Authority,Packaging & Forwarding,Price Basis,Freight,DD Comm/Bank Charges,Warranty/Guarantee Certificate,Entry Tax/Octroi Tax,Installation Terms,Service Tax-Installation,Template-1,Template-2,Template-3,Template-4,Instructions,F.O.R,VAT,Inspection Charges,Delivery,Site Verification,Contract / LOI,Scope of the Contract,Mobilization,Other Adv,Penalty Clause,Item Details,QAP,WPSS,Inspection Agency,Theoretical Material,Statutory Regulatory Req.,Manpower Requirement,Organization Chart,Contract Closure Condition,Defect Liability period,Tender Conditions,Deposits,Retention,BG,Delivery Mode,Customs/Other Duty,Similar Project,Drawing Status';
            OptionMembers = ,"Sales Tax","Excise Duty",Payment,"Service Tax",Insurance,"Inspection Authority","Packaging & Forwarding","Price Basis",Freight,"DD Comm/Bank Charges","Warranty/Guarantee Certificate","Entry Tax/Octroi Tax","Installation Terms","Service Tax-Installation","Template-1","Template-2","Template-3","Template-4",Instructions,"F.O.R",VAT,"Inspection Charges",Delivery,"Site Verification","Contract / LOI","Scope of the Contract",Mobilization,"Other Adv","Penalty Clause","Item Details",QAP,WPSS,"Inspection Agency","Theoretical Material","Statutory Regulatory Req.","Manpower Requirement","Organization Chart","Contract Closure Condition","Defect Liability period","Tender Conditions",Deposits,Retention,BG,"Delivery Mode","Customs/Other Duty","Similar Project","Drawing Status";
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