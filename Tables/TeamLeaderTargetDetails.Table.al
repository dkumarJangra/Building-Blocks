table 60768 "Team / Leader Target Details"
{

    fields
    {
        field(1; "Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(Team)) "Team Master"."Team Code"
            ELSE
            IF (Type = CONST(Leader)) "Leader Master"."Leader Code";

            trigger OnValidate()
            begin
                TESTFIELD(Type);
            end;
        }
        field(2; Month; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Jan,Feb,March,April,May,June,July,Aug,Sept,Oct,Nov,Dec';
            OptionMembers = " ",Jan,Feb,March,April,May,June,July,Aug,Sept,Oct,Nov,Dec;

            trigger OnValidate()
            begin
                TESTFIELD(Year);
                IF Month = Month::Jan THEN
                    "Month Number" := 1
                ELSE
                    IF Month = Month::Feb THEN
                        "Month Number" := 2
                    ELSE
                        IF Month = Month::March THEN
                            "Month Number" := 3
                        ELSE
                            IF Month = Month::April THEN
                                "Month Number" := 4
                            ELSE
                                IF Month = Month::May THEN
                                    "Month Number" := 5
                                ELSE
                                    IF Month = Month::June THEN
                                        "Month Number" := 6
                                    ELSE
                                        IF Month = Month::July THEN
                                            "Month Number" := 7
                                        ELSE
                                            IF Month = Month::Aug THEN
                                                "Month Number" := 8
                                            ELSE
                                                IF Month = Month::Sept THEN
                                                    "Month Number" := 9
                                                ELSE
                                                    IF Month = Month::Oct THEN
                                                        "Month Number" := 10
                                                    ELSE
                                                        IF Month = Month::Nov THEN
                                                            "Month Number" := 11
                                                        ELSE
                                                            IF Month = Month::Dec THEN
                                                                "Month Number" := 12;


                IF Month = Month::" " THEN BEGIN
                    "From Date" := 0D;
                    "To Date" := 0D;
                END;

                IF ("Month Number" = 1) OR ("Month Number" = 3) OR ("Month Number" = 5) OR ("Month Number" = 7) OR ("Month Number" = 8) OR ("Month Number" = 10) OR ("Month Number" = 12) THEN BEGIN
                    "From Date" := DMY2DATE(1, "Month Number", Year);
                    "To Date" := DMY2DATE(31, "Month Number", Year);
                END ELSE
                    IF ("Month Number" = 4) OR ("Month Number" = 6) OR ("Month Number" = 9) OR ("Month Number" = 11) THEN BEGIN
                        "From Date" := DMY2DATE(1, "Month Number", Year);
                        "To Date" := DMY2DATE(30, "Month Number", Year);
                    END ELSE
                        IF "Month Number" = 2 THEN BEGIN
                            IF (Year MOD 4) = 0 THEN BEGIN
                                "From Date" := DMY2DATE(1, "Month Number", Year);
                                "To Date" := DMY2DATE(28, "Month Number", Year);
                            END ELSE BEGIN
                                "From Date" := DMY2DATE(1, "Month Number", Year);
                                "To Date" := DMY2DATE(29, "Month Number", Year);
                            END;
                        END;
            end;
        }
        field(3; Year; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Field Type"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Target field master";
        }
        field(7; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Target Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Last Modify By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Last Modify DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Team,Leader,Rank';
            OptionMembers = " ",Team,Leader,Rank;

            trigger OnValidate()
            begin
                TESTFIELD(Code, '');
            end;
        }
        field(16; "Month Number"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(17; Description; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; "Rank Code"; Decimal)
        {
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = FILTER(Rank)) "Rank Code".Code WHERE("Rank Batch Code" = FILTER('R0001'));

            trigger OnValidate()
            begin
                Code := FORMAT("Rank Code");
                RankCode.RESET;
                IF RankCode.GET('R0001', "Rank Code") THEN
                    Description := RankCode.Description;
            end;
        }
    }

    keys
    {
        key(Key1; Type, "Code", Month, Year, "Field Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created By" := USERID;
        "Creation Date" := TODAY;
    end;

    trigger OnModify()
    begin
        "Last Modify By" := USERID;
        "Last Modify DateTime" := CURRENTDATETIME;
    end;

    var
        RankCode: Record "Rank Code";
}

