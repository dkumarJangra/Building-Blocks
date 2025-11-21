report 80000 "BBG Table Data Delete Process"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem(AllObjWithCaption; AllObjWithCaption)
        {
            DataItemTableView = where("Object Type" = filter(Table));
            RequestFilterFields = "Object Type", "Object ID", "Object Name";

            trigger OnAfterGetRecord()
            begin
                RecordRef.Copy(AllObjWithCaption);
                RecordRef.DeleteAll();

                //AllObjWithCaption.DeleteAll();
            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                // group(GroupName)
                // {
                //     field(Name; SourceExpression)
                //     {

                //     }
                // }
            }
        }

        actions
        {
            area(processing)
            {
                // action(LayoutName)
                // {

                // }
            }
        }
    }

    trigger OnPostReport()
    Begin
        Message('Table Data has been deleted successfully');
    End;


    var
        myInt: Integer;
        allObj: Record AllObj;

        RecordRef: RecordRef;


}