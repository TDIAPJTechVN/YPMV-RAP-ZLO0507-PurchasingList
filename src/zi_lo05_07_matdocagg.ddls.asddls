@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LO05_07: I - MatDoc Aggregated'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_LO05_07_MatDocAgg
  as select from I_MaterialDocumentItem_2 as MatDoc
    left outer join I_MaterialDocumentItem_2 as RevDoc
      on  RevDoc.ReversedMaterialDocument     = MatDoc.MaterialDocument
      and RevDoc.ReversedMaterialDocumentItem = MatDoc.MaterialDocumentItem
      and RevDoc.ReversedMaterialDocumentYear = MatDoc.MaterialDocumentYear
{
  key MatDoc.PurchaseOrder       as PurchaseOrder,
  key MatDoc.PurchaseOrderItem   as PurchaseOrderItem,
      max( MatDoc.PostingDate )  as PostingDate
}
where
      MatDoc.GoodsMovementType = '101'    // GR 101
  and RevDoc.MaterialDocument is null     // chỉ lấy matdoc chưa bị reverse
group by
  MatDoc.PurchaseOrder,
  MatDoc.PurchaseOrderItem;
