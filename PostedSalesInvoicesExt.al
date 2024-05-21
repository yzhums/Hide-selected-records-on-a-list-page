pageextension 50202 PostedSalesInvoicesExt extends "Posted Sales Invoices"
{
    actions
    {
        addbefore("Update Document")
        {
            action(Hideselected)
            {
                ApplicationArea = All;
                Caption = 'Hide selected';
                Image = Filter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    Filter := '';
                    Rec.Reset();
                    SalesInvoiceHeader.Reset();
                    CurrPage.SetSelectionFilter(SalesInvoiceHeader);
                    SalesReceivablesSetup.Get();
                    Filter := SalesReceivablesSetup."Hidden Posted Sales Invoices";
                    SetExclusionFilter(SalesInvoiceHeader);
                    Rec.filtergroup(100);
                    Rec.SetFilter("No.", SalesReceivablesSetup."Hidden Posted Sales Invoices");
                    Rec.FilterGroup(0);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SalesReceivablesSetup.Get();
        if SalesReceivablesSetup."Hidden Posted Sales Invoices" <> '' then begin
            Rec.filtergroup(100);
            Rec.SetFilter("No.", SalesReceivablesSetup."Hidden Posted Sales Invoices");
            Rec.FilterGroup(0);
        end;
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Filter: Text;

    local procedure SetExclusionFilter(var SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        if SalesInvoiceHeader.FindSet() then
            repeat
                if Filter = '' then
                    Filter := '<>' + Format(SalesInvoiceHeader."No.")
                else
                    Filter := Filter + '&' + '<>' + Format(SalesInvoiceHeader."No.");
            until SalesInvoiceHeader.Next() = 0;
        if Filter <> '' then begin
            SalesReceivablesSetup.Get();
            SalesReceivablesSetup."Hidden Posted Sales Invoices" := Filter;
            SalesReceivablesSetup.Modify(true);
        end;
    end;
}

tableextension 50200 SalesReceivablesSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(50200; "Hidden Posted Sales Invoices"; Text[2048])
        {
            Caption = 'Hidden Posted Sales Invoices';
            DataClassification = CustomerContent;
        }
    }
}

pageextension 50200 SalesReceivablesSetupPageExt extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Credit Warnings")
        {
            field("Hidden Posted Sales Invoices"; Rec."Hidden Posted Sales Invoices")
            {
                ApplicationArea = All;
            }
        }
    }
}
