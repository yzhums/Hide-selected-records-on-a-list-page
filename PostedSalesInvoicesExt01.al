pageextension 50202 PostedSalesInvoicesExt extends "Posted Sales Invoices"
{
    actions
    {
        addbefore("Update Document")
        {
            action(FilterSelected)
            {
                ApplicationArea = All;
                Caption = 'Filter Selected';
                Image = Filter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    CurrPage.Update();
                end;
            }
            action(ResetFilter)
            {
                ApplicationArea = All;
                Caption = 'Reset Filter';
                Image = Filter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Reset();
                    CurrPage.Update();
                end;
            }
            action(ExclusionFilter)
            {
                ApplicationArea = All;
                Caption = 'Exclusion Filter';
                Image = Filter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    Rec.Reset();
                    SalesInvoiceHeader.Reset();
                    CurrPage.SetSelectionFilter(SalesInvoiceHeader);
                    Rec.SetFilter("No.", GetExclusionFilter(SalesInvoiceHeader));
                    CurrPage.Update();
                end;
            }
        }
    }
    local procedure GetExclusionFilter(var SalesInvoiceHeader: Record "Sales Invoice Header"): Text
    var
        Filter: Text;
    begin
        Filter := '';
        if SalesInvoiceHeader.FindSet() then
            repeat
                if Filter = '' then
                    Filter := '<>' + Format(SalesInvoiceHeader."No.")
                else
                    Filter := Filter + '&' + '<>' + Format(SalesInvoiceHeader."No.");
            until SalesInvoiceHeader.Next() = 0;
        exit(Filter);
    end;
}
