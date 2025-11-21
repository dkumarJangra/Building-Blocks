page 98001 "Customer  Picture"
{
    Caption = 'Employee Picture';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = Customer;
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            field(Picture; Rec.Image)
            {
            }
        }
    }

    actions
    {
    }

    var
        Text001: Label 'Do you want to replace the existing picture of %1 %2?';
        Text002: Label 'Do you want to delete the picture of %1 %2?';
        PictureExists: Boolean;
        EmployeeL: Record Employee;
}

