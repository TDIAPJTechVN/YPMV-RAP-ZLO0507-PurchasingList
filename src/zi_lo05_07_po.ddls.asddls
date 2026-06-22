@AbapCatalog.sqlViewName: 'ZI_LO05_07_PO_CR'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LO05_07: I - Get data invoice'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_LO05_07_PO
  as select from    I_PurchaseOrderAPI01 as PO
    left outer join I_BusinessUserBasic  as User             on User.UserID = PO.CreatedByUser
    left outer join I_Supplier           as Supplier         on Supplier.Supplier = PO.Supplier
    left outer join I_PaymentTermsText   as PaymentTermsText on PaymentTermsText.PaymentTerms = PO.PaymentTerms
    and PaymentTermsText.Language = '쁩'

{
  key PO.PurchaseOrder,
      User.CreatedByUser,
      User.PersonFullName,
      Supplier.SupplierName,
      PaymentTermsText.PaymentTermsName
}
