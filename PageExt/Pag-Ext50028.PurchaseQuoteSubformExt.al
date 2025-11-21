pageextension 50028 "BBG Purchase Quote Subform Ext" extends "Purchase Quote Subform"
{
    layout
    {
        // Add changes to page layout here
    }
    actions

    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;

    PROCEDURE GetIndentLineInfo()
    BEGIN
        Rec.GetIndentForQuots; //ALLESP BCL0001 04-07-2007
    END;

    PROCEDURE ShowLineComments()
    BEGIN
        Rec.ShowLineComments;
    END;

    PROCEDURE OpenMaterialFrm()
    BEGIN
        Rec.OpenMaterialForm; //ALLESP BCL0003 14-08-2007
    END;
}