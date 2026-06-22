@AbapCatalog.sqlViewName: 'ZI_LO05_07_PD'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LO05_07: I - Get data invoice'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_LO05_07_PurOrdAccount
  as select from I_PurOrdAccountAssignmentAPI01 as PurOrdAccount
    inner join   I_PurchaseOrderItemAPI01       as POitem  on  POitem.PurchaseOrder     = PurOrdAccount.PurchaseOrder
                                                           and POitem.PurchaseOrderItem = PurOrdAccount.PurchaseOrderItem
    inner join   I_EntProjWrkBrkdwnStrucElmntVH as EntProj on EntProj.WBSElementInternalID = PurOrdAccount.WBSElementInternalID
{
  key PurOrdAccount.PurchaseOrder,
  key PurOrdAccount.PurchaseOrderItem,
      EntProj.WBSElementInternalID,
      EntProj.ProjectElement as Project,
      EntProj.ProjectElementDescription as ProjectDescription
}
where EntProj.WBSElementInternalID is not initial
