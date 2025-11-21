table 60766 "New Cluster Master"
{
    Caption = 'New Cluster Master';
    DataPerCompany = false;

    fields
    {
        field(1; "Cluster Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(3; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(4; Sequence; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(8; "Mobile State Id"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Cluster State Master";

            trigger OnValidate()
            begin
                IF "Mobile State Id" <> 0 THEN BEGIN
                    ClusterStateMaster.RESET;
                    IF ClusterStateMaster.GET("Mobile State Id") THEN
                        "Mobile State Name" := ClusterStateMaster."State Name";
                    ClusterMaster.RESET;
                    ClusterMaster.SETCURRENTKEY("Mobile State Id", Sequence);
                    ClusterMaster.SETRANGE("Mobile State Id", "Mobile State Id");
                    ClusterMaster.SETFILTER(Sequence, '>%1', 0);
                    IF ClusterMaster.FINDLAST THEN
                        Sequence := ClusterMaster.Sequence + 1
                    ELSE
                        Sequence := 1;
                END ELSE
                    Sequence := 0;
            end;
        }
        field(9; "Mobile State Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Region Code"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
    }

    keys
    {
        key(Key1; "Cluster Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Status, Status::Open);
    end;

    var
        ClusterMaster: Record "New Cluster Master";
        ClusterStateMaster: Record "Cluster State Master";
}

