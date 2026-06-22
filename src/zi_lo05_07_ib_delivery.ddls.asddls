@AbapCatalog.sqlViewName: 'ZI_LO05_07_IB'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LO05_07: I - Get data IB Delivery'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_LO05_07_IB_Delivery
  as select from I_InboundDeliveryItem as Ibitem
    inner join   I_InboundDelivery     as ibhdr on ibhdr.InboundDelivery = Ibitem.InboundDelivery
{
  key Ibitem.PurchaseOrder                    as PurchaseOrder,
  key Ibitem.PurchaseOrderItem                as PurchaseOrderItem,

      max( ibhdr.BillOfLading )               as BillOfLading,
      max( ibhdr.TransportationPlanningDate ) as TrPlanDate,
      max( ibhdr.DeliveryDate )               as DeliveryDate
}
where
      ibhdr.InboundDelivery         is not initial
  and Ibitem.ActualDeliveryQuantity > 0
group by
  Ibitem.PurchaseOrder,
  Ibitem.PurchaseOrderItem
