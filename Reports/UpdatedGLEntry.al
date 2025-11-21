report 80011 "BBG Update GL Entry"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "G/L Entry" = M;

    dataset
    {
        dataitem("BBG Update GL Entry"; "BBG Update GL Entry")
        {
            trigger OnAfterGetRecord()
            begin
                GLEntry.Reset();
                GLEntry.SetRange("Entry No.", "BBG Update GL Entry"."Entry No.");
                IF GLEntry.FindFirst() Then begin
                    GLEntry."G/L Account No." := "BBG Update GL Entry"."G/L Account No.";
                    GLEntry.Modify();
                end;
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
            // area(processing)
            // {
            //     action(LayoutName)
            //     {

            //     }
            // }
        }
    }


    var
        myInt: Integer;
        GLEntry: Record "G/L Entry";
}