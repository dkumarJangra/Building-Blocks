report 80001 "BBG Delete Tax Rate"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Tax Rate"; "Tax Rate")
        {
            trigger OnAfterGetRecord()
            begin
                Delete();
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
        Message('Done');
    End;

    var
        myInt: Integer;
}