table 97748 Terms
{
    //DrillDownPageID = 99999;
    //LookupPageID = 99999;

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Jobs;
        }
        field(2; "Document No."; Code[30])
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Term Type"; Option)
        {
            OptionCaption = ',Sales Tax,Excise Duty,Payment,Service Tax,Insurance,Inspection Authority,Packaging & Forwarding,Price Basis,Freight,DD Comm/Bank Charges,Warranty/Guarantee Certificate,Entry Tax/Octroi Tax,Installation Terms,Service Tax-Installation,Template-1,Template-2,Template-3,Template-4,Instructions,F.O.R,VAT,Inspection Charges,Delivery,Site Verification,Contract / LOI,Scope of the Contract,Mobilization,Other Adv,Penalty Clause,Item Details,QAP,WPSS,Inspection Agency,Theoretical Material,Statutory Regulatory Req.,Manpower Requirement,Organization Chart,Contract Closure Condition,Defect Liability period,Tender Conditions,Deposits,Retention,BG,Delivery Mode,Customs/Other Duty,Similar Project,Drawing Status';
            OptionMembers = ,"Sales Tax","Excise Duty",Payment,"Service Tax",Insurance,"Inspection Authority","Packaging & Forwarding","Price Basis",Freight,"DD Comm/Bank Charges","Warranty/Guarantee Certificate","Entry Tax/Octroi Tax","Installation Terms","Service Tax-Installation","Template-1","Template-2","Template-3","Template-4",Instructions,"F.O.R",VAT,"Inspection Charges",Delivery,"Site Verification","Contract / LOI","Scope of the Contract",Mobilization,"Other Adv","Penalty Clause","Item Details",QAP,WPSS,"Inspection Agency","Theoretical Material","Statutory Regulatory Req.","Manpower Requirement","Organization Chart","Contract Closure Condition","Defect Liability period","Tender Conditions",Deposits,Retention,BG,"Delivery Mode","Customs/Other Duty","Similar Project","Drawing Status";
        }
        field(5; Narration; Text[130])
        {
            Description = '80';

            trigger OnLookup()
            begin
                st.RESET;
                st.SETRANGE(st."BBG Term Type", "Term Type");
                IF PAGE.RUNMODAL(Page::"Standard Text Codes", st) = ACTION::LookupOK THEN
                    Narration := Narration + ' ' + st.Description;
            end;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Term Type", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        st: Record "Standard Text";
}

