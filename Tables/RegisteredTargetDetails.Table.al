table 60767 "Registered Target Details"
{
    DataPerCompany = false;

    fields
    {
        field(1; Month; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;

            trigger OnValidate()
            begin
                IF "Creation Date" <> 0D THEN BEGIN
                    "Last Modified By" := USERID;
                    "Last Modified Date" := TODAY;
                    "Last Modified Time" := TIME;
                END;

                IF Year <> 0 THEN BEGIN
                    UpdateMonthNumber;
                    UpdateDate;
                END;
            end;
        }
        field(2; Year; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Month);
                UpdateMonthNumber;
                IF "Creation Date" <> 0D THEN BEGIN
                    "Last Modified By" := USERID;
                    "Last Modified Date" := TODAY;
                    "Last Modified Time" := TIME;
                END;


                UpdateDate;
            end;
        }
        field(4; "No. of Plot Target"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                TESTFIELD(Month);
                TESTFIELD(Year);
                TESTFIELD("Region Code");
                IF "Creation Date" = 0D THEN BEGIN
                    "Creation Date" := TODAY;
                    "Creation Time" := TIME;
                    "Created By" := USERID;
                END ELSE BEGIN
                    "Last Modified By" := USERID;
                    "Last Modified Date" := TODAY;
                    "Last Modified Time" := TIME;
                END;
            end;
        }
        field(5; "Region Code"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Creation Date" <> 0D THEN BEGIN
                    "Last Modified By" := USERID;
                    "Last Modified Date" := TODAY;
                    "Last Modified Time" := TIME;
                END;
            end;
        }
        field(6; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Last Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Last Modified Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Last Modified Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Created By"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "To Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Month Number"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Achived Plots"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Previouse Month Bal. Target"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "Balance Target"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Actual Target"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Closed;
        }
        field(20; Received; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; Month, Year, "Region Code")
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
        "Creation Time" := TIME;
    end;

    var
        PlotRegistrationDetails: Record "Plot Registration Details";

    local procedure UpdateDate()
    begin
        IF (Month = Month::January) OR (Month = Month::March) OR (Month = Month::May) OR (Month = Month::July) OR (Month = Month::August)
          OR (Month = Month::October) OR (Month = Month::December) THEN BEGIN
            "From Date" := DMY2DATE(1, "Month Number", Year);
            "To Date" := DMY2DATE(31, "Month Number", Year);
        END ELSE
            IF (Month = Month::April) OR (Month = Month::June) OR (Month = Month::September) OR (Month = Month::November) THEN BEGIN
                "From Date" := DMY2DATE(1, "Month Number", Year);
                "To Date" := DMY2DATE(30, "Month Number", Year);
            END ELSE
                IF Month = Month::February THEN BEGIN
                    IF Year MOD 4 <> 0 THEN BEGIN
                        "From Date" := DMY2DATE(1, 2, Year);
                        "To Date" := DMY2DATE(28, 2, Year);
                    END ELSE BEGIN
                        "From Date" := DMY2DATE(1, 2, Year);
                        "To Date" := DMY2DATE(29, 2, Year);
                    END;
                END;
    end;

    local procedure UpdateMonthNumber()
    begin
        IF Month = Month::January THEN
            "Month Number" := 1
        ELSE
            IF Month = Month::February THEN
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
                                    IF Month = Month::August THEN
                                        "Month Number" := 8
                                    ELSE
                                        IF Month = Month::September THEN
                                            "Month Number" := 9
                                        ELSE
                                            IF Month = Month::October THEN
                                                "Month Number" := 10
                                            ELSE
                                                IF Month = Month::November THEN
                                                    "Month Number" := 11
                                                ELSE
                                                    IF Month = Month::December THEN
                                                        "Month Number" := 12;
    end;
}

