table 60810 "Power Automat Path Details"
{
    // version NAVW19.00.00.52055,NAVIN9.00.00.52055,TDS-REGEF-194Q

    Caption = 'Power Automat Path Details';
    DataCaptionFields = "Folder Name", Path;
    DataPerCompany = false;

    fields
    {

        field(1; "Folder Name"; Option)
        {
            Caption = 'Folder Name';
            OptionCaption = 'Audit File,DocPostOther,Document Attchment,Project Documents,Document Jagriti';
            OptionMembers = "Audit File",DocPostOther,"Document Attchment","Project Documents","Document Jagriti";

        }
        field(2; Path; Text[250])
        {
            Caption = 'Path';

        }



    }

    keys
    {
        key(Key1; "Folder Name")
        {
        }


    }



}

