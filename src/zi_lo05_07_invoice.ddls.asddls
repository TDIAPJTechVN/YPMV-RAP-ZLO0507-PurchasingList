@AbapCatalog.sqlViewName: 'ZI_LO05_07_INV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LO05_07: I - Get data invoice'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_LO05_07_Invoice
  as select from    I_SuplrInvcItemPurOrdRefAPI01 as Ref
    left outer join I_SupplierInvoiceAPI01        as Rev on  Rev.ReverseDocument           = Ref.SupplierInvoice
                                                         and Rev.ReverseDocumentFiscalYear = Ref.FiscalYear
    left outer join I_TaxCodeRate                 as tax on tax.TaxCode = Ref.TaxCode
  association [1] to I_PurchaseOrderItemAPI01 as _POitem   on  $projection.PurchaseOrder     = _POitem.PurchaseOrder
                                                           and $projection.PurchaseOrderItem = _POitem.PurchaseOrderItem

  association [1] to I_SupplierInvoiceAPI01   as _SInvoice on  $projection.SupplierInvoice = _SInvoice.SupplierInvoice


{
  key Ref.PurchaseOrder       as PurchaseOrder,
  key Ref.PurchaseOrderItem   as PurchaseOrderItem,
      Ref.SupplierInvoice     as SupplierInvoice, // 23a
      Ref.SupplierInvoiceItem as SupplierInvoiceItem,
      _SInvoice.PostingDate   as PostingDate,
      Ref.FiscalYear          as InvoiceYear,     // 23b / 24a
      Ref.SupplierInvoiceItemAmount,
      _SInvoice.InvoiceGrossAmount,
      Ref.DocumentCurrency,
      Ref.SuplrInvcItmUnplndDelivCost,
      Ref.DebitCreditCode,
      Ref.PurchaseOrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      Ref.QuantityInPurchaseOrderUnit,
      tax.ConditionRateRatio,
      tax.ConditionRateRatioUnit
}
where
      Ref.SupplierInvoice is not initial
  and Rev.SupplierInvoice is null // only keep invoices WITHOUT a reversal
