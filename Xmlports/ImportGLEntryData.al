xmlport 80000 "BBG Import GL Entry Data"
{
    Direction = Import;
    //Encoding = UTF8;
    Format = VariableText;
    TextEncoding = UTF8;

    schema
    {
        textelement(NodeName1)
        {
            tableelement(BBGUpdateGLEntry; "BBG Update GL Entry")
            {
                fieldattribute(Entry_No; BBGUpdateGLEntry."Entry No.")
                {

                }
                fieldattribute(GL_Account_No; BBGUpdateGLEntry."G/L Account No.")
                {

                }
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {

                    // }
                }
            }
        }

        actions
        {
            // area(processing)
            // {
            //     action(ActionName)
            //     {

            //     }
            // }
        }
    }

    var
        myInt: Integer;
}