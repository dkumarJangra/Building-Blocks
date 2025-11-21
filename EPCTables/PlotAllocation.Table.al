table 97823 "Plot Allocation"
{
    // //BBG1.00 ALLEDK 100313 Change the Primary Key


    fields
    {
        field(1; Plot_ID; Code[50])
        {
        }
        field(2; Plot_Number; Code[50])
        {
            TableRelation = "Unit Master";
        }
        field(3; plotX_Position; Integer)
        {
        }
        field(4; plotY_Position; Integer)
        {
        }
        field(5; Plot_Width; Integer)
        {
        }
        field(6; Plot_Height; Integer)
        {
        }
        field(7; Created_Date; Date)
        {
        }
        field(8; Created_By; Text[50])
        {
        }
        field(9; Status; Boolean)
        {
        }
        field(10; ProjectID; Code[30])
        {
            TableRelation = "Responsibility Center 1";
        }
        field(11; Updated_Date; Date)
        {
        }
        field(12; Updated_By; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; Plot_ID, Plot_Number, ProjectID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

