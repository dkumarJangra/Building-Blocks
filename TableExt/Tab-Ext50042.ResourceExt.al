tableextension 50042 "BBG Resource Ext" extends Resource
{
    fields
    {
        // Add changes to table fields here
        modify("Resource Group No.")
        {
            trigger OnAfterValidate()
            begin

                //AlleBLK
                // Job Budget Entries
                //JobBudgetEntry.SETCURRENTKEY("Job Status",Type,"No.");
                JobBudgetEntry.SETRANGE(Type, JobBudgetEntry.Type::Resource);
                JobBudgetEntry.SETRANGE("No.", "No.");
                JobBudgetEntry.MODIFYALL("Resource Group No.", "Resource Group No.");
                //AlleBLK

                //MODIFY;
            end;
        }
        field(50000; Rented; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0009 09-07-2007';

            trigger OnValidate()
            begin
                IF "FA ID" <> '' THEN
                    ERROR('FA ID Must be Blank');
                IF "Emp ID" <> '' THEN
                    ERROR('Employee ID Must be Blank');
            end;
        }
        field(50001; "FA ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ND';
            Editable = false;
            TableRelation = "Fixed Asset";
        }
        field(50002; "Emp ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ND';
            Editable = false;
            TableRelation = Employee;
        }
        field(50003; "Last Reading"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 141011';
            Editable = true;
        }
        field(50004; "Last Reading Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 141011';
            Editable = true;
        }
        field(60052; "Timesheet Entry Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'dds for EHS';
            TableRelation = "Res. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Timesheet Entry Template"));
        }
        field(60053; HOD; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'dds for EHS';
        }
        field(60054; "Timesheet Entry Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'dds for EHS';
            TableRelation = "Res. Journal Template".Name;
        }
        field(60056; "Additional Timesheet Entry"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'dds for EHS';
            TableRelation = "Res. Journal Template".Name;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        JobBudgetEntry: Record "Job Planning Line";
}