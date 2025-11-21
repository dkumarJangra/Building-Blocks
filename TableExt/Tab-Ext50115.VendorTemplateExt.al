tableextension 50115 "BBG Vendor Template Ext" extends "Vendor Templ."
{
    fields
    {
        // Add changes to table fields here
        field(50012; "BBG Vendor Category"; Option)
        {
            Caption = 'Vendor Category';
            DataClassification = ToBeClassified;
            Description = '--JPL';
            OptionCaption = ' ,Supplier,Consultant,Sub-Contractor,Transporter,Other Vendor,IBA(Associates),Land Owners,Contractor,Land Vendor,CP(Channel Partner)';
            OptionMembers = " ",Supplier,Consultant,"Sub-Contractor",Transporter,"Other Vendor","IBA(Associates)","Land Owners",Contractor,"Land Vendor","CP(Channel Partner)";
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