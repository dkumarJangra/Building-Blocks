table 97822 "Portal Login"
{

    fields
    {
        field(1; "Login Type"; Option)
        {
            NotBlank = false;
            OptionMembers = Customer,Vendor,Administrator;
        }
        field(2; UserID; Text[80])
        {
            NotBlank = false;
        }
        field(3; Password; Text[30])
        {
        }
        field(4; "No."; Code[20])
        {
            NotBlank = false;

            trigger OnValidate()
            begin
                //TESTFIELD(UserID);
                //TESTFIELD(Password);
            end;
        }
        field(5; Name; Text[50])
        {
        }
        field(6; EmailID; Text[50])
        {
        }
        field(7; Sex; Option)
        {
            OptionMembers = Male,Female;
        }
        field(8; "Date Of Birth"; Date)
        {
        }
        field(9; Country; Text[50])
        {
            TableRelation = "Country/Region".Code WHERE(Code = FIELD(Country));
        }
        field(10; Language; Option)
        {
            OptionMembers = English,Hindi;
        }
        field(11; "Postal Code"; Code[20])
        {
        }
        field(12; "Mobile No."; Code[10])
        {
        }
        field(13; "P.A.N No."; Code[30])
        {
        }
        field(14; "Security Question"; Option)
        {
            OptionMembers = "What town were you born in?","What town was your father born in?","What is the name of the hospital in which you were born?","What is the first name of your best childhood friend?","What was the name of your primary school?","What town was your mother born in?","What is the name of the first company / organization you worked for?";
        }
        field(15; Answer; Text[50])
        {
        }
        field(16; "Security Question2"; Option)
        {
            OptionMembers = "What was your favourite food as a child?","What is the title of your favourite book?","Who is your favourite author?","Who is your all-time favourite sports personality?","Who is your all-time favourite movie character?","What was your favourite childhood game?","What was your favourite cartoon character as a child?";
        }
        field(17; Answer2; Text[50])
        {
        }
        field(18; "Introducer Code"; Option)
        {
            OptionMembers = DE,"DO",DM,AGM,DGM,GM,DD,SDD,GD,VP,AVP,P,OFF;
        }
        field(19; Approved; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Login Type", UserID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Customer: Record Customer;
}

