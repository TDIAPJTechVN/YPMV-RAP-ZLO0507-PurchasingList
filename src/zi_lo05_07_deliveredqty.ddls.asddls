//@AbapCatalog.sqlViewName: 'ZI_LO05_07_DQTY'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LO05_07: I - Delivered Quantity'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_LO05_07_DeliveredQty
  as select from I_MaterialDocumentItem_2 as MatDoc
    left outer join I_MaterialDocumentItem_2 as RevDoc
      on  RevDoc.ReversedMaterialDocument      = MatDoc.MaterialDocument
      and RevDoc.ReversedMaterialDocumentItem  = MatDoc.MaterialDocumentItem
      and RevDoc.ReversedMaterialDocumentYear  = MatDoc.MaterialDocumentYear
{
  key MatDoc.PurchaseOrder      as PurchaseOrder,
  key MatDoc.PurchaseOrderItem  as PurchaseOrderItem,
      MatDoc.MaterialBaseUnit,
       @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( MatDoc.QuantityInBaseUnit ) as DeliveredQty
}
where
      MatDoc.GoodsMovementType = '101'      // GR for PO
  and RevDoc.MaterialDocument is null       // only matdocs not reversed
group by
  MatDoc.PurchaseOrder,
  MatDoc.PurchaseOrderItem,
  MatDoc.MaterialBaseUnit;
